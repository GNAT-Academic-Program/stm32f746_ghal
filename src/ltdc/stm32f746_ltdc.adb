with Ada.Interrupts.Names;
with Ada.Unchecked_Conversion;
with Interfaces;         use Interfaces;
with STM32F746;
with STM32F746.LTDC;     use STM32F746.LTDC;
with STM32F746.RCC;      use STM32F746.RCC;

use type STM32F746.Bit;
use type STM32F746.UInt2;
use type STM32F746.UInt3;
use type STM32F746.UInt9;
use type STM32F746.UInt16;
use type STM32F746.UInt32;

package body STM32F746_LTDC is

   --  Panel timing for RK043FN48H
   H_Sync        : constant := 41;
   H_Back_Porch  : constant := 13;
   H_Front_Porch : constant := 32;
   V_Sync        : constant := 10;
   V_Back_Porch  : constant := 2;
   V_Front_Porch : constant := 2;

   --  PLLSAI: 192 / 5 / 4 = 9.6 MHz pixel clock
   PLLSAI_N    : constant := 192;
   PLLSAI_R    : constant := 5;
   PLLSAI_DIVR : constant := 4;

   --  Blending factor register encoding (STM32 LTDC BF1/BF2 field values)
   BF1_Constant_Alpha : constant STM32F746.UInt3 := 2#100#;
   BF2_Constant_Alpha : constant STM32F746.UInt3 := 2#101#;
   BF1_Pixel_Alpha    : constant STM32F746.UInt3 := 2#110#;
   BF2_Pixel_Alpha    : constant STM32F746.UInt3 := 2#111#;

   --  One-shot init guard — ONLY cached state allowed in this file
   LTDC_Initialized : Boolean := False;

   --  VSync reload synchronization
   protected Sync is
      pragma Interrupt_Priority;
      entry Wait;
      procedure Apply_On_VSync;
      procedure Interrupt;
      pragma Attach_Handler
        (Interrupt, Ada.Interrupts.Names.LTDC_Interrupt);
   private
      Not_Pending : Boolean := True;
   end Sync;

   protected body Sync is
      entry Wait when Not_Pending is
      begin null; end Wait;

      procedure Apply_On_VSync is
      begin
         Not_Pending := False;
         LTDC_Periph.IER.RRIE := 1;
         LTDC_Periph.SRCR.VBR := 1;
      end Apply_On_VSync;

      procedure Interrupt is
      begin
         if LTDC_Periph.ISR.RRIF = 1 then
            LTDC_Periph.IER.RRIE  := 0;
            LTDC_Periph.ICR.CRRIF := 1;
            Not_Pending := True;
         end if;
      end Interrupt;
   end Sync;

   --  Map DC_Types.Pixel_Format to LTDC PFCR.PF register value (3 bits)
   function To_PF (F : Pixel_Format) return STM32F746.UInt3 is
     (case F is
         when ARGB8888 => 0,
         when RGB888   => 1,
         when RGB565   => 2,
         when ARGB1555 => 3,
         when ARGB4444 => 4,
         when L8       => 5,
         when AL44     => 6,
         when AL88     => 7);

   --  Layer register helpers — body-private
   procedure Set_WHPCR (Layer : LCD_Layer; WHSTPOS, WHSPPOS : STM32F746.UInt12) is
   begin
      case Layer is
         when Layer_1 =>
            LTDC_Periph.L1WHPCR :=
              (WHSTPOS => L1WHPCR_WHSTPOS_Field (WHSTPOS),
               WHSPPOS => L1WHPCR_WHSPPOS_Field (WHSPPOS),
               others  => <>);
         when Layer_2 =>
            LTDC_Periph.L2WHPCR :=
              (WHSTPOS => L2WHPCR_WHSTPOS_Field (WHSTPOS),
               WHSPPOS => L2WHPCR_WHSPPOS_Field (WHSPPOS),
               others  => <>);
      end case;
   end Set_WHPCR;

   procedure Set_WVPCR (Layer : LCD_Layer; WVSTPOS, WVSPPOS : STM32F746.UInt11) is
   begin
      case Layer is
         when Layer_1 =>
            LTDC_Periph.L1WVPCR :=
              (WVSTPOS => L1WVPCR_WVSTPOS_Field (WVSTPOS),
               WVSPPOS => L1WVPCR_WVSPPOS_Field (WVSPPOS),
               others => <>);
         when Layer_2 =>
            LTDC_Periph.L2WVPCR :=
              (WVSTPOS => L2WVPCR_WVSTPOS_Field (WVSTPOS),
               WVSPPOS => L2WVPCR_WVSPPOS_Field (WVSPPOS),
               others => <>);
      end case;
   end Set_WVPCR;

   procedure Set_PFCR (Layer : LCD_Layer; PF : STM32F746.UInt3) is
   begin
      case Layer is
         when Layer_1 => LTDC_Periph.L1PFCR.PF := L1PFCR_PF_Field (PF);
         when Layer_2 => LTDC_Periph.L2PFCR.PF := L2PFCR_PF_Field (PF);
      end case;
   end Set_PFCR;

   procedure Set_CACR (Layer : LCD_Layer; Alpha : STM32F746.Byte) is
   begin
      case Layer is
         when Layer_1 => LTDC_Periph.L1CACR.CONSTA := L1CACR_CONSTA_Field (Alpha);
         when Layer_2 => LTDC_Periph.L2CACR.CONSTA := L2CACR_CONSTA_Field (Alpha);
      end case;
   end Set_CACR;

   procedure Set_BFCR (Layer : LCD_Layer; BF1, BF2 : STM32F746.UInt3) is
   begin
      case Layer is
         when Layer_1 =>
            LTDC_Periph.L1BFCR.BF1 := L1BFCR_BF1_Field (BF1);
            LTDC_Periph.L1BFCR.BF2 := L1BFCR_BF2_Field (BF2);
         when Layer_2 =>
            LTDC_Periph.L2BFCR.BF1 := L2BFCR_BF1_Field (BF1);
            LTDC_Periph.L2BFCR.BF2 := L2BFCR_BF2_Field (BF2);
      end case;
   end Set_BFCR;

   procedure Set_CFBLR (Layer : LCD_Layer; CFBLL, CFBP : STM32F746.UInt13) is
   begin
      case Layer is
         when Layer_1 =>
            LTDC_Periph.L1CFBLR :=
              (CFBLL => L1CFBLR_CFBLL_Field (CFBLL),
               CFBP  => L1CFBLR_CFBP_Field (CFBP),
               others => <>);
         when Layer_2 =>
            LTDC_Periph.L2CFBLR :=
              (CFBLL => L2CFBLR_CFBLL_Field (CFBLL),
               CFBP  => L2CFBLR_CFBP_Field (CFBP),
               others => <>);
      end case;
   end Set_CFBLR;

   procedure Set_CFBLNR (Layer : LCD_Layer; N : STM32F746.UInt11) is
   begin
      case Layer is
         when Layer_1 => LTDC_Periph.L1CFBLNR.CFBLNBR := L1CFBLNR_CFBLNBR_Field (N);
         when Layer_2 => LTDC_Periph.L2CFBLNR.CFBLNBR := L2CFBLNR_CFBLNBR_Field (N);
      end case;
   end Set_CFBLNR;

   procedure Set_CFBAR (Layer : LCD_Layer; Addr : STM32F746.UInt32) is
   begin
      case Layer is
         when Layer_1 => LTDC_Periph.L1CFBAR := Addr;
         when Layer_2 => LTDC_Periph.L2CFBAR := Addr;
      end case;
   end Set_CFBAR;

   function Get_CFBAR (Layer : LCD_Layer) return STM32F746.UInt32 is
   begin
      case Layer is
         when Layer_1 => return LTDC_Periph.L1CFBAR;
         when Layer_2 => return LTDC_Periph.L2CFBAR;
      end case;
   end Get_CFBAR;

   procedure Set_LEN (Layer : LCD_Layer; Enabled : Boolean) is
   begin
      case Layer is
         when Layer_1 => LTDC_Periph.L1CR.LEN := (if Enabled then 1 else 0);
         when Layer_2 => LTDC_Periph.L2CR.LEN := (if Enabled then 1 else 0);
      end case;
   end Set_LEN;

   ------------------------
   -- Driver_Initialize --
   ------------------------

   procedure Driver_Initialize is
      TH, TV   : STM32F746.UInt16;
      DivR_Val : STM32F746.UInt2;
   begin
      if LTDC_Initialized then return; end if;

      --  Configure PLLSAI for 9.6 MHz pixel clock (192 / 5 / 4)
      case PLLSAI_DIVR is
         when 2  => DivR_Val := 0;
         when 4  => DivR_Val := 1;
         when 8  => DivR_Val := 2;
         when 16 => DivR_Val := 3;
         when others => raise Constraint_Error with "Invalid PLLSAI_DIVR";
      end case;

      --  Disable PLLSAI before any configuration (matches Ada Drivers Library pattern)
      --  Note: Ada Drivers Library just disables without waiting
      RCC_Periph.CR.PLLSAION := 0;

      --  Enable LTDC clock and reset
      RCC_Periph.APB2ENR.LTDCEN   := 1;
      RCC_Periph.APB2RSTR.LTDCRST := 1;
      RCC_Periph.APB2RSTR.LTDCRST := 0;

      --  Disable controller and layers before configuring
      LTDC_Periph.GCR.LTDCEN := 0;
      LTDC_Periph.L1CR.LEN   := 0;
      LTDC_Periph.L2CR.LEN   := 0;

      --  Polarities: RK043FN48H uses active-low sync, inverted pixel clock
      LTDC_Periph.GCR.HSPOL := 0;
      LTDC_Periph.GCR.VSPOL := 0;
      LTDC_Periph.GCR.DEPOL := 0;
      LTDC_Periph.GCR.PCPOL := 1;

      --  Configure and enable PLLSAI AFTER LTDC reset (matches Ada Drivers Library)
      RCC_Periph.PLLSAICFGR.PLLSAIN :=
        PLLSAICFGR_PLLSAIN_Field (PLLSAI_N);
      RCC_Periph.PLLSAICFGR.PLLSAIR :=
        PLLSAICFGR_PLLSAIR_Field (PLLSAI_R);
      RCC_Periph.DKCFGR1.PLLSAIDIVR :=
        DKCFGR1_PLLSAIDIVR_Field (DivR_Val);

      RCC_Periph.CR.PLLSAION := 1;
      while RCC_Periph.CR.PLLSAIRDY = 0 loop
         null;
      end loop;

      --  TH = horizontal accumulator, TV = vertical accumulator
      --  SSCR: HSW = horizontal sync width - 1, VSH = vertical sync height - 1
      TH := STM32F746.UInt16 (H_Sync - 1);
      TV := STM32F746.UInt16 (V_Sync - 1);
      LTDC_Periph.SSCR :=
        (HSW => SSCR_HSW_Field (TH),
         VSH => SSCR_VSH_Field (TV),
         others => <>);

      --  BPCR: AHBP = accumulated horiz back porch, AVBP = accumulated vert
      TH := TH + STM32F746.UInt16 (H_Back_Porch);
      TV := TV + STM32F746.UInt16 (V_Back_Porch);
      LTDC_Periph.BPCR :=
        (AHBP => BPCR_AHBP_Field (TH),
         AVBP => BPCR_AVBP_Field (TV),
         others => <>);

      --  AWCR: AAH = accumulated active horiz (width), AAV = accumulated active vert (height)
      TH := TH + STM32F746.UInt16 (LCD_Width);
      TV := TV + STM32F746.UInt16 (LCD_Height);
      LTDC_Periph.AWCR :=
        --  The generated F746 SVD names are misleading here:
        --    low  bits 0..10  are active height
        --    high bits 16..25 are active width
        --  So write vertical timing to AAH and horizontal timing to AAV.
        (AAH => AWCR_AAH_Field (TV),
         AAV => AWCR_AAV_Field (TH),
         others => <>);

      --  TWCR: TOTALW = total horiz, TOTALH = total vert
      TH := TH + STM32F746.UInt16 (H_Front_Porch);
      TV := TV + STM32F746.UInt16 (V_Front_Porch);
      LTDC_Periph.TWCR :=
        (TOTALW => TWCR_TOTALW_Field (TH),
         TOTALH => TWCR_TOTALH_Field (TV),
         others => <>);

      --  Black background, enable controller
      LTDC_Periph.BCCR.BC    := 0;
      LTDC_Periph.GCR.LTDCEN := 1;

      LTDC_Initialized := True;
   end Driver_Initialize;

   function Driver_Is_Initialized return Boolean is (LTDC_Initialized);

   procedure Driver_Start is
   begin LTDC_Periph.GCR.LTDCEN := 1; end Driver_Start;

   procedure Driver_Stop is
   begin LTDC_Periph.GCR.LTDCEN := 0; end Driver_Stop;

   procedure Driver_Set_Background (R, G, B : UInt8) is
      RShift : constant STM32F746.UInt32 := STM32F746.UInt32 (Shift_Left (Unsigned_32 (R), 16));
      GShift : constant STM32F746.UInt32 := STM32F746.UInt32 (Shift_Left (Unsigned_32 (G), 8));
   begin
      LTDC_Periph.BCCR.BC :=
        BCCR_BC_Field (RShift or GShift or STM32F746.UInt32 (B));
   end Driver_Set_Background;

   procedure Driver_Reload (Mode : Reload_Mode) is
   begin
      case Mode is
         when Immediate =>
            LTDC_Periph.SRCR.IMR := 1;
            loop exit when LTDC_Periph.SRCR.IMR = 0; end loop;
         when On_VSync =>
            Sync.Apply_On_VSync;
            Sync.Wait;
      end case;
   end Driver_Reload;

   procedure Driver_Reload_Async     is begin Sync.Apply_On_VSync; end;
   procedure Driver_Wait_For_Reload  is begin Sync.Wait;           end;

   procedure Driver_Layer_Init
     (Layer : LCD_Layer; Format : Pixel_Format; Buffer : System.Address;
      X, Y : Natural; W, H : Positive; Constant_Alpha : UInt8;
      BF : Blending_Factor)
   is
      function To_U32 is new Ada.Unchecked_Conversion (System.Address, STM32F746.UInt32);
      AHBP        : constant STM32F746.UInt16 := STM32F746.UInt16 (LTDC_Periph.BPCR.AHBP);
      AVBP        : constant STM32F746.UInt16 := STM32F746.UInt16 (LTDC_Periph.BPCR.AVBP);
      Bytes_Per_Pixel : constant Positive := (case Format is
         when ARGB8888                        => 4,
         when RGB888                          => 3,
         when RGB565 | ARGB1555 | ARGB4444
            | AL88                            => 2,
         when L8 | AL44                       => 1);
   begin
      Set_WHPCR (Layer,
        WHSTPOS => STM32F746.UInt12 (AHBP + 1 + STM32F746.UInt16 (X)),
        WHSPPOS => STM32F746.UInt12 (AHBP + STM32F746.UInt16 (X + W)));
      Set_WVPCR (Layer,
        WVSTPOS => STM32F746.UInt11 (AVBP + 1 + STM32F746.UInt16 (Y)),
        WVSPPOS => STM32F746.UInt11 (AVBP + STM32F746.UInt16 (Y + H)));
      Set_PFCR (Layer, To_PF (Format));
      Set_CACR (Layer, STM32F746.Byte (Constant_Alpha));
      case BF is
         when BF_Constant_Alpha =>
            Set_BFCR (Layer, BF1_Constant_Alpha, BF2_Constant_Alpha);
         when BF_Pixel_Alpha_X_Constant_Alpha =>
            Set_BFCR (Layer, BF1_Pixel_Alpha, BF2_Pixel_Alpha);
      end case;
      Set_CFBLR  (Layer,
        CFBLL => STM32F746.UInt13 (W * Bytes_Per_Pixel + 3),
        CFBP  => STM32F746.UInt13 (W * Bytes_Per_Pixel));
      Set_CFBLNR (Layer, STM32F746.UInt11 (H));
      Set_CFBAR  (Layer, To_U32 (Buffer));
      Set_LEN    (Layer, True);
      Driver_Reload (Immediate);
   end Driver_Layer_Init;

   procedure Driver_Set_Frame_Buffer (Layer : LCD_Layer; Addr : System.Address) is
      function To_U32 is new Ada.Unchecked_Conversion (System.Address, STM32F746.UInt32);
   begin
      Set_CFBAR (Layer, To_U32 (Addr));
   end Driver_Set_Frame_Buffer;

   function Driver_Get_Frame_Buffer (Layer : LCD_Layer) return System.Address is
      function To_Addr is new Ada.Unchecked_Conversion (STM32F746.UInt32, System.Address);
   begin
      return To_Addr (Get_CFBAR (Layer));
   end Driver_Get_Frame_Buffer;

   procedure Driver_Set_Layer_State (Layer : LCD_Layer; Enabled : Boolean) is
   begin
      Set_LEN (Layer, Enabled);
      Driver_Reload (Immediate);
   end Driver_Set_Layer_State;

end STM32F746_LTDC;

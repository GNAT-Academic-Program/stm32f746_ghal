with Ada.Interrupts.Names;
with Ada.Unchecked_Conversion;
with System;
with Interfaces;         use Interfaces;
with STM32F746;
with STM32F746.DMA2D;    use STM32F746.DMA2D;
with STM32F746.RCC;      use STM32F746.RCC;
with Cortex_M.Cache;

use type STM32F746.Bit;
use type STM32F746.UInt3;
use type STM32F746.UInt4;
use type STM32F746.Byte;
use type STM32F746.UInt14;
use type STM32F746.UInt16;
use type STM32F746.UInt32;

package body STM32F746_DMA2D is

   function To_Word is new Ada.Unchecked_Conversion (System.Address, STM32F746.UInt32);
   function To_OCOLR is new Ada.Unchecked_Conversion
     (STM32F746.UInt32, OCOLR_Register);

   --  Map Bitmap_Color_Mode to DMA2D PFCCR.CM field (4 bits for FG/BG)
   function CM_Reg (CM : Bitmap_Color_Mode) return STM32F746.UInt4 is
     (case CM is
         when ARGB_8888 => 0,
         when RGB_888   => 1,
         when RGB_565   => 2,
         when ARGB_1555 => 3,
         when ARGB_4444 => 4,
         when L_8       => 5,
         when AL_44     => 6,
         when AL_88     => 7,
         when L_4       => 8,
         when A_8       => 9,
         when A_4       => 10);

   --  Output PFCCR.CM is 3 bits — mask to lower 3
   function CM_Reg3 (CM : Bitmap_Color_Mode) return STM32F746.UInt3 is
     (STM32F746.UInt3 (CM_Reg (CM) and 7));

   function Color_To_Word
     (CM : Bitmap_Color_Mode; Color : Bitmap_Color) return STM32F746.UInt32
   is
      Ret : STM32F746.UInt32 := 0;

      procedure Add_U8 (Value : Unsigned_8; Pos : Natural; Size : Positive) is
         Val : constant STM32F746.UInt32 := STM32F746.UInt32
           (Shift_Left
              (Unsigned_32
                 (Shift_Right
                    (Unsigned_32 (Value), abs (Integer (Size) - 8))),
               Pos));
      begin
         Ret := Ret or Val;
      end Add_U8;

      function Luminance return Unsigned_8 is
        (Unsigned_8
           (Shift_Right
              (Unsigned_32 (Color.Red) * 3 + Unsigned_32 (Color.Blue) +
               Unsigned_32 (Color.Green) * 4,
               3)));
   begin
      case CM is
         when ARGB_8888 =>
            Add_U8 (Color.Alpha, 24, 8);
            Add_U8 (Color.Red,   16, 8);
            Add_U8 (Color.Green,  8, 8);
            Add_U8 (Color.Blue,   0, 8);
         when RGB_888 =>
            Add_U8 (Color.Red,   16, 8);
            Add_U8 (Color.Green,  8, 8);
            Add_U8 (Color.Blue,   0, 8);
         when RGB_565 =>
            Add_U8 (Color.Red,   11, 5);
            Add_U8 (Color.Green,  5, 6);
            Add_U8 (Color.Blue,   0, 5);
         when ARGB_1555 =>
            Add_U8 (Color.Alpha, 15, 1);
            Add_U8 (Color.Red,   10, 5);
            Add_U8 (Color.Green,  5, 5);
            Add_U8 (Color.Blue,   0, 5);
         when ARGB_4444 =>
            Add_U8 (Color.Alpha, 12, 4);
            Add_U8 (Color.Red,    8, 4);
            Add_U8 (Color.Green,  4, 4);
            Add_U8 (Color.Blue,   0, 4);
         when L_8 =>
            Add_U8 (Luminance, 0, 8);
         when AL_44 =>
            Add_U8 (Color.Alpha, 4, 4);
            Add_U8 (Luminance,   0, 4);
         when AL_88 =>
            Add_U8 (Color.Alpha, 8, 8);
            Add_U8 (Luminance,   0, 8);
         when L_4 =>
            Add_U8 (Luminance, 0, 4);
         when A_8 =>
            Add_U8 (Color.Alpha, 0, 8);
         when A_4 =>
            Add_U8 (Color.Alpha, 0, 4);
      end case;

      return Ret;
   end Color_To_Word;

   function Pixel_Offset (Buffer : Bitmap_Buffer; X, Y : Natural) return STM32F746.UInt32 is
     (STM32F746.UInt32 (X + Buffer.Width * Y) *
      STM32F746.UInt32 (UInt8s_Per_Pixel (Buffer.Color_Mode)));

   protected Sync is
      pragma Interrupt_Priority;
      entry Wait;
      procedure Start_Transfer;
      procedure Interrupt;
      pragma Attach_Handler
        (Interrupt, Ada.Interrupts.Names.DMA2D_Interrupt);
   private
      Ready : Boolean := True;
   end Sync;

   protected body Sync is
      entry Wait when Ready is
      begin null; end Wait;

      procedure Start_Transfer is
      begin
         Ready := False;
         DMA2D_Periph.IFCR.CCEIF := 1;
         DMA2D_Periph.IFCR.CTCIF := 1;
         DMA2D_Periph.IFCR.CTEIF := 1;
         DMA2D_Periph.CR.CEIE    := 1;
         DMA2D_Periph.CR.TCIE    := 1;
         DMA2D_Periph.CR.TEIE    := 1;
         DMA2D_Periph.CR.START   := 1;
      end Start_Transfer;

      procedure Interrupt is
      begin
         if DMA2D_Periph.ISR.CEIF = 1 or DMA2D_Periph.ISR.TEIF = 1 then
            DMA2D_Periph.IFCR.CCEIF := 1;
            DMA2D_Periph.IFCR.CTEIF := 1;
            Ready := True;
         elsif DMA2D_Periph.ISR.TCIF = 1 then
            DMA2D_Periph.IFCR.CTCIF := 1;
            Ready := True;
         end if;
         DMA2D_Periph.CR.CEIE := 0;
         DMA2D_Periph.CR.TCIE := 0;
         DMA2D_Periph.CR.TEIE := 0;
      end Interrupt;
   end Sync;

   procedure Launch (Synchronous : Boolean) is
   begin
      Sync.Start_Transfer;
      if Synchronous then Sync.Wait; end if;
   end Launch;

   procedure Initialize is
   begin
      RCC_Periph.AHB1ENR.DMA2DEN   := 1;
      RCC_Periph.AHB1RSTR.DMA2DRST := 1;
      RCC_Periph.AHB1RSTR.DMA2DRST := 0;
   end Initialize;

   procedure Fill (Buffer : Bitmap_Buffer; Color : Bitmap_Color;
                   Synchronous : Boolean := False) is
   begin
      Sync.Wait;
      DMA2D_Periph.CR.MODE   := 2#11#;
      DMA2D_Periph.OPFCCR.CM := CM_Reg3 (Buffer.Color_Mode);
      DMA2D_Periph.OCOLR     := To_OCOLR (Color_To_Word (Buffer.Color_Mode, Color));
      
      DMA2D_Periph.OMAR      := To_Word (Buffer.Addr);
      DMA2D_Periph.OOR.LO    := 0;
      DMA2D_Periph.NLR       :=
        (NL => STM32F746.UInt16 (Buffer.Height), PL => STM32F746.UInt14 (Buffer.Width),
         others => <>);
      Launch (Synchronous);
   end Fill;

   procedure Fill_Rect (Buffer : Bitmap_Buffer; Color : Bitmap_Color;
                        X, Y : Integer; Width, Height : Natural;
                        Synchronous : Boolean := False) is
      Off : constant STM32F746.UInt32 := Pixel_Offset (Buffer, Natural (X), Natural (Y));
   begin
      Sync.Wait;
      DMA2D_Periph.CR.MODE   := 2#11#;
      DMA2D_Periph.OPFCCR.CM := CM_Reg3 (Buffer.Color_Mode);
      DMA2D_Periph.OCOLR     := To_OCOLR (Color_To_Word (Buffer.Color_Mode, Color));
      
      DMA2D_Periph.OMAR      := To_Word (Buffer.Addr) + Off;
      DMA2D_Periph.OOR.LO    := STM32F746.UInt14 (Buffer.Width - Width);
      DMA2D_Periph.NLR       :=
        (NL => STM32F746.UInt16 (Height), PL => STM32F746.UInt14 (Width), others => <>);
      Launch (Synchronous);
   end Fill_Rect;

   procedure Copy_Rect
     (Src_Buffer : Bitmap_Buffer; X_Src, Y_Src : Natural;
      Dst_Buffer : Bitmap_Buffer; X_Dst, Y_Dst : Natural;
      Width, Height : Natural; Synchronous : Boolean := False)
   is
      Src_Off : constant STM32F746.UInt32 := Pixel_Offset (Src_Buffer, X_Src, Y_Src);
      Dst_Off : constant STM32F746.UInt32 := Pixel_Offset (Dst_Buffer, X_Dst, Y_Dst);
   begin
      --  Cache maintenance for DMA coherency
      Cortex_M.Cache.Clean_Invalidate_DCache
        (Dst_Buffer.Addr, Buffer_Size (Dst_Buffer));
      Sync.Wait;

      DMA2D_Periph.CR.MODE := (if Src_Buffer.Color_Mode = Dst_Buffer.Color_Mode
                                then 2#00# else 2#01#);

      DMA2D_Periph.FGPFCCR.CM    := CM_Reg (Src_Buffer.Color_Mode);
      DMA2D_Periph.FGPFCCR.AM    := 0;
      DMA2D_Periph.FGPFCCR.ALPHA := 255;
      DMA2D_Periph.FGMAR         := To_Word (Src_Buffer.Addr) + Src_Off;
      DMA2D_Periph.FGOR.LO       := STM32F746.UInt14 (Src_Buffer.Width - Width);

      DMA2D_Periph.OPFCCR.CM := CM_Reg3 (Dst_Buffer.Color_Mode);
      DMA2D_Periph.OMAR      := To_Word (Dst_Buffer.Addr) + Dst_Off;
      DMA2D_Periph.OOR.LO    := STM32F746.UInt14 (Dst_Buffer.Width - Width);
      DMA2D_Periph.NLR       :=
        (NL => STM32F746.UInt16 (Height), PL => STM32F746.UInt14 (Width), others => <>);
      Launch (Synchronous);
   end Copy_Rect;

   procedure Copy_Rect_Blend
     (Src_Buffer : Bitmap_Buffer; X_Src, Y_Src : Natural;
      Dst_Buffer : Bitmap_Buffer; X_Dst, Y_Dst : Natural;
      Width, Height : Natural; Synchronous : Boolean := False)
   is
      Src_Off : constant STM32F746.UInt32 := Pixel_Offset (Src_Buffer, X_Src, Y_Src);
      Dst_Off : constant STM32F746.UInt32 := Pixel_Offset (Dst_Buffer, X_Dst, Y_Dst);
   begin
      --  Cache maintenance for DMA coherency
      Cortex_M.Cache.Clean_Invalidate_DCache
        (Dst_Buffer.Addr, Buffer_Size (Dst_Buffer));
      Sync.Wait;

      DMA2D_Periph.CR.MODE := 2#10#;

      DMA2D_Periph.FGPFCCR.CM    := CM_Reg (Src_Buffer.Color_Mode);
      DMA2D_Periph.FGPFCCR.AM    := 0;
      DMA2D_Periph.FGPFCCR.ALPHA := 255;
      DMA2D_Periph.FGMAR         := To_Word (Src_Buffer.Addr) + Src_Off;
      DMA2D_Periph.FGOR.LO       := STM32F746.UInt14 (Src_Buffer.Width - Width);

      DMA2D_Periph.BGPFCCR.CM    := CM_Reg (Dst_Buffer.Color_Mode);
      DMA2D_Periph.BGPFCCR.AM    := 0;
      DMA2D_Periph.BGPFCCR.ALPHA := 255;
      DMA2D_Periph.BGMAR         := To_Word (Dst_Buffer.Addr) + Dst_Off;
      DMA2D_Periph.BGOR.LO       := STM32F746.UInt14 (Dst_Buffer.Width - Width);

      DMA2D_Periph.OPFCCR.CM := CM_Reg3 (Dst_Buffer.Color_Mode);
      DMA2D_Periph.OMAR      := To_Word (Dst_Buffer.Addr) + Dst_Off;
      DMA2D_Periph.OOR.LO    := STM32F746.UInt14 (Dst_Buffer.Width - Width);
      DMA2D_Periph.NLR       :=
        (NL => STM32F746.UInt16 (Height), PL => STM32F746.UInt14 (Width), others => <>);
      Launch (Synchronous);
   end Copy_Rect_Blend;

   procedure Wait_Transfer is begin Sync.Wait; end Wait_Transfer;

end STM32F746_DMA2D;

with MT;       use MT;
with System;
with DC_Types; use DC_Types;

package STM32F746_LTDC is

   --  RK043FN48H panel on STM32F746G-DISCO
   LCD_Width  : constant := 480;
   LCD_Height : constant := 272;

   --  Called by DC_Interface via Driver_Initialize formal.
   --  Configures PLLSAI pixel clock, RCC, LTDC timing registers.
   --  Does NOT configure GPIO — board crate owns GPIO.
   --  Idempotent: guarded by LTDC_Initialized in body.
   procedure Driver_Initialize;

   --  Returns True if Driver_Initialize has already run.
   --  Reads LTDC_Initialized from the body.
   --  Wired to DC_Control's Driver_Is_Initialized formal at instantiation.
   function Driver_Is_Initialized return Boolean;

   procedure Driver_Start;
   procedure Driver_Stop;

   procedure Driver_Set_Background (R, G, B : UInt8);

   procedure Driver_Reload (Mode : Reload_Mode);
   procedure Driver_Reload_Async;
   procedure Driver_Wait_For_Reload;

   procedure Driver_Layer_Init
     (Layer          : LCD_Layer;
      Format         : Pixel_Format;
      Buffer         : System.Address;
      X, Y           : Natural;
      W, H           : Positive;
      Constant_Alpha : UInt8;
      BF             : Blending_Factor);

   procedure Driver_Set_Frame_Buffer
     (Layer : LCD_Layer;
      Addr  : System.Address);

   function Driver_Get_Frame_Buffer
     (Layer : LCD_Layer)
      return System.Address;

   procedure Driver_Set_Layer_State
     (Layer   : LCD_Layer;
      Enabled : Boolean);

end STM32F746_LTDC;

package body STM32F746_I2C is

   use stm32f746;

   Timeout_Loops : constant Natural := 1_000_000;

   --  ----------------------------------------------------------------------
   --  TIMINGR selection
   --
   --  On the F746 the I2C kernel clock is the APB1 bus clock (the reset
   --  default of RCC_DCKCFGR2; our Clock_Tree assumes that default). So the
   --  correct TIMINGR depends on PCLK1, which Get_Clock returns. We do NOT
   --  force HSI here and we do NOT hardcode a single 16 MHz timing.
   --
   --  Values below are CubeMX-derived for the stated kernel frequency. Each
   --  row is valid ONLY at that frequency; an uncovered (clock, speed) pair
   --  raises rather than running wrong timing silently.
   --  ----------------------------------------------------------------------

   type Timing is record
      PRESC  : UInt4;
      SCLDEL : UInt4;
      SDADEL : UInt4;
      SCLH   : Byte;
      SCLL   : Byte;
   end record;

   function Timing_For (Kernel_Hz : Natural;
                        Speed     : I2C_Types.Bus_Speed_Kind) return Timing is
   begin
      --  54 MHz kernel (SYSCLK 216 MHz, APB1 = /4)
      if Kernel_Hz = 54_000_000 then
         case Speed is
            when I2C_Types.Standard_Mode =>      --  100 kHz
               return (PRESC => 11, SCLDEL => 4, SDADEL => 0,
                       SCLH => 16#13#, SCLL => 16#1B#);
            when I2C_Types.Fast_Mode =>          --  400 kHz
               return (PRESC => 5, SCLDEL => 3, SDADEL => 0,
                       SCLH => 16#09#, SCLL => 16#13#);
            when I2C_Types.Fast_Mode_Plus =>     --  1 MHz
               return (PRESC => 5, SCLDEL => 1, SDADEL => 0,
                       SCLH => 16#02#, SCLL => 16#04#);
         end case;

      --  TODO: fill in once confirmed. 45 MHz (SYSCLK 180 MHz) etc.
      --  elsif Kernel_Hz = 45_000_000 then
      --     case Speed is ... end case;

      else
         raise I2C_Types.Bus_Fault
           with "Timing_For: no TIMINGR row for this kernel clock";
      end if;
   end Timing_For;

   --  ----------------------------------------------------------------------
   --  Helpers
   --  ----------------------------------------------------------------------

   procedure Clear_Status_Flags (Dev : in out Device) is
   begin
      Dev.P.ICR.NACKCF := 1;
      Dev.P.ICR.STOPCF := 1;
      Dev.P.ICR.BERRCF := 1;
      Dev.P.ICR.ARLOCF := 1;
      Dev.P.ICR.OVRCF  := 1;
   end Clear_Status_Flags;

   procedure Recover_Controller (Dev : in out Device) is
   begin
      Dev.P.CR1.PE := 0;
      Dev.P.CR1.PE := 1;
      Clear_Status_Flags (Dev);
   end Recover_Controller;

   procedure Check_Errors (Dev : Device; Op : String) is
   begin
      if Dev.P.ISR.NACKF = 1 then
         raise I2C_Types.Bus_Fault with Op & ": NACK";
      elsif Dev.P.ISR.BERR = 1 then
         raise I2C_Types.Bus_Fault with Op & ": bus error";
      elsif Dev.P.ISR.ARLO = 1 then
         raise I2C_Types.Bus_Fault with Op & ": arbitration lost";
      elsif Dev.P.ISR.OVR = 1 then
         raise I2C_Types.Bus_Fault with Op & ": overrun";
      end if;
   end Check_Errors;

   --  ----------------------------------------------------------------------
   --  Make_Device, Init, Enable
   --  ----------------------------------------------------------------------

   function Make_Device return Device is
   begin
      return Dev : Device;
   end Make_Device;

   procedure Init (Dev : in out Device;
                   Cfg : I2C_Types.I2C_Config) is
      T : constant Timing := Timing_For (Get_Clock, Cfg.Speed);
   begin
      RCC_Enable;
      RCC_Reset;

      --  Peripheral must be disabled to program TIMINGR.
      Dev.P.CR1.PE := 0;

      Dev.P.TIMINGR.PRESC  := T.PRESC;
      Dev.P.TIMINGR.SCLDEL := T.SCLDEL;
      Dev.P.TIMINGR.SDADEL := T.SDADEL;
      Dev.P.TIMINGR.SCLH   := T.SCLH;
      Dev.P.TIMINGR.SCLL   := T.SCLL;

      Dev.P.CR1.ANFOFF := 0;
      Dev.P.CR1.DNF    := 0;

      Clear_Status_Flags (Dev);

      Dev.P.CR1.PE := 1;
   end Init;

   procedure Enable (Dev : in out Device) is
   begin
      Dev.P.CR1.PE := 1;
   end Enable;

   procedure Disable (Dev : in out Device) is
   begin
      Dev.P.CR1.PE := 0;
   end Disable;

   procedure Reset (Dev : in out Device) is
      pragma Unreferenced (Dev);
   begin
      RCC_Reset;
   end Reset;

   procedure Recover (Dev : in out Device) is
   begin
      Disable (Dev);
      Reset   (Dev);
      Enable  (Dev);
   end Recover;

   procedure Probe (Dev    : in out Device;
                    Target : I2C_Types.I2C_Address;
                    Result : out I2C_Types.Ack_State) is
      Loops : Natural := Timeout_Loops;
   begin
      Result := I2C_Types.Nak;

      if Dev.P.CR1.PE = 0 then
         Recover_Controller (Dev);
      end if;

      if Dev.P.CR1.PE = 0 then
         return;
      end if;

      if Dev.P.ISR.BUSY = 1 then
         Recover_Controller (Dev);
      end if;

      if Dev.P.ISR.BUSY = 1 then
         return;
      end if;

      Clear_Status_Flags (Dev);

      --  Issue a 0-byte write to probe the address
      Dev.P.CR2 := (SADD    => UInt10 (Natural (Target) * 2),
                    RD_WRN  => 0,
                    NBYTES  => 0,
                    RELOAD  => 0,
                    AUTOEND => 1,
                    START   => 1,
                    others  => <>);

      --  Wait for STOPF or NACKF
      while Loops > 0 loop
         exit when Dev.P.ISR.STOPF = 1 or else Dev.P.ISR.NACKF = 1;
         Loops := Loops - 1;
      end loop;

      if Dev.P.ISR.NACKF = 0 and then Dev.P.ISR.STOPF = 1 then
         Result := I2C_Types.Ack;
      end if;

      Clear_Status_Flags (Dev);
   end Probe;

   --  ----------------------------------------------------------------------
   --  Transaction begin
   --  ----------------------------------------------------------------------

   procedure Begin_Write (Dev    : in out Device;
                          Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean) is
      NBytes : Byte;
   begin
      if Length = 0 or else Length > 255 then
         raise I2C_Types.Bus_Fault with "Begin_Write: invalid length";
      end if;

      NBytes := Byte (Length);

      if Dev.P.CR1.PE = 0 then
         Recover_Controller (Dev);
      end if;

      if Dev.P.CR1.PE = 0 then
         raise I2C_Types.Bus_Fault with "Begin_Write: peripheral not enabled";
      end if;

      if Dev.P.ISR.BUSY = 1 then
         Recover_Controller (Dev);
      end if;

      if Dev.P.ISR.BUSY = 1 then
         raise I2C_Types.Bus_Fault with "Begin_Write: bus busy";
      end if;

      Clear_Status_Flags (Dev);

      Dev.P.CR2 := (SADD    => UInt10 (Natural (Target) * 2),
                    RD_WRN  => 0,
                    NBYTES  => NBytes,
                    RELOAD  => 0,
                    AUTOEND => (if Stop then 1 else 0),
                    START   => 1,
                    others  => <>);
   end Begin_Write;

   procedure Begin_Read (Dev    : in out Device;
                         Target : I2C_Types.I2C_Address;
                         Length : Natural;
                         Stop   : Boolean) is
      NBytes : Byte;
   begin
      if Length = 0 or else Length > 255 then
         raise I2C_Types.Bus_Fault with "Begin_Read: invalid length";
      end if;

      NBytes := Byte (Length);

      if Dev.P.CR1.PE = 0 then
         Recover_Controller (Dev);
      end if;

      if Dev.P.CR1.PE = 0 then
         raise I2C_Types.Bus_Fault with "Begin_Read: peripheral not enabled";
      end if;

      --  A repeated-START after a Write phase legitimately leaves BUSY=1;
      --  don't recover here. Trust the caller's transaction sequencing.

      Clear_Status_Flags (Dev);

      Dev.P.CR2 := (SADD    => UInt10 (Natural (Target) * 2),
                    RD_WRN  => 1,
                    NBYTES  => NBytes,
                    RELOAD  => 0,
                    AUTOEND => (if Stop then 1 else 0),
                    START   => 1,
                    others  => <>);
   end Begin_Read;

   --  ----------------------------------------------------------------------
   --  Per-byte send/recv (polling)
   --  ----------------------------------------------------------------------

   procedure Send (Dev : in out Device;
                   B   : Storage_Element) is
      Loops : Natural := Timeout_Loops;
   begin
      while Dev.P.ISR.TXIS = 0 and then Loops > 0 loop
         exit when Dev.P.ISR.NACKF = 1
                or else Dev.P.ISR.BERR = 1
                or else Dev.P.ISR.ARLO = 1
                or else Dev.P.ISR.OVR = 1;
         Loops := Loops - 1;
      end loop;

      Check_Errors (Dev, "Send");

      if Dev.P.ISR.TXIS = 0 then
         raise I2C_Types.Bus_Fault with "Send: timeout waiting for TXIS";
      end if;

      Dev.P.TXDR.TXDATA := Byte (B);
   end Send;

   procedure Recv (Dev : in out Device;
                   B   : out Storage_Element;
                   Ack : Boolean) is
      Loops : Natural := Timeout_Loops;
      pragma Unreferenced (Ack);
      --  ACK/NACK is driven by the AUTOEND/NBYTES setup in Begin_Read;
      --  no byte-by-byte ACK control needed in v2 I2C.
   begin
      B := 0;

      while Dev.P.ISR.RXNE = 0 and then Loops > 0 loop
         exit when Dev.P.ISR.NACKF = 1
                or else Dev.P.ISR.BERR = 1
                or else Dev.P.ISR.ARLO = 1
                or else Dev.P.ISR.OVR = 1;
         Loops := Loops - 1;
      end loop;

      Check_Errors (Dev, "Recv");

      if Dev.P.ISR.RXNE = 0 then
         raise I2C_Types.Bus_Fault with "Recv: timeout waiting for RXNE";
      end if;

      B := Storage_Element (Dev.P.RXDR.RXDATA);
   end Recv;

end STM32F746_I2C;
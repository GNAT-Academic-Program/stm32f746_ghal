with stm32f746;
with stm32f746.I2C;

--  ===========================================================================
--  STM32F746_I2C_Port body  --  SPARK_Mode => Off
--
--  The ONLY unit that names stm32f746.I2C. The I2C_Peripheral type appears in
--  exactly one declaration: the Regs overlay at Base. Every register poke is
--  lifted verbatim from the original STM32F746_I2C body; the only structural
--  change is that the busy-wait loops are GONE -- they moved up into the
--  SPARK_Mode => On logic leaf as bounded FOR loops. This body has no loops.
--  ===========================================================================

package body STM32F746_I2C_Port with SPARK_Mode => Off is

   use stm32f746;
   use stm32f746.I2C;

   --  The one overlay. This is the same idiom the SVD binding uses to place
   --  the peripheral objects; here we re-place it at the address passed in.
   Regs : I2C_Peripheral with Import, Volatile, Address => Base;

   ---------------------------------------------------------------------------
   --  Status reads  (Status_State)
   ---------------------------------------------------------------------------

   function PE_On   return Boolean is (Regs.CR1.PE  = 1);
   function Busy    return Boolean is (Regs.ISR.BUSY  = 1);
   function TXIS    return Boolean is (Regs.ISR.TXIS  = 1);
   function RXNE    return Boolean is (Regs.ISR.RXNE  = 1);
   function Stopped return Boolean is (Regs.ISR.STOPF = 1);
   function Nacked  return Boolean is (Regs.ISR.NACKF = 1);
   function Berr    return Boolean is (Regs.ISR.BERR  = 1);
   function Arlo    return Boolean is (Regs.ISR.ARLO  = 1);
   function Ovr     return Boolean is (Regs.ISR.OVR   = 1);

   ---------------------------------------------------------------------------
   --  Control writes  (Control_State)
   ---------------------------------------------------------------------------

   procedure Set_PE (On : Boolean) is
   begin
      Regs.CR1.PE := (if On then 1 else 0);
   end Set_PE;

   procedure Program_Timing (PRESC, SCLDEL, SDADEL : MT.UInt4;
                             SCLH, SCLL            : MT.UInt8) is
   begin
      --  Caller guarantees PE = 0 here. Clean MT scalars -> SVD field types.
      Regs.TIMINGR.PRESC  := stm32f746.UInt4 (PRESC);
      Regs.TIMINGR.SCLDEL := stm32f746.UInt4 (SCLDEL);
      Regs.TIMINGR.SDADEL := stm32f746.UInt4 (SDADEL);
      Regs.TIMINGR.SCLH   := stm32f746.Byte  (SCLH);
      Regs.TIMINGR.SCLL   := stm32f746.Byte  (SCLL);
      Regs.CR1.ANFOFF := 0;
      Regs.CR1.DNF    := 0;
   end Program_Timing;

   procedure Clear_Status is
   begin
      Regs.ICR.NACKCF := 1;
      Regs.ICR.STOPCF := 1;
      Regs.ICR.BERRCF := 1;
      Regs.ICR.ARLOCF := 1;
      Regs.ICR.OVRCF  := 1;
   end Clear_Status;

   procedure Recover_Ctrl is
   begin
      Regs.CR1.PE := 0;
      Regs.CR1.PE := 1;
      Clear_Status;
   end Recover_Ctrl;

   procedure Start (Sadd     : MT.UInt10;
                    Read     : Boolean;
                    NBytes   : MT.UInt8;
                    Auto_End : Boolean) is
   begin
      Regs.CR2 :=
        (SADD    => stm32f746.UInt10 (Sadd),
         RD_WRN  => (if Read then 1 else 0),
         NBYTES  => stm32f746.Byte (NBytes),
         RELOAD  => 0,
         AUTOEND => (if Auto_End then 1 else 0),
         START   => 1,
         others  => <>);
   end Start;

   procedure Put (B : Storage_Element) is
   begin
      Regs.TXDR.TXDATA := stm32f746.Byte (B);
   end Put;

   ---------------------------------------------------------------------------
   --  Rx read  (Rx_State) -- reading RXDR pops the FIFO / clears RXNE
   ---------------------------------------------------------------------------

   procedure Get (B : out Storage_Element) is
   begin
      B := Storage_Element (Regs.RXDR.RXDATA);
   end Get;

end STM32F746_I2C_Port;
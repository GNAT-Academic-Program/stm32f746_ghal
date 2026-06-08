with I2C_Types;
with MT;
with System;
with System.Storage_Elements; use System.Storage_Elements;

--  ===========================================================================
--  STM32F746_I2C_Port  --  the wall  (spec On / body Off)
--
--  The leak in the old STM32F746_I2C was the generic formal
--     Periph : not null access stm32f746.I2C.I2C_Peripheral
--  which names an SVD type AND holds an access-into-MMIO in a SPARK_Mode => On
--  contract -- so gnatprove elaborated the SVD closure and rejected the
--  pointer. Here the formal is a System.Address (SPARK-clean, pulls no SVD);
--  the I2C_Peripheral type appears ONLY in the Off body's overlay.
--
--  The body is SPARK_Mode => Off, so gnatprove black-boxes it: it trusts these
--  contracts and never follows the body's `with stm32f746.I2C`. No
--  Refined_State is needed for the abstract states for the same reason.
--
--  State split (per generic instance = per bus):
--    Control_State  (Async_Readers, Effective_Writes)  CR1/CR2/TIMINGR/ICR
--    Status_State   (Async_Writers)                     ISR  -> Volatile_Function
--    Rx_State       (Async_Writers, Effective_Reads)    RXDR -> Get is a procedure
--  ===========================================================================

generic
   Base : System.Address;   --  base address of this bus's I2C_Peripheral
package STM32F746_I2C_Port with
   SPARK_Mode     => On,
   Abstract_State =>
     ((Control_State with External => (Async_Readers, Effective_Writes)),
      (Status_State  with External => Async_Writers),
      (Rx_State      with External => (Async_Writers, Effective_Reads)))
is

   --  Status reads -- Async_Writers, no Effective_Reads => Volatile_Function
   function PE_On   return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Busy    return Boolean with Volatile_Function, Global => (Input => Status_State);
   function TXIS    return Boolean with Volatile_Function, Global => (Input => Status_State);
   function RXNE    return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Stopped return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Nacked  return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Berr    return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Arlo    return Boolean with Volatile_Function, Global => (Input => Status_State);
   function Ovr     return Boolean with Volatile_Function, Global => (Input => Status_State);

   --  Control writes -- Async_Readers/Effective_Writes => procedures
   procedure Set_PE (On : Boolean) with Global => (Output => Control_State);

   procedure Program_Timing (PRESC, SCLDEL, SDADEL : MT.UInt4;
                             SCLH, SCLL            : MT.UInt8)
                             with Global => (Output => Control_State);

   procedure Clear_Status with Global => (Output => Control_State);
   procedure Recover_Ctrl with Global => (Output => Control_State);

   procedure Start (Sadd     : MT.UInt10;
                    Read     : Boolean;
                    NBytes   : MT.UInt8;
                    Auto_End : Boolean) with Global => (Output => Control_State);

   procedure Put (B : Storage_Element) with Global => (Output => Control_State);

   --  Rx read -- Effective_Reads => MUST be a procedure (In_Out)
   procedure Get (B : out Storage_Element) with Global => (In_Out => Rx_State);

end STM32F746_I2C_Port;
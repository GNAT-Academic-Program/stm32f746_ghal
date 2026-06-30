with I2C_Types;
with System;
with System.Storage_Elements; use System.Storage_Elements;

--  ===========================================================================
--  STM32F746_I2C  --  Bus-level I2C driver (SPARK_Mode => On body)
--
--  This is a bus-level driver following GHAL architecture principles:
--    * One instantiation per physical I2C peripheral (I2C1, I2C2, etc.)
--    * No Device type - the instantiation IS the bus
--    * All procedures operate directly on the peripheral via the Port instance
--    * Peripheral identity lives in the per-instance Port bound to Base address
--
--  The body is SPARK_Mode => On with proven VCs (length->UInt8 and
--  address->UInt10 conversions, loop termination, AoRTE), with a No_Return
--  Fault helper (body Off) that turns each Bus_Fault into a halt under
--  No_Exception_Propagation.
--  ===========================================================================

generic
   Base           : System.Address;
   with function  Get_Clock return Natural;
   with procedure RCC_Enable;
   with procedure RCC_Reset;
package STM32F746_I2C with SPARK_Mode => On is

   --  Control-plane hooks
   procedure Init    (Cfg : I2C_Types.I2C_Config);
   procedure Enable;
   procedure Disable;
   procedure Reset;
   procedure Recover;
   procedure Probe   (Target : I2C_Types.I2C_Address;
                      Result : out I2C_Types.Ack_State);

   --  Data-plane hooks
   procedure Begin_Write (Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean);
   procedure Begin_Read  (Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean);
   procedure Send        (B : Storage_Element);
   procedure Recv        (B   : out Storage_Element;
                          Ack : Boolean);

end STM32F746_I2C;
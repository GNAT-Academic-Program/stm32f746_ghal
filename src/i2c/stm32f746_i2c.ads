with I2C_Types;
with System;
with System.Storage_Elements; use System.Storage_Elements;

--  ===========================================================================
--  STM32F746_I2C  --  the logic leaf  (now SPARK_Mode => On body)
--
--  Same external surface as before, so I2C_Interface / I2C_Control / I2C_Data
--  and their Instances/Board wiring are UNCHANGED. Two differences only:
--    * the generic formal Periph (access I2C_Peripheral) becomes Base
--      (System.Address) -- the leak fix; one line changes in Instances.
--    * Device no longer carries an access -- the peripheral identity lives in
--      the per-instance Port. Device is now a handle with no data.
--
--  The body is SPARK_Mode => On: this is where the leaf's own VCs get proven
--  (length->UInt8 and address->UInt10 conversions, loop termination, AoRTE),
--  with a No_Return Fault helper (body Off) that turns each Bus_Fault into a
--  halt -- the honest model under No_Exception_Propagation.
--  ===========================================================================

generic
   Base           : System.Address;
   with function  Get_Clock return Natural;
   with procedure RCC_Enable;
   with procedure RCC_Reset;
package STM32F746_I2C with SPARK_Mode => On is

   type Device is limited private;

   function Make_Device return Device;

   --  Control-plane hooks
   procedure Init    (Dev : in out Device; Cfg : I2C_Types.I2C_Config);
   procedure Enable  (Dev : in out Device);
   procedure Disable (Dev : in out Device);
   procedure Reset   (Dev : in out Device);
   procedure Recover (Dev : in out Device);
   procedure Probe   (Dev    : in out Device;
                      Target : I2C_Types.I2C_Address;
                      Result : out I2C_Types.Ack_State);

   --  Data-plane hooks
   procedure Begin_Write (Dev    : in out Device;
                          Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean);
   procedure Begin_Read  (Dev    : in out Device;
                          Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean);
   procedure Send        (Dev : in out Device;
                          B   : Storage_Element);
   procedure Recv        (Dev : in out Device;
                          B   : out Storage_Element;
                          Ack : Boolean);

private

   --  Peripheral identity is in the Port instance; the handle carries nothing.
   type Device is limited null record;

end STM32F746_I2C;
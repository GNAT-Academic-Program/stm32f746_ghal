with Usart_Types;
with STM32F746;
with STM32F746.USART;
with System.Storage_Elements; use System.Storage_Elements;

generic
   Periph         : not null access STM32F746.USART.USART_Peripheral;
   with function  Get_Clock   return Natural;
   with procedure RCC_Enable;
   with procedure RCC_Reset;
package STM32F746_USART is

   type Device is private;

   function Make_Device return Device;

   --  Control-plane hooks

   procedure Init       (Dev : in out Device;
                         Cfg : Usart_Types.Usart_Config);
   procedure Enable     (Dev : in out Device);
   function  Is_Enabled (Dev : Device) return Boolean;
   procedure Disable    (Dev : in out Device);
   procedure Reset      (Dev : in out Device);

   --  Data-plane hooks

   procedure Tx_Push (Dev      : in out Device;
                      B        : Storage_Element;
                      Accepted : out Boolean);
   procedure Rx_Pop  (Dev       : in out Device;
                      B         : out Storage_Element;
                      Available : out Boolean);

private

   type Device is record
      Periph : access STM32F746.USART.USART_Peripheral
                 := STM32F746_USART.Periph;
   end record;

end STM32F746_USART;
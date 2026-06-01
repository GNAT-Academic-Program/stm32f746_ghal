with Gpio_Interface;

with STM32F746_Gpio;

package Gpio is new Gpio_Interface
  (Pin_T            => STM32F746_Gpio.Pin,
   Driver_Configure => STM32F746_Gpio.Driver_Configure,
   Driver_Set       => STM32F746_Gpio.Driver_Set,
   Driver_Clr       => STM32F746_Gpio.Driver_Clr,
   Driver_Toggle    => STM32F746_Gpio.Driver_Toggle,
   Driver_Read      => STM32F746_Gpio.Driver_Read);
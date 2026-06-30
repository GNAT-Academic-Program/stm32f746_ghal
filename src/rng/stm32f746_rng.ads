with RNG_Types; use RNG_Types;

package STM32F746_RNG is

   procedure RCC_Enable;
   procedure RCC_Reset;
   procedure Enable;
   procedure Disable;
   function  Driver_Data_Ready return Boolean;
   function  Driver_Read return Random_Value;

end STM32F746_RNG;
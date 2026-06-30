with STM32F746; use STM32F746;
with STM32F746.RCC; use STM32F746.RCC;
with STM32F746.RNG; use STM32F746.RNG;

package body STM32F746_RNG is

   procedure RCC_Enable is
   begin
      RCC_Periph.AHB2ENR.RNGEN := 1;
   end RCC_Enable;

   procedure RCC_Reset is
   begin
      RCC_Periph.AHB2RSTR.RNGRST := 1;
      RCC_Periph.AHB2RSTR.RNGRST := 0;
   end RCC_Reset;

   procedure Enable is
   begin
      RNG_Periph.CR.RNGEN := 1;
   end Enable;

   procedure Disable is
   begin
      RNG_Periph.CR.RNGEN := 0;
   end Disable;

   function Driver_Data_Ready return Boolean is
   begin
      return RNG_Periph.SR.DRDY = 1;
   end Driver_Data_Ready;

   function Driver_Read return Random_Value is
   begin
      return Random_Value (RNG_Periph.DR);
   end Driver_Read;

end STM32F746_RNG;
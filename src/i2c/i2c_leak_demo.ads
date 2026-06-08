with STM32F746_I2C;
with STM32F746.I2C;
with Clock_Tree;

package I2C_Leak_Demo with SPARK_Mode => On is
   package Inst is new STM32F746_I2C
     (Periph     => STM32F746.I2C.I2C1_Periph'Access,
      Get_Clock  => Clock_Tree.Get_I2C1_Clock,
      RCC_Enable => Clock_Tree.Enable_I2C1,
      RCC_Reset  => Clock_Tree.Reset_I2C1);
end I2C_Leak_Demo;
with STM32F746_I2C;
with System; use System;

package I2C_Proof_Instance with SPARK_Mode => On is

   function  No_Clock return Natural is (54_000_000);
   procedure No_Op is null;

   package Inst is new STM32F746_I2C
     (Base       => System.Null_Address,
      Get_Clock  => No_Clock,
      RCC_Enable => No_Op,
      RCC_Reset  => No_Op);

end I2C_Proof_Instance;
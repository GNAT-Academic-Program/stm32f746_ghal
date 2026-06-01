with stm32f746;
with stm32f746.RCC;

package body STM32F746_GPIO is

   use stm32f746;
   use stm32f746.GPIO;
   use type Gpio_Types.Pin_Mode;
   use type Gpio_Types.Logic_Level;
   use type Gpio_Types.Drive_Type;

   function Make_Pin
     (Port : Port_Letter;
      Nbr  : Pin_Number) return Pin
   is
   begin
      case Port is
         when A => return (Periph => GPIOA_Periph'Access, Port => Port, Nbr => Nbr);
         when B => return (Periph => GPIOB_Periph'Access, Port => Port, Nbr => Nbr);
         when C => return (Periph => GPIOC_Periph'Access, Port => Port, Nbr => Nbr);
         when D => return (Periph => GPIOD_Periph'Access, Port => Port, Nbr => Nbr);
         when E => return (Periph => GPIOE_Periph'Access, Port => Port, Nbr => Nbr);
         when F => return (Periph => GPIOF_Periph'Access, Port => Port, Nbr => Nbr);
         when G => return (Periph => GPIOG_Periph'Access, Port => Port, Nbr => Nbr);
         when H => return (Periph => GPIOH_Periph'Access, Port => Port, Nbr => Nbr);
         when I => return (Periph => GPIOI_Periph'Access, Port => Port, Nbr => Nbr);
         when J => return (Periph => GPIOJ_Periph'Access, Port => Port, Nbr => Nbr);
         when K => return (Periph => GPIOK_Periph'Access, Port => Port, Nbr => Nbr);
      end case;
   end Make_Pin;

   procedure Enable_Clock (Port : Port_Letter) is
   begin
      case Port is
         when A =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOAEN := 1;
         when B =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOBEN := 1;
         when C =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOCEN := 1;
         when D =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIODEN := 1;
         when E =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOEEN := 1;
         when F =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOFEN := 1;
         when G =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOGEN := 1;
         when H =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOHEN := 1;
         when I =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOIEN := 1;
         when J =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOJEN := 1;
         when K =>
            stm32f746.RCC.RCC_Periph.AHB1ENR.GPIOKEN := 1;
      end case;
   end Enable_Clock;


   -----------------------------
   -- Configure               --
   -----------------------------

   function Mode_Bits (M : Gpio_Types.Pin_Mode) return UInt2 is
   begin
      case M is
         when Gpio_Types.Input     => return 2#00#;
         when Gpio_Types.Output    => return 2#01#;
         when Gpio_Types.Alternate => return 2#10#;
         when Gpio_Types.Analog    => return 2#11#;
      end case;
   end Mode_Bits;

   function Speed_Bits (S : Gpio_Types.Speed_Level) return UInt2 is
   begin
      case S is
         when Gpio_Types.Low_Speed       => return 2#00#;
         when Gpio_Types.Medium_Speed    => return 2#01#;
         when Gpio_Types.High_Speed      => return 2#10#;
         when Gpio_Types.Very_High_Speed => return 2#11#;
      end case;
   end Speed_Bits;

   procedure Write_PUPDR (Dev : Pin; Value : UInt2) is
   begin
      Dev.Periph.PUPDR.Arr (Dev.Nbr) := Value;
   end;

   procedure Set_Pin_Level (Dev : Pin; Value : Gpio_Types.Logic_Level) is
   begin
      if Value = Gpio_Types.High then
         Dev.Periph.BSRR.BS.Arr (Dev.Nbr) := 1;
      else
         Dev.Periph.BSRR.BR.Arr (Dev.Nbr) := 1;
      end if;
   end;

   procedure Write_OSPEEDR (Dev : Pin; Value : UInt2) is
   begin
      Dev.Periph.OSPEEDR.Arr (Dev.Nbr) := Value;
   end;

   procedure Write_OTYPER (Dev : Pin; Value : Bit) is
   begin
      Dev.Periph.OTYPER.OT.Arr (Dev.Nbr) := Value;
   end;

   procedure Write_AFR (Dev   : Pin;
                        AF    : Gpio_Types.Alternate_Function) is
   begin
      if Dev.Nbr <= 7 then
         Dev.Periph.AFRL.Arr (Dev.Nbr) := stm32f746.UInt4 (AF);
      else
         Dev.Periph.AFRH.Arr (Dev.Nbr) := stm32f746.UInt4 (AF);
      end if;
   end;

   procedure Write_MODER (Dev : Pin; Value : UInt2) is
   begin
      Dev.Periph.MODER.Arr (Dev.Nbr) := Value;
   end;

   procedure Driver_Configure (Dev    : Pin;
                               Cfg    : Gpio_Types.Gpio_Config) is
   begin
      Enable_Clock (Dev.Port);

      if Cfg.Mode in Gpio_Types.Output | Gpio_Types.Alternate then
         Set_Pin_Level (Dev, Cfg.Init_State);
      end if;

      if Cfg.Mode in Gpio_Types.Output | Gpio_Types.Alternate then
         Write_OTYPER (Dev, (if Cfg.Drive = Gpio_Types.Open_Drain then 1 else 0));
         Write_OSPEEDR (Dev, Speed_Bits (Cfg.Speed));
      end if;

      case Cfg.Pull is
         when Gpio_Types.None      => Write_PUPDR (Dev, 2#00#);
         when Gpio_Types.Pull_Up   => Write_PUPDR (Dev, 2#01#);
         when Gpio_Types.Pull_Down => Write_PUPDR (Dev, 2#10#);
      end case;

      if Cfg.Mode = Gpio_Types.Alternate then
         Write_AFR (Dev, Cfg.AF);
      end if;

      Write_MODER (Dev, Mode_Bits (Cfg.Mode));

   end Driver_Configure;

   -----------------------------
   -- Set                    --
   -----------------------------

   procedure Driver_Set (Dev : Pin) is
   begin
      Dev.Periph.BSRR.BS.Arr (Integer (Dev.Nbr)) := 1;
   end Driver_Set;

   -----------------------------
   -- Clear                  --
   -----------------------------

   procedure Driver_Clr (Dev : Pin) is
   begin
      Dev.Periph.BSRR.BR.Arr (Integer (Dev.Nbr)) := 1;
   end Driver_Clr;

   -----------------------------
   -- Toggle                 --
   -----------------------------

   procedure Driver_Toggle (Dev : Pin) is
      N : constant Natural := Dev.Nbr;
   begin
      if Dev.Periph.ODR.ODR.Arr (N) = 0 then
         Dev.Periph.BSRR.BS.Arr (N) := 1;
      else
         Dev.Periph.BSRR.BR.Arr (N) := 1;
      end if;
   end Driver_Toggle;

   -----------------------------
   -- Read                   --
   -----------------------------

   function Driver_Read (Dev : Pin) return MT.Bit is
   begin
      return MT.Bit (Dev.Periph.IDR.IDR.Arr (Integer (Dev.Nbr)));
   end Driver_Read;

end STM32F746_GPIO;
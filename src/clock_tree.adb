with Stm32f746_Config;
with stm32f746.RCC;

package body Clock_Tree is

   use stm32f746;

   --  ----------------------------------------------------------------------
   --  Fixed MCU constants
   --  ----------------------------------------------------------------------

   HSI_Freq : constant Natural := 16_000_000;
   LSE_Freq : constant Natural := 32_768;
   pragma Unreferenced (LSE_Freq);
   --  LSE kept for symmetry with the G4; no peripheral here selects it
   --  under the assumed reset-default kernel clocking.

   --  ----------------------------------------------------------------------
   --  SYSCLK computation from Alire config
   --
   --  F746 main PLL (RM0385): SYSCLK is fed from the PLL *P* output.
   --     VCO_in  = PLL_source / PLL_M
   --     VCO_out = VCO_in     * PLL_N
   --     PLLCLK  = VCO_out    / PLL_P
   --  ----------------------------------------------------------------------

   function PLL_P_Divisor return Natural is
   begin
      case Stm32f746_Config.PLL_P_Div is
         when Stm32f746_Config.DIV2 => return 2;
         when Stm32f746_Config.DIV4 => return 4;
         when Stm32f746_Config.DIV6 => return 6;
         when Stm32f746_Config.DIV8 => return 8;
      end case;
   end PLL_P_Divisor;

   function PLL_Input_Freq return Natural is
   begin
      case Stm32f746_Config.PLL_Src is
         when Stm32f746_Config.HSI => return HSI_Freq;
         when Stm32f746_Config.HSE => return Stm32f746_Config.HSE_Hz;
      end case;
   end PLL_Input_Freq;

   function Compute_SYSCLK return Natural is
   begin
      case Stm32f746_Config.SYSCLK_Src is
         when Stm32f746_Config.HSI    => return HSI_Freq;
         when Stm32f746_Config.HSE    => return Stm32f746_Config.HSE_Hz;
         when Stm32f746_Config.PLLCLK =>
            return (PLL_Input_Freq / Stm32f746_Config.PLL_M_Div)
                  * Stm32f746_Config.PLL_N_Mul
                  / PLL_P_Divisor;
      end case;
   end Compute_SYSCLK;

   SYSCLK_Freq : constant Natural := Compute_SYSCLK;

   --  ----------------------------------------------------------------------
   --  Bus clocks (read live from RCC prescalers)
   --  ----------------------------------------------------------------------

   function Get_HCLK return Natural is
   begin
      case RCC.RCC_Periph.CFGR.HPRE is
         when 16#0# .. 16#7# => return SYSCLK_Freq;
         when 16#8#          => return SYSCLK_Freq / 2;
         when 16#9#          => return SYSCLK_Freq / 4;
         when 16#A#          => return SYSCLK_Freq / 8;
         when 16#B#          => return SYSCLK_Freq / 16;
         when 16#C#          => return SYSCLK_Freq / 64;
         when 16#D#          => return SYSCLK_Freq / 128;
         when 16#E#          => return SYSCLK_Freq / 256;
         when 16#F#          => return SYSCLK_Freq / 512;
      end case;
   end Get_HCLK;

   function Get_PCLK1 return Natural is
      HCLK  : constant Natural := Get_HCLK;
      PPRE1 : constant Natural :=
        Natural (RCC.RCC_Periph.CFGR.PPRE.Arr (1));
   begin
      case PPRE1 is
         when 16#0# .. 16#3# => return HCLK;
         when 16#4#          => return HCLK / 2;
         when 16#5#          => return HCLK / 4;
         when 16#6#          => return HCLK / 8;
         when 16#7#          => return HCLK / 16;
         when others         => raise Program_Error;
      end case;
   end Get_PCLK1;

   function Get_PCLK2 return Natural is
      HCLK  : constant Natural := Get_HCLK;
      PPRE2 : constant Natural :=
        Natural (RCC.RCC_Periph.CFGR.PPRE.Arr (2));
   begin
      case PPRE2 is
         when 16#0# .. 16#3# => return HCLK;
         when 16#4#          => return HCLK / 2;
         when 16#5#          => return HCLK / 4;
         when 16#6#          => return HCLK / 8;
         when 16#7#          => return HCLK / 16;
         when others         => raise Program_Error;
      end case;
   end Get_PCLK2;

   --  ----------------------------------------------------------------------
   --  Peripheral kernel clocks
   --
   --  Unlike the G4 (CCIPR1 per-peripheral SEL muxes), the F746 selects
   --  USART/I2C/etc. kernel clocks in RCC_DCKCFGR2. We assume the reset
   --  default for all of them, i.e. kernel clock = APB bus clock, so these
   --  reduce to the bus clock with no mux dispatch.
   --
   --  Bus mapping (RM0385):
   --    APB2: SPI1, USART1      APB1: SPI2/3, USART2/3, UART4, I2C1/2/3
   --  ----------------------------------------------------------------------

   function Get_SPI1_Clock return Natural is (Get_PCLK2);
   function Get_SPI2_Clock return Natural is (Get_PCLK1);
   function Get_SPI3_Clock return Natural is (Get_PCLK1);

   function Get_I2C1_Clock return Natural is (Get_PCLK1);
   function Get_I2C2_Clock return Natural is (Get_PCLK1);
   function Get_I2C3_Clock return Natural is (Get_PCLK1);

   function Get_USART1_Clock return Natural is (Get_PCLK2);
   function Get_USART2_Clock return Natural is (Get_PCLK1);
   function Get_USART3_Clock return Natural is (Get_PCLK1);
   function Get_UART4_Clock  return Natural is (Get_PCLK1);

   --  ----------------------------------------------------------------------
   --  RCC enable hooks
   --
   --  F746 has a single APB1ENR / APB2ENR (no ENR1/ENR2 split as on the
   --  G4), and the SVD field names are clean — no SP3EN / I2C3 apologies.
   --  ----------------------------------------------------------------------

   procedure Enable_SPI1 is
   begin
      RCC.RCC_Periph.APB2ENR.SPI1EN := 1;
   end Enable_SPI1;

   procedure Enable_SPI2 is
   begin
      RCC.RCC_Periph.APB1ENR.SPI2EN := 1;
   end Enable_SPI2;

   procedure Enable_SPI3 is
   begin
      RCC.RCC_Periph.APB1ENR.SPI3EN := 1;
   end Enable_SPI3;

   procedure Enable_USART1 is
   begin
      RCC.RCC_Periph.APB2ENR.USART1EN := 1;
   end Enable_USART1;

   procedure Enable_USART2 is
   begin
      RCC.RCC_Periph.APB1ENR.USART2EN := 1;
   end Enable_USART2;

   procedure Enable_USART3 is
   begin
      RCC.RCC_Periph.APB1ENR.USART3EN := 1;
   end Enable_USART3;

   procedure Enable_UART4 is
   begin
      RCC.RCC_Periph.APB1ENR.UART4EN := 1;
   end Enable_UART4;

   procedure Enable_I2C1 is
   begin
      RCC.RCC_Periph.APB1ENR.I2C1EN := 1;
   end Enable_I2C1;

   procedure Enable_I2C2 is
   begin
      RCC.RCC_Periph.APB1ENR.I2C2EN := 1;
   end Enable_I2C2;

   procedure Enable_I2C3 is
   begin
      RCC.RCC_Periph.APB1ENR.I2C3EN := 1;
   end Enable_I2C3;

   --  ----------------------------------------------------------------------
   --  RCC reset hooks
   --  ----------------------------------------------------------------------

   procedure Brief_Delay is
   begin
      for K in 1 .. 8 loop
         null;
         pragma Inspection_Point (K);
      end loop;
   end Brief_Delay;

   procedure Reset_SPI1 is
   begin
      RCC.RCC_Periph.APB2RSTR.SPI1RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB2RSTR.SPI1RST := 0;
   end Reset_SPI1;

   procedure Reset_SPI2 is
   begin
      RCC.RCC_Periph.APB1RSTR.SPI2RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.SPI2RST := 0;
   end Reset_SPI2;

   procedure Reset_SPI3 is
   begin
      RCC.RCC_Periph.APB1RSTR.SPI3RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.SPI3RST := 0;
   end Reset_SPI3;

   procedure Reset_USART1 is
   begin
      RCC.RCC_Periph.APB2RSTR.USART1RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB2RSTR.USART1RST := 0;
   end Reset_USART1;

   procedure Reset_USART2 is
   begin
      RCC.RCC_Periph.APB1RSTR.UART2RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.UART2RST := 0;
   end Reset_USART2;

   procedure Reset_USART3 is
   begin
      RCC.RCC_Periph.APB1RSTR.UART3RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.UART3RST := 0;
   end Reset_USART3;

   procedure Reset_UART4 is
   begin
      RCC.RCC_Periph.APB1RSTR.UART4RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.UART4RST := 0;
   end Reset_UART4;

   procedure Reset_I2C1 is
   begin
      RCC.RCC_Periph.APB1RSTR.I2C1RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.I2C1RST := 0;
   end Reset_I2C1;

   procedure Reset_I2C2 is
   begin
      RCC.RCC_Periph.APB1RSTR.I2C2RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.I2C2RST := 0;
   end Reset_I2C2;

   procedure Reset_I2C3 is
   begin
      RCC.RCC_Periph.APB1RSTR.I2C3RST := 1;
      Brief_Delay;
      RCC.RCC_Periph.APB1RSTR.I2C3RST := 0;
   end Reset_I2C3;

end Clock_Tree;
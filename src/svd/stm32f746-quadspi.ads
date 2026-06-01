pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F746.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package STM32F746.QUADSPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CR_EN_Field is STM32F746.Bit;
   subtype CR_ABORT_Field is STM32F746.Bit;
   subtype CR_DMAEN_Field is STM32F746.Bit;
   subtype CR_TCEN_Field is STM32F746.Bit;
   subtype CR_SSHIFT_Field is STM32F746.Bit;
   subtype CR_DFM_Field is STM32F746.Bit;
   subtype CR_FSEL_Field is STM32F746.Bit;
   subtype CR_FTHRES_Field is STM32F746.UInt5;
   subtype CR_TEIE_Field is STM32F746.Bit;
   subtype CR_TCIE_Field is STM32F746.Bit;
   subtype CR_FTIE_Field is STM32F746.Bit;
   subtype CR_SMIE_Field is STM32F746.Bit;
   subtype CR_TOIE_Field is STM32F746.Bit;
   subtype CR_APMS_Field is STM32F746.Bit;
   subtype CR_PMM_Field is STM32F746.Bit;
   subtype CR_PRESCALER_Field is STM32F746.Byte;

   --  control register
   type CR_Register is record
      --  Enable
      EN             : CR_EN_Field := 16#0#;
      --  Abort request
      ABORT_k        : CR_ABORT_Field := 16#0#;
      --  DMA enable
      DMAEN          : CR_DMAEN_Field := 16#0#;
      --  Timeout counter enable
      TCEN           : CR_TCEN_Field := 16#0#;
      --  Sample shift
      SSHIFT         : CR_SSHIFT_Field := 16#0#;
      --  unspecified
      Reserved_5_5   : STM32F746.Bit := 16#0#;
      --  Dual-flash mode
      DFM            : CR_DFM_Field := 16#0#;
      --  FLASH memory selection
      FSEL           : CR_FSEL_Field := 16#0#;
      --  IFO threshold level
      FTHRES         : CR_FTHRES_Field := 16#0#;
      --  unspecified
      Reserved_13_15 : STM32F746.UInt3 := 16#0#;
      --  Transfer error interrupt enable
      TEIE           : CR_TEIE_Field := 16#0#;
      --  Transfer complete interrupt enable
      TCIE           : CR_TCIE_Field := 16#0#;
      --  FIFO threshold interrupt enable
      FTIE           : CR_FTIE_Field := 16#0#;
      --  Status match interrupt enable
      SMIE           : CR_SMIE_Field := 16#0#;
      --  TimeOut interrupt enable
      TOIE           : CR_TOIE_Field := 16#0#;
      --  unspecified
      Reserved_21_21 : STM32F746.Bit := 16#0#;
      --  Automatic poll mode stop
      APMS           : CR_APMS_Field := 16#0#;
      --  Polling match mode
      PMM            : CR_PMM_Field := 16#0#;
      --  Clock prescaler
      PRESCALER      : CR_PRESCALER_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR_Register use record
      EN             at 0 range 0 .. 0;
      ABORT_k        at 0 range 1 .. 1;
      DMAEN          at 0 range 2 .. 2;
      TCEN           at 0 range 3 .. 3;
      SSHIFT         at 0 range 4 .. 4;
      Reserved_5_5   at 0 range 5 .. 5;
      DFM            at 0 range 6 .. 6;
      FSEL           at 0 range 7 .. 7;
      FTHRES         at 0 range 8 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      TEIE           at 0 range 16 .. 16;
      TCIE           at 0 range 17 .. 17;
      FTIE           at 0 range 18 .. 18;
      SMIE           at 0 range 19 .. 19;
      TOIE           at 0 range 20 .. 20;
      Reserved_21_21 at 0 range 21 .. 21;
      APMS           at 0 range 22 .. 22;
      PMM            at 0 range 23 .. 23;
      PRESCALER      at 0 range 24 .. 31;
   end record;

   subtype DCR_CKMODE_Field is STM32F746.Bit;
   subtype DCR_CSHT_Field is STM32F746.UInt3;
   subtype DCR_FSIZE_Field is STM32F746.UInt5;

   --  device configuration register
   type DCR_Register is record
      --  Mode 0 / mode 3
      CKMODE         : DCR_CKMODE_Field := 16#0#;
      --  unspecified
      Reserved_1_7   : STM32F746.UInt7 := 16#0#;
      --  Chip select high time
      CSHT           : DCR_CSHT_Field := 16#0#;
      --  unspecified
      Reserved_11_15 : STM32F746.UInt5 := 16#0#;
      --  FLASH memory size
      FSIZE          : DCR_FSIZE_Field := 16#0#;
      --  unspecified
      Reserved_21_31 : STM32F746.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DCR_Register use record
      CKMODE         at 0 range 0 .. 0;
      Reserved_1_7   at 0 range 1 .. 7;
      CSHT           at 0 range 8 .. 10;
      Reserved_11_15 at 0 range 11 .. 15;
      FSIZE          at 0 range 16 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   subtype SR_TEF_Field is STM32F746.Bit;
   subtype SR_TCF_Field is STM32F746.Bit;
   subtype SR_FTF_Field is STM32F746.Bit;
   subtype SR_SMF_Field is STM32F746.Bit;
   subtype SR_TOF_Field is STM32F746.Bit;
   subtype SR_BUSY_Field is STM32F746.Bit;
   subtype SR_FLEVEL_Field is STM32F746.UInt7;

   --  status register
   type SR_Register is record
      --  Read-only. Transfer error flag
      TEF            : SR_TEF_Field;
      --  Read-only. Transfer complete flag
      TCF            : SR_TCF_Field;
      --  Read-only. FIFO threshold flag
      FTF            : SR_FTF_Field;
      --  Read-only. Status match flag
      SMF            : SR_SMF_Field;
      --  Read-only. Timeout flag
      TOF            : SR_TOF_Field;
      --  Read-only. Busy
      BUSY           : SR_BUSY_Field;
      --  unspecified
      Reserved_6_7   : STM32F746.UInt2;
      --  Read-only. FIFO level
      FLEVEL         : SR_FLEVEL_Field;
      --  unspecified
      Reserved_15_31 : STM32F746.UInt17;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      TEF            at 0 range 0 .. 0;
      TCF            at 0 range 1 .. 1;
      FTF            at 0 range 2 .. 2;
      SMF            at 0 range 3 .. 3;
      TOF            at 0 range 4 .. 4;
      BUSY           at 0 range 5 .. 5;
      Reserved_6_7   at 0 range 6 .. 7;
      FLEVEL         at 0 range 8 .. 14;
      Reserved_15_31 at 0 range 15 .. 31;
   end record;

   subtype FCR_CTEF_Field is STM32F746.Bit;
   subtype FCR_CTCF_Field is STM32F746.Bit;
   subtype FCR_CSMF_Field is STM32F746.Bit;
   subtype FCR_CTOF_Field is STM32F746.Bit;

   --  flag clear register
   type FCR_Register is record
      --  Clear transfer error flag
      CTEF          : FCR_CTEF_Field := 16#0#;
      --  Clear transfer complete flag
      CTCF          : FCR_CTCF_Field := 16#0#;
      --  unspecified
      Reserved_2_2  : STM32F746.Bit := 16#0#;
      --  Clear status match flag
      CSMF          : FCR_CSMF_Field := 16#0#;
      --  Clear timeout flag
      CTOF          : FCR_CTOF_Field := 16#0#;
      --  unspecified
      Reserved_5_31 : STM32F746.UInt27 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for FCR_Register use record
      CTEF          at 0 range 0 .. 0;
      CTCF          at 0 range 1 .. 1;
      Reserved_2_2  at 0 range 2 .. 2;
      CSMF          at 0 range 3 .. 3;
      CTOF          at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype CCR_INSTRUCTION_Field is STM32F746.Byte;
   subtype CCR_IMODE_Field is STM32F746.UInt2;
   subtype CCR_ADMODE_Field is STM32F746.UInt2;
   subtype CCR_ADSIZE_Field is STM32F746.UInt2;
   subtype CCR_ABMODE_Field is STM32F746.UInt2;
   subtype CCR_ABSIZE_Field is STM32F746.UInt2;
   subtype CCR_DCYC_Field is STM32F746.UInt5;
   subtype CCR_DMODE_Field is STM32F746.UInt2;
   subtype CCR_FMODE_Field is STM32F746.UInt2;
   subtype CCR_SIOO_Field is STM32F746.Bit;
   subtype CCR_DHHC_Field is STM32F746.Bit;
   subtype CCR_DDRM_Field is STM32F746.Bit;

   --  communication configuration register
   type CCR_Register is record
      --  Instruction
      INSTRUCTION    : CCR_INSTRUCTION_Field := 16#0#;
      --  Instruction mode
      IMODE          : CCR_IMODE_Field := 16#0#;
      --  Address mode
      ADMODE         : CCR_ADMODE_Field := 16#0#;
      --  Address size
      ADSIZE         : CCR_ADSIZE_Field := 16#0#;
      --  Alternate bytes mode
      ABMODE         : CCR_ABMODE_Field := 16#0#;
      --  Alternate bytes size
      ABSIZE         : CCR_ABSIZE_Field := 16#0#;
      --  Number of dummy cycles
      DCYC           : CCR_DCYC_Field := 16#0#;
      --  unspecified
      Reserved_23_23 : STM32F746.Bit := 16#0#;
      --  Data mode
      DMODE          : CCR_DMODE_Field := 16#0#;
      --  Functional mode
      FMODE          : CCR_FMODE_Field := 16#0#;
      --  Send instruction only once mode
      SIOO           : CCR_SIOO_Field := 16#0#;
      --  unspecified
      Reserved_29_29 : STM32F746.Bit := 16#0#;
      --  DDR hold half cycle
      DHHC           : CCR_DHHC_Field := 16#0#;
      --  Double data rate mode
      DDRM           : CCR_DDRM_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CCR_Register use record
      INSTRUCTION    at 0 range 0 .. 7;
      IMODE          at 0 range 8 .. 9;
      ADMODE         at 0 range 10 .. 11;
      ADSIZE         at 0 range 12 .. 13;
      ABMODE         at 0 range 14 .. 15;
      ABSIZE         at 0 range 16 .. 17;
      DCYC           at 0 range 18 .. 22;
      Reserved_23_23 at 0 range 23 .. 23;
      DMODE          at 0 range 24 .. 25;
      FMODE          at 0 range 26 .. 27;
      SIOO           at 0 range 28 .. 28;
      Reserved_29_29 at 0 range 29 .. 29;
      DHHC           at 0 range 30 .. 30;
      DDRM           at 0 range 31 .. 31;
   end record;

   subtype PIR_INTERVAL_Field is STM32F746.UInt16;

   --  polling interval register
   type PIR_Register is record
      --  Polling interval
      INTERVAL       : PIR_INTERVAL_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32F746.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for PIR_Register use record
      INTERVAL       at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   subtype LPTR_TIMEOUT_Field is STM32F746.UInt16;

   --  low-power timeout register
   type LPTR_Register is record
      --  Timeout period
      TIMEOUT        : LPTR_TIMEOUT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : STM32F746.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for LPTR_Register use record
      TIMEOUT        at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  QuadSPI interface
   type QUADSPI_Peripheral is record
      --  control register
      CR    : aliased CR_Register;
      --  device configuration register
      DCR   : aliased DCR_Register;
      --  status register
      SR    : aliased SR_Register;
      --  flag clear register
      FCR   : aliased FCR_Register;
      --  data length register
      DLR   : aliased STM32F746.UInt32;
      --  communication configuration register
      CCR   : aliased CCR_Register;
      --  address register
      AR    : aliased STM32F746.UInt32;
      --  ABR
      ABR   : aliased STM32F746.UInt32;
      --  data register
      DR    : aliased STM32F746.UInt32;
      --  polling status mask register
      PSMKR : aliased STM32F746.UInt32;
      --  polling status match register
      PSMAR : aliased STM32F746.UInt32;
      --  polling interval register
      PIR   : aliased PIR_Register;
      --  low-power timeout register
      LPTR  : aliased LPTR_Register;
   end record
     with Volatile;

   for QUADSPI_Peripheral use record
      CR    at 16#0# range 0 .. 31;
      DCR   at 16#4# range 0 .. 31;
      SR    at 16#8# range 0 .. 31;
      FCR   at 16#C# range 0 .. 31;
      DLR   at 16#10# range 0 .. 31;
      CCR   at 16#14# range 0 .. 31;
      AR    at 16#18# range 0 .. 31;
      ABR   at 16#1C# range 0 .. 31;
      DR    at 16#20# range 0 .. 31;
      PSMKR at 16#24# range 0 .. 31;
      PSMAR at 16#28# range 0 .. 31;
      PIR   at 16#2C# range 0 .. 31;
      LPTR  at 16#30# range 0 .. 31;
   end record;

   --  QuadSPI interface
   QUADSPI_Periph : aliased QUADSPI_Peripheral
     with Import, Address => QUADSPI_Base;

end STM32F746.QUADSPI;

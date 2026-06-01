pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F746.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package STM32F746.CRYP is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CR_ALGODIR_Field is STM32F746.Bit;
   subtype CR_ALGOMODE0_Field is STM32F746.UInt3;
   subtype CR_DATATYPE_Field is STM32F746.UInt2;
   subtype CR_KEYSIZE_Field is STM32F746.UInt2;
   subtype CR_FFLUSH_Field is STM32F746.Bit;
   subtype CR_CRYPEN_Field is STM32F746.Bit;
   subtype CR_GCM_CCMPH_Field is STM32F746.UInt2;
   subtype CR_ALGOMODE3_Field is STM32F746.Bit;

   --  control register
   type CR_Register is record
      --  unspecified
      Reserved_0_1   : STM32F746.UInt2 := 16#0#;
      --  Algorithm direction
      ALGODIR        : CR_ALGODIR_Field := 16#0#;
      --  Algorithm mode
      ALGOMODE0      : CR_ALGOMODE0_Field := 16#0#;
      --  Data type selection
      DATATYPE       : CR_DATATYPE_Field := 16#0#;
      --  Key size selection (AES mode only)
      KEYSIZE        : CR_KEYSIZE_Field := 16#0#;
      --  unspecified
      Reserved_10_13 : STM32F746.UInt4 := 16#0#;
      --  Write-only. FIFO flush
      FFLUSH         : CR_FFLUSH_Field := 16#0#;
      --  Cryptographic processor enable
      CRYPEN         : CR_CRYPEN_Field := 16#0#;
      --  GCM_CCMPH
      GCM_CCMPH      : CR_GCM_CCMPH_Field := 16#0#;
      --  unspecified
      Reserved_18_18 : STM32F746.Bit := 16#0#;
      --  ALGOMODE
      ALGOMODE3      : CR_ALGOMODE3_Field := 16#0#;
      --  unspecified
      Reserved_20_31 : STM32F746.UInt12 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR_Register use record
      Reserved_0_1   at 0 range 0 .. 1;
      ALGODIR        at 0 range 2 .. 2;
      ALGOMODE0      at 0 range 3 .. 5;
      DATATYPE       at 0 range 6 .. 7;
      KEYSIZE        at 0 range 8 .. 9;
      Reserved_10_13 at 0 range 10 .. 13;
      FFLUSH         at 0 range 14 .. 14;
      CRYPEN         at 0 range 15 .. 15;
      GCM_CCMPH      at 0 range 16 .. 17;
      Reserved_18_18 at 0 range 18 .. 18;
      ALGOMODE3      at 0 range 19 .. 19;
      Reserved_20_31 at 0 range 20 .. 31;
   end record;

   subtype SR_IFEM_Field is STM32F746.Bit;
   subtype SR_IFNF_Field is STM32F746.Bit;
   subtype SR_OFNE_Field is STM32F746.Bit;
   subtype SR_OFFU_Field is STM32F746.Bit;
   subtype SR_BUSY_Field is STM32F746.Bit;

   --  status register
   type SR_Register is record
      --  Read-only. Input FIFO empty
      IFEM          : SR_IFEM_Field;
      --  Read-only. Input FIFO not full
      IFNF          : SR_IFNF_Field;
      --  Read-only. Output FIFO not empty
      OFNE          : SR_OFNE_Field;
      --  Read-only. Output FIFO full
      OFFU          : SR_OFFU_Field;
      --  Read-only. Busy bit
      BUSY          : SR_BUSY_Field;
      --  unspecified
      Reserved_5_31 : STM32F746.UInt27;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      IFEM          at 0 range 0 .. 0;
      IFNF          at 0 range 1 .. 1;
      OFNE          at 0 range 2 .. 2;
      OFFU          at 0 range 3 .. 3;
      BUSY          at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   subtype DMACR_DIEN_Field is STM32F746.Bit;
   subtype DMACR_DOEN_Field is STM32F746.Bit;

   --  DMA control register
   type DMACR_Register is record
      --  DMA input enable
      DIEN          : DMACR_DIEN_Field := 16#0#;
      --  DMA output enable
      DOEN          : DMACR_DOEN_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : STM32F746.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DMACR_Register use record
      DIEN          at 0 range 0 .. 0;
      DOEN          at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype IMSCR_INIM_Field is STM32F746.Bit;
   subtype IMSCR_OUTIM_Field is STM32F746.Bit;

   --  interrupt mask set/clear register
   type IMSCR_Register is record
      --  Input FIFO service interrupt mask
      INIM          : IMSCR_INIM_Field := 16#0#;
      --  Output FIFO service interrupt mask
      OUTIM         : IMSCR_OUTIM_Field := 16#0#;
      --  unspecified
      Reserved_2_31 : STM32F746.UInt30 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IMSCR_Register use record
      INIM          at 0 range 0 .. 0;
      OUTIM         at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype RISR_INRIS_Field is STM32F746.Bit;
   subtype RISR_OUTRIS_Field is STM32F746.Bit;

   --  raw interrupt status register
   type RISR_Register is record
      --  Read-only. Input FIFO service raw interrupt status
      INRIS         : RISR_INRIS_Field;
      --  Read-only. Output FIFO service raw interrupt status
      OUTRIS        : RISR_OUTRIS_Field;
      --  unspecified
      Reserved_2_31 : STM32F746.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for RISR_Register use record
      INRIS         at 0 range 0 .. 0;
      OUTRIS        at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   subtype MISR_INMIS_Field is STM32F746.Bit;
   subtype MISR_OUTMIS_Field is STM32F746.Bit;

   --  masked interrupt status register
   type MISR_Register is record
      --  Read-only. Input FIFO service masked interrupt status
      INMIS         : MISR_INMIS_Field;
      --  Read-only. Output FIFO service masked interrupt status
      OUTMIS        : MISR_OUTMIS_Field;
      --  unspecified
      Reserved_2_31 : STM32F746.UInt30;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for MISR_Register use record
      INMIS         at 0 range 0 .. 0;
      OUTMIS        at 0 range 1 .. 1;
      Reserved_2_31 at 0 range 2 .. 31;
   end record;

   --  K0LR_b array element
   subtype K0LR_b_Element is STM32F746.Bit;

   --  K0LR_b array
   type K0LR_b_Field_Array is array (224 .. 255) of K0LR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K0LR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K0LR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K0LR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K0RR_b array element
   subtype K0RR_b_Element is STM32F746.Bit;

   --  K0RR_b array
   type K0RR_b_Field_Array is array (192 .. 223) of K0RR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K0RR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K0RR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K0RR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K1LR_b array element
   subtype K1LR_b_Element is STM32F746.Bit;

   --  K1LR_b array
   type K1LR_b_Field_Array is array (160 .. 191) of K1LR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K1LR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K1LR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K1LR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K1RR_b array element
   subtype K1RR_b_Element is STM32F746.Bit;

   --  K1RR_b array
   type K1RR_b_Field_Array is array (128 .. 159) of K1RR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K1RR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K1RR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K1RR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K2LR_b array element
   subtype K2LR_b_Element is STM32F746.Bit;

   --  K2LR_b array
   type K2LR_b_Field_Array is array (96 .. 127) of K2LR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K2LR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K2LR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K2LR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K2RR_b array element
   subtype K2RR_b_Element is STM32F746.Bit;

   --  K2RR_b array
   type K2RR_b_Field_Array is array (64 .. 95) of K2RR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K2RR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K2RR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K2RR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K3LR_b array element
   subtype K3LR_b_Element is STM32F746.Bit;

   --  K3LR_b array
   type K3LR_b_Field_Array is array (32 .. 63) of K3LR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K3LR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K3LR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K3LR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   --  K3RR_b array element
   subtype K3RR_b_Element is STM32F746.Bit;

   --  K3RR_b array
   type K3RR_b_Field_Array is array (0 .. 31) of K3RR_b_Element
     with Component_Size => 1, Size => 32;

   --  key registers
   type K3RR_Register
     (As_Array : Boolean := False)
   is record
      case As_Array is
         when False =>
            --  b as a value
            Val : STM32F746.UInt32;
         when True =>
            --  b as an array
            Arr : K3RR_b_Field_Array;
      end case;
   end record
     with Unchecked_Union, Size => 32, Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for K3RR_Register use record
      Val at 0 range 0 .. 31;
      Arr at 0 range 0 .. 31;
   end record;

   subtype IV0LR_IV31_Field is STM32F746.Bit;
   subtype IV0LR_IV30_Field is STM32F746.Bit;
   subtype IV0LR_IV29_Field is STM32F746.Bit;
   subtype IV0LR_IV28_Field is STM32F746.Bit;
   subtype IV0LR_IV27_Field is STM32F746.Bit;
   subtype IV0LR_IV26_Field is STM32F746.Bit;
   subtype IV0LR_IV25_Field is STM32F746.Bit;
   subtype IV0LR_IV24_Field is STM32F746.Bit;
   subtype IV0LR_IV23_Field is STM32F746.Bit;
   subtype IV0LR_IV22_Field is STM32F746.Bit;
   subtype IV0LR_IV21_Field is STM32F746.Bit;
   subtype IV0LR_IV20_Field is STM32F746.Bit;
   subtype IV0LR_IV19_Field is STM32F746.Bit;
   subtype IV0LR_IV18_Field is STM32F746.Bit;
   subtype IV0LR_IV17_Field is STM32F746.Bit;
   subtype IV0LR_IV16_Field is STM32F746.Bit;
   subtype IV0LR_IV15_Field is STM32F746.Bit;
   subtype IV0LR_IV14_Field is STM32F746.Bit;
   subtype IV0LR_IV13_Field is STM32F746.Bit;
   subtype IV0LR_IV12_Field is STM32F746.Bit;
   subtype IV0LR_IV11_Field is STM32F746.Bit;
   subtype IV0LR_IV10_Field is STM32F746.Bit;
   subtype IV0LR_IV9_Field is STM32F746.Bit;
   subtype IV0LR_IV8_Field is STM32F746.Bit;
   subtype IV0LR_IV7_Field is STM32F746.Bit;
   subtype IV0LR_IV6_Field is STM32F746.Bit;
   subtype IV0LR_IV5_Field is STM32F746.Bit;
   subtype IV0LR_IV4_Field is STM32F746.Bit;
   subtype IV0LR_IV3_Field is STM32F746.Bit;
   subtype IV0LR_IV2_Field is STM32F746.Bit;
   subtype IV0LR_IV1_Field is STM32F746.Bit;
   subtype IV0LR_IV0_Field is STM32F746.Bit;

   --  initialization vector registers
   type IV0LR_Register is record
      --  IV31
      IV31 : IV0LR_IV31_Field := 16#0#;
      --  IV30
      IV30 : IV0LR_IV30_Field := 16#0#;
      --  IV29
      IV29 : IV0LR_IV29_Field := 16#0#;
      --  IV28
      IV28 : IV0LR_IV28_Field := 16#0#;
      --  IV27
      IV27 : IV0LR_IV27_Field := 16#0#;
      --  IV26
      IV26 : IV0LR_IV26_Field := 16#0#;
      --  IV25
      IV25 : IV0LR_IV25_Field := 16#0#;
      --  IV24
      IV24 : IV0LR_IV24_Field := 16#0#;
      --  IV23
      IV23 : IV0LR_IV23_Field := 16#0#;
      --  IV22
      IV22 : IV0LR_IV22_Field := 16#0#;
      --  IV21
      IV21 : IV0LR_IV21_Field := 16#0#;
      --  IV20
      IV20 : IV0LR_IV20_Field := 16#0#;
      --  IV19
      IV19 : IV0LR_IV19_Field := 16#0#;
      --  IV18
      IV18 : IV0LR_IV18_Field := 16#0#;
      --  IV17
      IV17 : IV0LR_IV17_Field := 16#0#;
      --  IV16
      IV16 : IV0LR_IV16_Field := 16#0#;
      --  IV15
      IV15 : IV0LR_IV15_Field := 16#0#;
      --  IV14
      IV14 : IV0LR_IV14_Field := 16#0#;
      --  IV13
      IV13 : IV0LR_IV13_Field := 16#0#;
      --  IV12
      IV12 : IV0LR_IV12_Field := 16#0#;
      --  IV11
      IV11 : IV0LR_IV11_Field := 16#0#;
      --  IV10
      IV10 : IV0LR_IV10_Field := 16#0#;
      --  IV9
      IV9  : IV0LR_IV9_Field := 16#0#;
      --  IV8
      IV8  : IV0LR_IV8_Field := 16#0#;
      --  IV7
      IV7  : IV0LR_IV7_Field := 16#0#;
      --  IV6
      IV6  : IV0LR_IV6_Field := 16#0#;
      --  IV5
      IV5  : IV0LR_IV5_Field := 16#0#;
      --  IV4
      IV4  : IV0LR_IV4_Field := 16#0#;
      --  IV3
      IV3  : IV0LR_IV3_Field := 16#0#;
      --  IV2
      IV2  : IV0LR_IV2_Field := 16#0#;
      --  IV1
      IV1  : IV0LR_IV1_Field := 16#0#;
      --  IV0
      IV0  : IV0LR_IV0_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IV0LR_Register use record
      IV31 at 0 range 0 .. 0;
      IV30 at 0 range 1 .. 1;
      IV29 at 0 range 2 .. 2;
      IV28 at 0 range 3 .. 3;
      IV27 at 0 range 4 .. 4;
      IV26 at 0 range 5 .. 5;
      IV25 at 0 range 6 .. 6;
      IV24 at 0 range 7 .. 7;
      IV23 at 0 range 8 .. 8;
      IV22 at 0 range 9 .. 9;
      IV21 at 0 range 10 .. 10;
      IV20 at 0 range 11 .. 11;
      IV19 at 0 range 12 .. 12;
      IV18 at 0 range 13 .. 13;
      IV17 at 0 range 14 .. 14;
      IV16 at 0 range 15 .. 15;
      IV15 at 0 range 16 .. 16;
      IV14 at 0 range 17 .. 17;
      IV13 at 0 range 18 .. 18;
      IV12 at 0 range 19 .. 19;
      IV11 at 0 range 20 .. 20;
      IV10 at 0 range 21 .. 21;
      IV9  at 0 range 22 .. 22;
      IV8  at 0 range 23 .. 23;
      IV7  at 0 range 24 .. 24;
      IV6  at 0 range 25 .. 25;
      IV5  at 0 range 26 .. 26;
      IV4  at 0 range 27 .. 27;
      IV3  at 0 range 28 .. 28;
      IV2  at 0 range 29 .. 29;
      IV1  at 0 range 30 .. 30;
      IV0  at 0 range 31 .. 31;
   end record;

   subtype IV0RR_IV63_Field is STM32F746.Bit;
   subtype IV0RR_IV62_Field is STM32F746.Bit;
   subtype IV0RR_IV61_Field is STM32F746.Bit;
   subtype IV0RR_IV60_Field is STM32F746.Bit;
   subtype IV0RR_IV59_Field is STM32F746.Bit;
   subtype IV0RR_IV58_Field is STM32F746.Bit;
   subtype IV0RR_IV57_Field is STM32F746.Bit;
   subtype IV0RR_IV56_Field is STM32F746.Bit;
   subtype IV0RR_IV55_Field is STM32F746.Bit;
   subtype IV0RR_IV54_Field is STM32F746.Bit;
   subtype IV0RR_IV53_Field is STM32F746.Bit;
   subtype IV0RR_IV52_Field is STM32F746.Bit;
   subtype IV0RR_IV51_Field is STM32F746.Bit;
   subtype IV0RR_IV50_Field is STM32F746.Bit;
   subtype IV0RR_IV49_Field is STM32F746.Bit;
   subtype IV0RR_IV48_Field is STM32F746.Bit;
   subtype IV0RR_IV47_Field is STM32F746.Bit;
   subtype IV0RR_IV46_Field is STM32F746.Bit;
   subtype IV0RR_IV45_Field is STM32F746.Bit;
   subtype IV0RR_IV44_Field is STM32F746.Bit;
   subtype IV0RR_IV43_Field is STM32F746.Bit;
   subtype IV0RR_IV42_Field is STM32F746.Bit;
   subtype IV0RR_IV41_Field is STM32F746.Bit;
   subtype IV0RR_IV40_Field is STM32F746.Bit;
   subtype IV0RR_IV39_Field is STM32F746.Bit;
   subtype IV0RR_IV38_Field is STM32F746.Bit;
   subtype IV0RR_IV37_Field is STM32F746.Bit;
   subtype IV0RR_IV36_Field is STM32F746.Bit;
   subtype IV0RR_IV35_Field is STM32F746.Bit;
   subtype IV0RR_IV34_Field is STM32F746.Bit;
   subtype IV0RR_IV33_Field is STM32F746.Bit;
   subtype IV0RR_IV32_Field is STM32F746.Bit;

   --  initialization vector registers
   type IV0RR_Register is record
      --  IV63
      IV63 : IV0RR_IV63_Field := 16#0#;
      --  IV62
      IV62 : IV0RR_IV62_Field := 16#0#;
      --  IV61
      IV61 : IV0RR_IV61_Field := 16#0#;
      --  IV60
      IV60 : IV0RR_IV60_Field := 16#0#;
      --  IV59
      IV59 : IV0RR_IV59_Field := 16#0#;
      --  IV58
      IV58 : IV0RR_IV58_Field := 16#0#;
      --  IV57
      IV57 : IV0RR_IV57_Field := 16#0#;
      --  IV56
      IV56 : IV0RR_IV56_Field := 16#0#;
      --  IV55
      IV55 : IV0RR_IV55_Field := 16#0#;
      --  IV54
      IV54 : IV0RR_IV54_Field := 16#0#;
      --  IV53
      IV53 : IV0RR_IV53_Field := 16#0#;
      --  IV52
      IV52 : IV0RR_IV52_Field := 16#0#;
      --  IV51
      IV51 : IV0RR_IV51_Field := 16#0#;
      --  IV50
      IV50 : IV0RR_IV50_Field := 16#0#;
      --  IV49
      IV49 : IV0RR_IV49_Field := 16#0#;
      --  IV48
      IV48 : IV0RR_IV48_Field := 16#0#;
      --  IV47
      IV47 : IV0RR_IV47_Field := 16#0#;
      --  IV46
      IV46 : IV0RR_IV46_Field := 16#0#;
      --  IV45
      IV45 : IV0RR_IV45_Field := 16#0#;
      --  IV44
      IV44 : IV0RR_IV44_Field := 16#0#;
      --  IV43
      IV43 : IV0RR_IV43_Field := 16#0#;
      --  IV42
      IV42 : IV0RR_IV42_Field := 16#0#;
      --  IV41
      IV41 : IV0RR_IV41_Field := 16#0#;
      --  IV40
      IV40 : IV0RR_IV40_Field := 16#0#;
      --  IV39
      IV39 : IV0RR_IV39_Field := 16#0#;
      --  IV38
      IV38 : IV0RR_IV38_Field := 16#0#;
      --  IV37
      IV37 : IV0RR_IV37_Field := 16#0#;
      --  IV36
      IV36 : IV0RR_IV36_Field := 16#0#;
      --  IV35
      IV35 : IV0RR_IV35_Field := 16#0#;
      --  IV34
      IV34 : IV0RR_IV34_Field := 16#0#;
      --  IV33
      IV33 : IV0RR_IV33_Field := 16#0#;
      --  IV32
      IV32 : IV0RR_IV32_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IV0RR_Register use record
      IV63 at 0 range 0 .. 0;
      IV62 at 0 range 1 .. 1;
      IV61 at 0 range 2 .. 2;
      IV60 at 0 range 3 .. 3;
      IV59 at 0 range 4 .. 4;
      IV58 at 0 range 5 .. 5;
      IV57 at 0 range 6 .. 6;
      IV56 at 0 range 7 .. 7;
      IV55 at 0 range 8 .. 8;
      IV54 at 0 range 9 .. 9;
      IV53 at 0 range 10 .. 10;
      IV52 at 0 range 11 .. 11;
      IV51 at 0 range 12 .. 12;
      IV50 at 0 range 13 .. 13;
      IV49 at 0 range 14 .. 14;
      IV48 at 0 range 15 .. 15;
      IV47 at 0 range 16 .. 16;
      IV46 at 0 range 17 .. 17;
      IV45 at 0 range 18 .. 18;
      IV44 at 0 range 19 .. 19;
      IV43 at 0 range 20 .. 20;
      IV42 at 0 range 21 .. 21;
      IV41 at 0 range 22 .. 22;
      IV40 at 0 range 23 .. 23;
      IV39 at 0 range 24 .. 24;
      IV38 at 0 range 25 .. 25;
      IV37 at 0 range 26 .. 26;
      IV36 at 0 range 27 .. 27;
      IV35 at 0 range 28 .. 28;
      IV34 at 0 range 29 .. 29;
      IV33 at 0 range 30 .. 30;
      IV32 at 0 range 31 .. 31;
   end record;

   subtype IV1LR_IV95_Field is STM32F746.Bit;
   subtype IV1LR_IV94_Field is STM32F746.Bit;
   subtype IV1LR_IV93_Field is STM32F746.Bit;
   subtype IV1LR_IV92_Field is STM32F746.Bit;
   subtype IV1LR_IV91_Field is STM32F746.Bit;
   subtype IV1LR_IV90_Field is STM32F746.Bit;
   subtype IV1LR_IV89_Field is STM32F746.Bit;
   subtype IV1LR_IV88_Field is STM32F746.Bit;
   subtype IV1LR_IV87_Field is STM32F746.Bit;
   subtype IV1LR_IV86_Field is STM32F746.Bit;
   subtype IV1LR_IV85_Field is STM32F746.Bit;
   subtype IV1LR_IV84_Field is STM32F746.Bit;
   subtype IV1LR_IV83_Field is STM32F746.Bit;
   subtype IV1LR_IV82_Field is STM32F746.Bit;
   subtype IV1LR_IV81_Field is STM32F746.Bit;
   subtype IV1LR_IV80_Field is STM32F746.Bit;
   subtype IV1LR_IV79_Field is STM32F746.Bit;
   subtype IV1LR_IV78_Field is STM32F746.Bit;
   subtype IV1LR_IV77_Field is STM32F746.Bit;
   subtype IV1LR_IV76_Field is STM32F746.Bit;
   subtype IV1LR_IV75_Field is STM32F746.Bit;
   subtype IV1LR_IV74_Field is STM32F746.Bit;
   subtype IV1LR_IV73_Field is STM32F746.Bit;
   subtype IV1LR_IV72_Field is STM32F746.Bit;
   subtype IV1LR_IV71_Field is STM32F746.Bit;
   subtype IV1LR_IV70_Field is STM32F746.Bit;
   subtype IV1LR_IV69_Field is STM32F746.Bit;
   subtype IV1LR_IV68_Field is STM32F746.Bit;
   subtype IV1LR_IV67_Field is STM32F746.Bit;
   subtype IV1LR_IV66_Field is STM32F746.Bit;
   subtype IV1LR_IV65_Field is STM32F746.Bit;
   subtype IV1LR_IV64_Field is STM32F746.Bit;

   --  initialization vector registers
   type IV1LR_Register is record
      --  IV95
      IV95 : IV1LR_IV95_Field := 16#0#;
      --  IV94
      IV94 : IV1LR_IV94_Field := 16#0#;
      --  IV93
      IV93 : IV1LR_IV93_Field := 16#0#;
      --  IV92
      IV92 : IV1LR_IV92_Field := 16#0#;
      --  IV91
      IV91 : IV1LR_IV91_Field := 16#0#;
      --  IV90
      IV90 : IV1LR_IV90_Field := 16#0#;
      --  IV89
      IV89 : IV1LR_IV89_Field := 16#0#;
      --  IV88
      IV88 : IV1LR_IV88_Field := 16#0#;
      --  IV87
      IV87 : IV1LR_IV87_Field := 16#0#;
      --  IV86
      IV86 : IV1LR_IV86_Field := 16#0#;
      --  IV85
      IV85 : IV1LR_IV85_Field := 16#0#;
      --  IV84
      IV84 : IV1LR_IV84_Field := 16#0#;
      --  IV83
      IV83 : IV1LR_IV83_Field := 16#0#;
      --  IV82
      IV82 : IV1LR_IV82_Field := 16#0#;
      --  IV81
      IV81 : IV1LR_IV81_Field := 16#0#;
      --  IV80
      IV80 : IV1LR_IV80_Field := 16#0#;
      --  IV79
      IV79 : IV1LR_IV79_Field := 16#0#;
      --  IV78
      IV78 : IV1LR_IV78_Field := 16#0#;
      --  IV77
      IV77 : IV1LR_IV77_Field := 16#0#;
      --  IV76
      IV76 : IV1LR_IV76_Field := 16#0#;
      --  IV75
      IV75 : IV1LR_IV75_Field := 16#0#;
      --  IV74
      IV74 : IV1LR_IV74_Field := 16#0#;
      --  IV73
      IV73 : IV1LR_IV73_Field := 16#0#;
      --  IV72
      IV72 : IV1LR_IV72_Field := 16#0#;
      --  IV71
      IV71 : IV1LR_IV71_Field := 16#0#;
      --  IV70
      IV70 : IV1LR_IV70_Field := 16#0#;
      --  IV69
      IV69 : IV1LR_IV69_Field := 16#0#;
      --  IV68
      IV68 : IV1LR_IV68_Field := 16#0#;
      --  IV67
      IV67 : IV1LR_IV67_Field := 16#0#;
      --  IV66
      IV66 : IV1LR_IV66_Field := 16#0#;
      --  IV65
      IV65 : IV1LR_IV65_Field := 16#0#;
      --  IV64
      IV64 : IV1LR_IV64_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IV1LR_Register use record
      IV95 at 0 range 0 .. 0;
      IV94 at 0 range 1 .. 1;
      IV93 at 0 range 2 .. 2;
      IV92 at 0 range 3 .. 3;
      IV91 at 0 range 4 .. 4;
      IV90 at 0 range 5 .. 5;
      IV89 at 0 range 6 .. 6;
      IV88 at 0 range 7 .. 7;
      IV87 at 0 range 8 .. 8;
      IV86 at 0 range 9 .. 9;
      IV85 at 0 range 10 .. 10;
      IV84 at 0 range 11 .. 11;
      IV83 at 0 range 12 .. 12;
      IV82 at 0 range 13 .. 13;
      IV81 at 0 range 14 .. 14;
      IV80 at 0 range 15 .. 15;
      IV79 at 0 range 16 .. 16;
      IV78 at 0 range 17 .. 17;
      IV77 at 0 range 18 .. 18;
      IV76 at 0 range 19 .. 19;
      IV75 at 0 range 20 .. 20;
      IV74 at 0 range 21 .. 21;
      IV73 at 0 range 22 .. 22;
      IV72 at 0 range 23 .. 23;
      IV71 at 0 range 24 .. 24;
      IV70 at 0 range 25 .. 25;
      IV69 at 0 range 26 .. 26;
      IV68 at 0 range 27 .. 27;
      IV67 at 0 range 28 .. 28;
      IV66 at 0 range 29 .. 29;
      IV65 at 0 range 30 .. 30;
      IV64 at 0 range 31 .. 31;
   end record;

   subtype IV1RR_IV127_Field is STM32F746.Bit;
   subtype IV1RR_IV126_Field is STM32F746.Bit;
   subtype IV1RR_IV125_Field is STM32F746.Bit;
   subtype IV1RR_IV124_Field is STM32F746.Bit;
   subtype IV1RR_IV123_Field is STM32F746.Bit;
   subtype IV1RR_IV122_Field is STM32F746.Bit;
   subtype IV1RR_IV121_Field is STM32F746.Bit;
   subtype IV1RR_IV120_Field is STM32F746.Bit;
   subtype IV1RR_IV119_Field is STM32F746.Bit;
   subtype IV1RR_IV118_Field is STM32F746.Bit;
   subtype IV1RR_IV117_Field is STM32F746.Bit;
   subtype IV1RR_IV116_Field is STM32F746.Bit;
   subtype IV1RR_IV115_Field is STM32F746.Bit;
   subtype IV1RR_IV114_Field is STM32F746.Bit;
   subtype IV1RR_IV113_Field is STM32F746.Bit;
   subtype IV1RR_IV112_Field is STM32F746.Bit;
   subtype IV1RR_IV111_Field is STM32F746.Bit;
   subtype IV1RR_IV110_Field is STM32F746.Bit;
   subtype IV1RR_IV109_Field is STM32F746.Bit;
   subtype IV1RR_IV108_Field is STM32F746.Bit;
   subtype IV1RR_IV107_Field is STM32F746.Bit;
   subtype IV1RR_IV106_Field is STM32F746.Bit;
   subtype IV1RR_IV105_Field is STM32F746.Bit;
   subtype IV1RR_IV104_Field is STM32F746.Bit;
   subtype IV1RR_IV103_Field is STM32F746.Bit;
   subtype IV1RR_IV102_Field is STM32F746.Bit;
   subtype IV1RR_IV101_Field is STM32F746.Bit;
   subtype IV1RR_IV100_Field is STM32F746.Bit;
   subtype IV1RR_IV99_Field is STM32F746.Bit;
   subtype IV1RR_IV98_Field is STM32F746.Bit;
   subtype IV1RR_IV97_Field is STM32F746.Bit;
   subtype IV1RR_IV96_Field is STM32F746.Bit;

   --  initialization vector registers
   type IV1RR_Register is record
      --  IV127
      IV127 : IV1RR_IV127_Field := 16#0#;
      --  IV126
      IV126 : IV1RR_IV126_Field := 16#0#;
      --  IV125
      IV125 : IV1RR_IV125_Field := 16#0#;
      --  IV124
      IV124 : IV1RR_IV124_Field := 16#0#;
      --  IV123
      IV123 : IV1RR_IV123_Field := 16#0#;
      --  IV122
      IV122 : IV1RR_IV122_Field := 16#0#;
      --  IV121
      IV121 : IV1RR_IV121_Field := 16#0#;
      --  IV120
      IV120 : IV1RR_IV120_Field := 16#0#;
      --  IV119
      IV119 : IV1RR_IV119_Field := 16#0#;
      --  IV118
      IV118 : IV1RR_IV118_Field := 16#0#;
      --  IV117
      IV117 : IV1RR_IV117_Field := 16#0#;
      --  IV116
      IV116 : IV1RR_IV116_Field := 16#0#;
      --  IV115
      IV115 : IV1RR_IV115_Field := 16#0#;
      --  IV114
      IV114 : IV1RR_IV114_Field := 16#0#;
      --  IV113
      IV113 : IV1RR_IV113_Field := 16#0#;
      --  IV112
      IV112 : IV1RR_IV112_Field := 16#0#;
      --  IV111
      IV111 : IV1RR_IV111_Field := 16#0#;
      --  IV110
      IV110 : IV1RR_IV110_Field := 16#0#;
      --  IV109
      IV109 : IV1RR_IV109_Field := 16#0#;
      --  IV108
      IV108 : IV1RR_IV108_Field := 16#0#;
      --  IV107
      IV107 : IV1RR_IV107_Field := 16#0#;
      --  IV106
      IV106 : IV1RR_IV106_Field := 16#0#;
      --  IV105
      IV105 : IV1RR_IV105_Field := 16#0#;
      --  IV104
      IV104 : IV1RR_IV104_Field := 16#0#;
      --  IV103
      IV103 : IV1RR_IV103_Field := 16#0#;
      --  IV102
      IV102 : IV1RR_IV102_Field := 16#0#;
      --  IV101
      IV101 : IV1RR_IV101_Field := 16#0#;
      --  IV100
      IV100 : IV1RR_IV100_Field := 16#0#;
      --  IV99
      IV99  : IV1RR_IV99_Field := 16#0#;
      --  IV98
      IV98  : IV1RR_IV98_Field := 16#0#;
      --  IV97
      IV97  : IV1RR_IV97_Field := 16#0#;
      --  IV96
      IV96  : IV1RR_IV96_Field := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IV1RR_Register use record
      IV127 at 0 range 0 .. 0;
      IV126 at 0 range 1 .. 1;
      IV125 at 0 range 2 .. 2;
      IV124 at 0 range 3 .. 3;
      IV123 at 0 range 4 .. 4;
      IV122 at 0 range 5 .. 5;
      IV121 at 0 range 6 .. 6;
      IV120 at 0 range 7 .. 7;
      IV119 at 0 range 8 .. 8;
      IV118 at 0 range 9 .. 9;
      IV117 at 0 range 10 .. 10;
      IV116 at 0 range 11 .. 11;
      IV115 at 0 range 12 .. 12;
      IV114 at 0 range 13 .. 13;
      IV113 at 0 range 14 .. 14;
      IV112 at 0 range 15 .. 15;
      IV111 at 0 range 16 .. 16;
      IV110 at 0 range 17 .. 17;
      IV109 at 0 range 18 .. 18;
      IV108 at 0 range 19 .. 19;
      IV107 at 0 range 20 .. 20;
      IV106 at 0 range 21 .. 21;
      IV105 at 0 range 22 .. 22;
      IV104 at 0 range 23 .. 23;
      IV103 at 0 range 24 .. 24;
      IV102 at 0 range 25 .. 25;
      IV101 at 0 range 26 .. 26;
      IV100 at 0 range 27 .. 27;
      IV99  at 0 range 28 .. 28;
      IV98  at 0 range 29 .. 29;
      IV97  at 0 range 30 .. 30;
      IV96  at 0 range 31 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Cryptographic processor
   type CRYP_Peripheral is record
      --  control register
      CR         : aliased CR_Register;
      --  status register
      SR         : aliased SR_Register;
      --  data input register
      DIN        : aliased STM32F746.UInt32;
      --  data output register
      DOUT       : aliased STM32F746.UInt32;
      --  DMA control register
      DMACR      : aliased DMACR_Register;
      --  interrupt mask set/clear register
      IMSCR      : aliased IMSCR_Register;
      --  raw interrupt status register
      RISR       : aliased RISR_Register;
      --  masked interrupt status register
      MISR       : aliased MISR_Register;
      --  key registers
      K0LR       : aliased K0LR_Register;
      --  key registers
      K0RR       : aliased K0RR_Register;
      --  key registers
      K1LR       : aliased K1LR_Register;
      --  key registers
      K1RR       : aliased K1RR_Register;
      --  key registers
      K2LR       : aliased K2LR_Register;
      --  key registers
      K2RR       : aliased K2RR_Register;
      --  key registers
      K3LR       : aliased K3LR_Register;
      --  key registers
      K3RR       : aliased K3RR_Register;
      --  initialization vector registers
      IV0LR      : aliased IV0LR_Register;
      --  initialization vector registers
      IV0RR      : aliased IV0RR_Register;
      --  initialization vector registers
      IV1LR      : aliased IV1LR_Register;
      --  initialization vector registers
      IV1RR      : aliased IV1RR_Register;
      --  context swap register
      CSGCMCCM0R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM1R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM2R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM3R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM4R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM5R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM6R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCMCCM7R : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM0R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM1R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM2R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM3R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM4R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM5R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM6R    : aliased STM32F746.UInt32;
      --  context swap register
      CSGCM7R    : aliased STM32F746.UInt32;
   end record
     with Volatile;

   for CRYP_Peripheral use record
      CR         at 16#0# range 0 .. 31;
      SR         at 16#4# range 0 .. 31;
      DIN        at 16#8# range 0 .. 31;
      DOUT       at 16#C# range 0 .. 31;
      DMACR      at 16#10# range 0 .. 31;
      IMSCR      at 16#14# range 0 .. 31;
      RISR       at 16#18# range 0 .. 31;
      MISR       at 16#1C# range 0 .. 31;
      K0LR       at 16#20# range 0 .. 31;
      K0RR       at 16#24# range 0 .. 31;
      K1LR       at 16#28# range 0 .. 31;
      K1RR       at 16#2C# range 0 .. 31;
      K2LR       at 16#30# range 0 .. 31;
      K2RR       at 16#34# range 0 .. 31;
      K3LR       at 16#38# range 0 .. 31;
      K3RR       at 16#3C# range 0 .. 31;
      IV0LR      at 16#40# range 0 .. 31;
      IV0RR      at 16#44# range 0 .. 31;
      IV1LR      at 16#48# range 0 .. 31;
      IV1RR      at 16#4C# range 0 .. 31;
      CSGCMCCM0R at 16#50# range 0 .. 31;
      CSGCMCCM1R at 16#54# range 0 .. 31;
      CSGCMCCM2R at 16#58# range 0 .. 31;
      CSGCMCCM3R at 16#5C# range 0 .. 31;
      CSGCMCCM4R at 16#60# range 0 .. 31;
      CSGCMCCM5R at 16#64# range 0 .. 31;
      CSGCMCCM6R at 16#68# range 0 .. 31;
      CSGCMCCM7R at 16#6C# range 0 .. 31;
      CSGCM0R    at 16#70# range 0 .. 31;
      CSGCM1R    at 16#74# range 0 .. 31;
      CSGCM2R    at 16#78# range 0 .. 31;
      CSGCM3R    at 16#7C# range 0 .. 31;
      CSGCM4R    at 16#80# range 0 .. 31;
      CSGCM5R    at 16#84# range 0 .. 31;
      CSGCM6R    at 16#88# range 0 .. 31;
      CSGCM7R    at 16#8C# range 0 .. 31;
   end record;

   --  Cryptographic processor
   CRYP_Periph : aliased CRYP_Peripheral
     with Import, Address => CRYP_Base;

end STM32F746.CRYP;

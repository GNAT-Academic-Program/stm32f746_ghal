pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F746.svd

pragma Restrictions (No_Elaboration_Code);

with System;

package STM32F746.SPDIF_RX is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CR_SPDIFEN_Field is STM32F746.UInt2;
   subtype CR_RXDMAEN_Field is STM32F746.Bit;
   subtype CR_RXSTEO_Field is STM32F746.Bit;
   subtype CR_DRFMT_Field is STM32F746.UInt2;
   subtype CR_PMSK_Field is STM32F746.Bit;
   subtype CR_VMSK_Field is STM32F746.Bit;
   subtype CR_CUMSK_Field is STM32F746.Bit;
   subtype CR_PTMSK_Field is STM32F746.Bit;
   subtype CR_CBDMAEN_Field is STM32F746.Bit;
   subtype CR_CHSEL_Field is STM32F746.Bit;
   subtype CR_NBTR_Field is STM32F746.UInt2;
   subtype CR_WFA_Field is STM32F746.Bit;
   subtype CR_INSEL_Field is STM32F746.UInt3;

   --  Control register
   type CR_Register is record
      --  Peripheral Block Enable
      SPDIFEN        : CR_SPDIFEN_Field := 16#0#;
      --  Receiver DMA ENable for data flow
      RXDMAEN        : CR_RXDMAEN_Field := 16#0#;
      --  STerEO Mode
      RXSTEO         : CR_RXSTEO_Field := 16#0#;
      --  RX Data format
      DRFMT          : CR_DRFMT_Field := 16#0#;
      --  Mask Parity error bit
      PMSK           : CR_PMSK_Field := 16#0#;
      --  Mask of Validity bit
      VMSK           : CR_VMSK_Field := 16#0#;
      --  Mask of channel status and user bits
      CUMSK          : CR_CUMSK_Field := 16#0#;
      --  Mask of Preamble Type bits
      PTMSK          : CR_PTMSK_Field := 16#0#;
      --  Control Buffer DMA ENable for control flow
      CBDMAEN        : CR_CBDMAEN_Field := 16#0#;
      --  Channel Selection
      CHSEL          : CR_CHSEL_Field := 16#0#;
      --  Maximum allowed re-tries during synchronization phase
      NBTR           : CR_NBTR_Field := 16#0#;
      --  Wait For Activity
      WFA            : CR_WFA_Field := 16#0#;
      --  unspecified
      Reserved_15_15 : STM32F746.Bit := 16#0#;
      --  input selection
      INSEL          : CR_INSEL_Field := 16#0#;
      --  unspecified
      Reserved_19_31 : STM32F746.UInt13 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR_Register use record
      SPDIFEN        at 0 range 0 .. 1;
      RXDMAEN        at 0 range 2 .. 2;
      RXSTEO         at 0 range 3 .. 3;
      DRFMT          at 0 range 4 .. 5;
      PMSK           at 0 range 6 .. 6;
      VMSK           at 0 range 7 .. 7;
      CUMSK          at 0 range 8 .. 8;
      PTMSK          at 0 range 9 .. 9;
      CBDMAEN        at 0 range 10 .. 10;
      CHSEL          at 0 range 11 .. 11;
      NBTR           at 0 range 12 .. 13;
      WFA            at 0 range 14 .. 14;
      Reserved_15_15 at 0 range 15 .. 15;
      INSEL          at 0 range 16 .. 18;
      Reserved_19_31 at 0 range 19 .. 31;
   end record;

   subtype IMR_RXNEIE_Field is STM32F746.Bit;
   subtype IMR_CSRNEIE_Field is STM32F746.Bit;
   subtype IMR_PERRIE_Field is STM32F746.Bit;
   subtype IMR_OVRIE_Field is STM32F746.Bit;
   subtype IMR_SBLKIE_Field is STM32F746.Bit;
   subtype IMR_SYNCDIE_Field is STM32F746.Bit;
   subtype IMR_IFEIE_Field is STM32F746.Bit;

   --  Interrupt mask register
   type IMR_Register is record
      --  RXNE interrupt enable
      RXNEIE        : IMR_RXNEIE_Field := 16#0#;
      --  Control Buffer Ready Interrupt Enable
      CSRNEIE       : IMR_CSRNEIE_Field := 16#0#;
      --  Parity error interrupt enable
      PERRIE        : IMR_PERRIE_Field := 16#0#;
      --  Overrun error Interrupt Enable
      OVRIE         : IMR_OVRIE_Field := 16#0#;
      --  Synchronization Block Detected Interrupt Enable
      SBLKIE        : IMR_SBLKIE_Field := 16#0#;
      --  Synchronization Done
      SYNCDIE       : IMR_SYNCDIE_Field := 16#0#;
      --  Serial Interface Error Interrupt Enable
      IFEIE         : IMR_IFEIE_Field := 16#0#;
      --  unspecified
      Reserved_7_31 : STM32F746.UInt25 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IMR_Register use record
      RXNEIE        at 0 range 0 .. 0;
      CSRNEIE       at 0 range 1 .. 1;
      PERRIE        at 0 range 2 .. 2;
      OVRIE         at 0 range 3 .. 3;
      SBLKIE        at 0 range 4 .. 4;
      SYNCDIE       at 0 range 5 .. 5;
      IFEIE         at 0 range 6 .. 6;
      Reserved_7_31 at 0 range 7 .. 31;
   end record;

   subtype SR_RXNE_Field is STM32F746.Bit;
   subtype SR_CSRNE_Field is STM32F746.Bit;
   subtype SR_PERR_Field is STM32F746.Bit;
   subtype SR_OVR_Field is STM32F746.Bit;
   subtype SR_SBD_Field is STM32F746.Bit;
   subtype SR_SYNCD_Field is STM32F746.Bit;
   subtype SR_FERR_Field is STM32F746.Bit;
   subtype SR_SERR_Field is STM32F746.Bit;
   subtype SR_TERR_Field is STM32F746.Bit;
   subtype SR_WIDTH5_Field is STM32F746.UInt15;

   --  Status register
   type SR_Register is record
      --  Read-only. Read data register not empty
      RXNE           : SR_RXNE_Field;
      --  Read-only. Control Buffer register is not empty
      CSRNE          : SR_CSRNE_Field;
      --  Read-only. Parity error
      PERR           : SR_PERR_Field;
      --  Read-only. Overrun error
      OVR            : SR_OVR_Field;
      --  Read-only. Synchronization Block Detected
      SBD            : SR_SBD_Field;
      --  Read-only. Synchronization Done
      SYNCD          : SR_SYNCD_Field;
      --  Read-only. Framing error
      FERR           : SR_FERR_Field;
      --  Read-only. Synchronization error
      SERR           : SR_SERR_Field;
      --  Read-only. Time-out error
      TERR           : SR_TERR_Field;
      --  unspecified
      Reserved_9_15  : STM32F746.UInt7;
      --  Read-only. Duration of 5 symbols counted with SPDIF_CLK
      WIDTH5         : SR_WIDTH5_Field;
      --  unspecified
      Reserved_31_31 : STM32F746.Bit;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      RXNE           at 0 range 0 .. 0;
      CSRNE          at 0 range 1 .. 1;
      PERR           at 0 range 2 .. 2;
      OVR            at 0 range 3 .. 3;
      SBD            at 0 range 4 .. 4;
      SYNCD          at 0 range 5 .. 5;
      FERR           at 0 range 6 .. 6;
      SERR           at 0 range 7 .. 7;
      TERR           at 0 range 8 .. 8;
      Reserved_9_15  at 0 range 9 .. 15;
      WIDTH5         at 0 range 16 .. 30;
      Reserved_31_31 at 0 range 31 .. 31;
   end record;

   subtype IFCR_PERRCF_Field is STM32F746.Bit;
   subtype IFCR_OVRCF_Field is STM32F746.Bit;
   subtype IFCR_SBDCF_Field is STM32F746.Bit;
   subtype IFCR_SYNCDCF_Field is STM32F746.Bit;

   --  Interrupt Flag Clear register
   type IFCR_Register is record
      --  unspecified
      Reserved_0_1  : STM32F746.UInt2 := 16#0#;
      --  Write-only. Clears the Parity error flag
      PERRCF        : IFCR_PERRCF_Field := 16#0#;
      --  Write-only. Clears the Overrun error flag
      OVRCF         : IFCR_OVRCF_Field := 16#0#;
      --  Write-only. Clears the Synchronization Block Detected flag
      SBDCF         : IFCR_SBDCF_Field := 16#0#;
      --  Write-only. Clears the Synchronization Done flag
      SYNCDCF       : IFCR_SYNCDCF_Field := 16#0#;
      --  unspecified
      Reserved_6_31 : STM32F746.UInt26 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for IFCR_Register use record
      Reserved_0_1  at 0 range 0 .. 1;
      PERRCF        at 0 range 2 .. 2;
      OVRCF         at 0 range 3 .. 3;
      SBDCF         at 0 range 4 .. 4;
      SYNCDCF       at 0 range 5 .. 5;
      Reserved_6_31 at 0 range 6 .. 31;
   end record;

   subtype DR_DR_Field is STM32F746.UInt24;
   subtype DR_PE_Field is STM32F746.Bit;
   subtype DR_V_Field is STM32F746.Bit;
   subtype DR_U_Field is STM32F746.Bit;
   subtype DR_C_Field is STM32F746.Bit;
   subtype DR_PT_Field is STM32F746.UInt2;

   --  Data input register
   type DR_Register is record
      --  Read-only. Parity Error bit
      DR             : DR_DR_Field;
      --  Read-only. Parity Error bit
      PE             : DR_PE_Field;
      --  Read-only. Validity bit
      V              : DR_V_Field;
      --  Read-only. User bit
      U              : DR_U_Field;
      --  Read-only. Channel Status bit
      C              : DR_C_Field;
      --  Read-only. Preamble Type
      PT             : DR_PT_Field;
      --  unspecified
      Reserved_30_31 : STM32F746.UInt2;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DR_Register use record
      DR             at 0 range 0 .. 23;
      PE             at 0 range 24 .. 24;
      V              at 0 range 25 .. 25;
      U              at 0 range 26 .. 26;
      C              at 0 range 27 .. 27;
      PT             at 0 range 28 .. 29;
      Reserved_30_31 at 0 range 30 .. 31;
   end record;

   subtype CSR_USR_Field is STM32F746.UInt16;
   subtype CSR_CS_Field is STM32F746.Byte;
   subtype CSR_SOB_Field is STM32F746.Bit;

   --  Channel Status register
   type CSR_Register is record
      --  Read-only. User data information
      USR            : CSR_USR_Field;
      --  Read-only. Channel A status information
      CS             : CSR_CS_Field;
      --  Read-only. Start Of Block
      SOB            : CSR_SOB_Field;
      --  unspecified
      Reserved_25_31 : STM32F746.UInt7;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CSR_Register use record
      USR            at 0 range 0 .. 15;
      CS             at 0 range 16 .. 23;
      SOB            at 0 range 24 .. 24;
      Reserved_25_31 at 0 range 25 .. 31;
   end record;

   subtype DIR_THI_Field is STM32F746.UInt13;
   subtype DIR_TLO_Field is STM32F746.UInt13;

   --  Debug Information register
   type DIR_Register is record
      --  Read-only. Threshold HIGH
      THI            : DIR_THI_Field;
      --  unspecified
      Reserved_13_15 : STM32F746.UInt3;
      --  Read-only. Threshold LOW
      TLO            : DIR_TLO_Field;
      --  unspecified
      Reserved_29_31 : STM32F746.UInt3;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DIR_Register use record
      THI            at 0 range 0 .. 12;
      Reserved_13_15 at 0 range 13 .. 15;
      TLO            at 0 range 16 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Receiver Interface
   type SPDIF_RX_Peripheral is record
      --  Control register
      CR   : aliased CR_Register;
      --  Interrupt mask register
      IMR  : aliased IMR_Register;
      --  Status register
      SR   : aliased SR_Register;
      --  Interrupt Flag Clear register
      IFCR : aliased IFCR_Register;
      --  Data input register
      DR   : aliased DR_Register;
      --  Channel Status register
      CSR  : aliased CSR_Register;
      --  Debug Information register
      DIR  : aliased DIR_Register;
   end record
     with Volatile;

   for SPDIF_RX_Peripheral use record
      CR   at 16#0# range 0 .. 31;
      IMR  at 16#4# range 0 .. 31;
      SR   at 16#8# range 0 .. 31;
      IFCR at 16#C# range 0 .. 31;
      DR   at 16#10# range 0 .. 31;
      CSR  at 16#14# range 0 .. 31;
      DIR  at 16#18# range 0 .. 31;
   end record;

   --  Receiver Interface
   SPDIF_RX_Periph : aliased SPDIF_RX_Peripheral
     with Import, Address => SPDIF_RX_Base;

end STM32F746.SPDIF_RX;

with STM32F746_I2C_Port;
with MT;

package body STM32F746_I2C with SPARK_Mode => On is

   --  Per-instance wall. Each STM32F746_I2C instantiation (one per bus) gets
   --  its own Port instance bound to its Base address.
   package Port is new STM32F746_I2C_Port (Base => Base);

   Timeout_Loops : constant := 1_000_000;

   --  Fault halt. Under No_Exception_Propagation (the light-tasking runtime
   --  sets that restriction) a raise does NOT propagate to the caller -- it
   --  routes to the Last Chance Handler and halts. No_Return states exactly
   --  that, so SPARK treats every guard-failure path as unreachable and proves
   --  it trivially. The body is SPARK_Mode => Off: the raise is the one
   --  runtime-coupled act, kept behind the wall like the register pokes.
   procedure Fault (Why : String) with No_Return;

   procedure Fault (Why : String) with SPARK_Mode => Off is
   begin
      raise I2C_Types.Bus_Fault with Why;
   end Fault;

   ---------------------------------------------------------------------------
   --  TIMINGR selection -- total, pure, provable (no raise here; the unknown
   --  clock becomes Valid => False and Init faults at the boundary instead).
   ---------------------------------------------------------------------------

   type Timing is record
      PRESC, SCLDEL, SDADEL : MT.UInt4;
      SCLH, SCLL            : MT.UInt8;
   end record;

   type Timing_Result (Valid : Boolean := False) is record
      case Valid is
         when True  => T : Timing;
         when False => null;
      end case;
   end record;

   function Timing_For (Kernel_Hz : Natural;
                        Speed     : I2C_Types.Bus_Speed_Kind)
                        return Timing_Result is
   begin
      --  54 MHz kernel (SYSCLK 216 MHz, APB1 = /4). CubeMX-derived.
      if Kernel_Hz = 54_000_000 then
         case Speed is
            when I2C_Types.Standard_Mode =>      --  100 kHz
               return (Valid => True, T =>
                 (PRESC => 11, SCLDEL => 4, SDADEL => 0,
                  SCLH => 16#13#, SCLL => 16#1B#));
            when I2C_Types.Fast_Mode =>          --  400 kHz
               return (Valid => True, T =>
                 (PRESC => 5, SCLDEL => 3, SDADEL => 0,
                  SCLH => 16#09#, SCLL => 16#13#));
            when I2C_Types.Fast_Mode_Plus =>     --  1 MHz
               return (Valid => True, T =>
                 (PRESC => 5, SCLDEL => 1, SDADEL => 0,
                  SCLH => 16#02#, SCLL => 16#04#));
         end case;
      else
         return (Valid => False);
      end if;
   end Timing_For;

   ---------------------------------------------------------------------------

   function Make_Device return Device is
   begin
      return Dev : Device;   --  null record
   end Make_Device;

   ---------------------------------------------------------------------------

   procedure Init (Dev : in out Device; Cfg : I2C_Types.I2C_Config) is
      pragma Unreferenced (Dev);
      R : constant Timing_Result := Timing_For (Get_Clock, Cfg.Speed);
   begin
      if not R.Valid then
         Fault ("Init: no TIMINGR row for this kernel clock");
      end if;

      RCC_Enable;
      RCC_Reset;

      Port.Set_PE (On => False);
      Port.Program_Timing (PRESC  => R.T.PRESC, SCLDEL => R.T.SCLDEL,
                           SDADEL => R.T.SDADEL,
                           SCLH   => R.T.SCLH, SCLL => R.T.SCLL);
      Port.Clear_Status;
      Port.Set_PE (On => True);
   end Init;

   procedure Enable (Dev : in out Device) is
      pragma Unreferenced (Dev);
   begin
      Port.Set_PE (On => True);
   end Enable;

   procedure Disable (Dev : in out Device) is
      pragma Unreferenced (Dev);
   begin
      Port.Set_PE (On => False);
   end Disable;

   procedure Reset (Dev : in out Device) is
      pragma Unreferenced (Dev);
   begin
      RCC_Reset;
   end Reset;

   procedure Recover (Dev : in out Device) is
   begin
      Disable (Dev);
      Reset   (Dev);
      Enable  (Dev);
   end Recover;

   ---------------------------------------------------------------------------

   procedure Check_Errors (Op : String) is
   begin
      if Port.Nacked then
         Fault (Op & ": NACK");
      elsif Port.Berr then
         Fault (Op & ": bus error");
      elsif Port.Arlo then
         Fault (Op & ": arbitration lost");
      elsif Port.Ovr then
         Fault (Op & ": overrun");
      end if;
   end Check_Errors;

   procedure Probe (Dev    : in out Device;
                    Target : I2C_Types.I2C_Address;
                    Result : out I2C_Types.Ack_State) is
      pragma Unreferenced (Dev);
      Done : Boolean := False;
   begin
      Result := I2C_Types.Nak;

      if not Port.PE_On then Port.Recover_Ctrl; end if;
      if not Port.PE_On then return; end if;
      if Port.Busy       then Port.Recover_Ctrl; end if;
      if Port.Busy       then return; end if;

      Port.Clear_Status;

      --  0-byte write to probe the address.
      Port.Start (Sadd     => MT.UInt10 (Natural (Target) * 2),
                  Read     => False,
                  NBytes   => 0,
                  Auto_End => True);

      for Count in 1 .. Timeout_Loops loop
         if Port.Stopped or else Port.Nacked then
            Done := True;
            exit;
         end if;
      end loop;
      pragma Unreferenced (Done);

      if not Port.Nacked and then Port.Stopped then
         Result := I2C_Types.Ack;
      end if;

      Port.Clear_Status;
   end Probe;

   ---------------------------------------------------------------------------
   --  Transaction begin
   --  Provable conversions:
   --    MT.UInt8  (Length)             in range BECAUSE of the 1 .. 255 guard
   --    MT.UInt10 (Natural (Target)*2) in 0 .. 1023 BECAUSE I2C_Address is
   --                                   mod 2**7 (max 127*2 = 254). Widen the
   --                                   address type and gnatprove flags 2046.
   ---------------------------------------------------------------------------

   procedure Begin_Write (Dev    : in out Device;
                          Target : I2C_Types.I2C_Address;
                          Length : Natural;
                          Stop   : Boolean) is
      pragma Unreferenced (Dev);
   begin
      if Length not in 1 .. 255 then
         Fault ("Begin_Write: invalid length");
      end if;

      if not Port.PE_On then Port.Recover_Ctrl; end if;
      if not Port.PE_On then
         Fault ("Begin_Write: peripheral not enabled");
      end if;

      if Port.Busy then Port.Recover_Ctrl; end if;
      if Port.Busy then
         Fault ("Begin_Write: bus busy");
      end if;

      Port.Clear_Status;

      Port.Start (Sadd     => MT.UInt10 (Natural (Target) * 2),
                  Read     => False,
                  NBytes   => MT.UInt8 (Length),
                  Auto_End => Stop);
   end Begin_Write;

   procedure Begin_Read (Dev    : in out Device;
                         Target : I2C_Types.I2C_Address;
                         Length : Natural;
                         Stop   : Boolean) is
      pragma Unreferenced (Dev);
   begin
      if Length not in 1 .. 255 then
         Fault ("Begin_Read: invalid length");
      end if;

      if not Port.PE_On then Port.Recover_Ctrl; end if;
      if not Port.PE_On then
         Fault ("Begin_Read: peripheral not enabled");
      end if;

      --  Repeated-START after a Write phase legitimately leaves BUSY=1; trust
      --  the caller's sequencing and don't recover here.

      Port.Clear_Status;

      Port.Start (Sadd     => MT.UInt10 (Natural (Target) * 2),
                  Read     => True,
                  NBytes   => MT.UInt8 (Length),
                  Auto_End => Stop);
   end Begin_Read;

   ---------------------------------------------------------------------------
   --  Per-byte send/recv. The old while-loops are now bounded FOR loops:
   --  SPARK proves termination with no loop variant, and a flag that never
   --  sets becomes a defined timeout (Bus_Fault) rather than a hang.
   ---------------------------------------------------------------------------

   procedure Send (Dev : in out Device; B : Storage_Element) is
      pragma Unreferenced (Dev);
      Ready : Boolean := False;
   begin
      for Count in 1 .. Timeout_Loops loop
         if Port.TXIS then
            Ready := True;
            exit;
         end if;
         exit when Port.Nacked or else Port.Berr
                or else Port.Arlo or else Port.Ovr;
      end loop;

      Check_Errors ("Send");

      if not Ready then
         Fault ("Send: timeout waiting for TXIS");
      end if;

      Port.Put (B);
   end Send;

   procedure Recv (Dev : in out Device;
                   B   : out Storage_Element;
                   Ack : Boolean) is
      pragma Unreferenced (Dev);
      pragma Unreferenced (Ack);
      --  ACK/NACK is driven by AUTOEND/NBYTES in Begin_Read; no per-byte
      --  control needed in v2 I2C.
      Ready : Boolean := False;
   begin
      B := 0;

      for Count in 1 .. Timeout_Loops loop
         if Port.RXNE then
            Ready := True;
            exit;
         end if;
         exit when Port.Nacked or else Port.Berr
                or else Port.Arlo or else Port.Ovr;
      end loop;

      Check_Errors ("Recv");

      if not Ready then
         Fault ("Recv: timeout waiting for RXNE");
      end if;

      Port.Get (B);
   end Recv;

end STM32F746_I2C;

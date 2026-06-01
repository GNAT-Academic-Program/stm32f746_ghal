# STM32F746 GHAL

Generic Hardware Abstraction Layer (GHAL) for STM32F746 microcontrollers.

## Overview

This crate provides a hardware abstraction layer for STM32F746 family microcontrollers, offering generic interfaces for common peripherals:

- **USART** - Universal Synchronous/Asynchronous Receiver/Transmitter
- **SPI** - Serial Peripheral Interface
- **I2C** - Inter-Integrated Circuit
- **GPIO** - General Purpose Input/Output

## Features

- Generic, reusable peripheral drivers
- Support for multiple STM32F746 variants through Alire configuration
- Clean separation between hardware-specific and application code
- Compatible with the GNAT-Academic-Program ecosystem

## Usage

Add this crate as a dependency in your `alire.toml`:

```toml
[[depends-on]]
stm32f746 = "*"
```

## Supported Boards

- STM32F746G-DISCO (Discovery board)
- Other STM32F746 variants (configurable)

## License

MIT OR Apache-2.0 WITH LLVM-exception

## Contributing

Part of the GNAT Academic Program initiative for embedded Ada development.

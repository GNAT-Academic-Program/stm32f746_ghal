# stm32f746

STM32F746 Hardware Abstraction Layer for bare-metal Ada applications.

## Overview

`stm32f746` provides hardware-specific implementations of generic peripheral interfaces for the STM32F746 microcontroller family. It instantiates generic packages (GPIO, SPI, I2C, USART) with STM32F746-specific drivers, providing a vendor-neutral API at the MCU level.

## Features

- STM32F746-specific peripheral drivers
- SVD-generated register definitions
- Clock tree configuration
- Generic interface instantiations for:
  - GPIO (General Purpose Input/Output)
  - SPI (Serial Peripheral Interface)
  - I2C (Inter-Integrated Circuit)
  - USART (Universal Synchronous/Asynchronous Receiver/Transmitter)

## Architecture

This crate sits between generic peripheral interfaces and board support packages:

```
Application
    ↓
Board Package (stm32f746g_disco)
    ↓
MCU Package (stm32f746) ← This crate
    ↓
Generic Interfaces (gpio_generic, spi_generic, i2c_generic, usart_generic)
```

## Usage

Typically used as a dependency of board support packages. For direct use:

```ada
with Gpio;
with STM32F746_GPIO;

Led_Pin : Gpio.Pin := STM32F746_GPIO.Make_Pin (STM32F746_GPIO.I, 1);
```

## Integration

Add to your `alire.toml`:

```toml
[[depends-on]]
stm32f746 = "^0.1.0"
```

## Dependencies

- `gpio_generic` - Generic GPIO interface
- `spi_generic` - Generic SPI interface
- `i2c_generic` - Generic I2C interface
- `usart_generic` - Generic USART interface
- `debug_generic` - Generic debug output
- `machine_types` - Machine-level types
- `light_tasking_stm32f746` - Lightweight Ada runtime

## License

MIT OR Apache-2.0 WITH LLVM-exception

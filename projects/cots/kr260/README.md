<!-- no_build_example -->

# COTS/KR260 HDL Project

## Supported boards

- [KR260 Robotics Starter Kit](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit.html)

## Supported devices

- [XCK26-SFVC784-2LV-C](https://www.xilinx.com/products/som/kria/k26c-commercial.html) (Kria K26 SOM)

## Board configuration

This is a minimal COTS (Common Off-The-Shelf) design for the KR260 Robotics Starter Kit 
that provides just the processor system configured to boot Linux.

### Features

- Kria K26 SOM (Zynq UltraScale+ MPSoC)
- DDR4 memory (4GB)
- SD card interface
- Dual Ethernet (GEM0, GEM1)
- USB 3.0
- UART
- GPIO via PS EMIO (95 pins available)
- SPI interface via EMIO
- System ID for design identification

### Hardware Overview

The **KR260** is a robotics-focused starter kit featuring:
- Kria K26 System-on-Module (XCZU5EV)
- Industrial-grade temperature support
- Rich I/O connectivity for robotics applications
- Motor control interfaces
- Multiple camera/sensor interfaces

### GPIO Mapping

| GPIO Bits | Function |
|-----------|----------|
| [94:0]    | PS EMIO GPIO - available for custom applications |

**Note:** GPIO is accessed through the PS EMIO interface. The KR260 carrier board
manages pin routing internally. Users should refer to the KR260 documentation for
specific connector pinouts.

### Peripherals

- **Ethernet**: Dual GigE (GEM0, GEM1) for robotics networking
- **USB**: USB 3.0 host/device
- **SD Card**: Boot and storage
- **UART**: Debug console
- **SPI**: Available via EMIO for custom peripherals

## Building the project

Build the project as follows:

```bash
make
```

The built bitstream will be available at:
```
cots_kr260.runs/impl_1/system_top.bit
```

or in the .sdk directory after the build completes:
```
cots_kr260.sdk/system_top.xsa
```

## Building from repository root

```bash
make cots.kr260
```

## Resources

- [KR260 Robotics Starter Kit Product Page](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit.html)
- [Kria K26 SOM Data Sheet](https://www.xilinx.com/support/documentation/data_sheets/ds987-k26-som.pdf)
- [KR260 Getting Started Guide](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit/kr260-getting-started.html)
- [Zynq UltraScale+ Device Technical Reference Manual (UG1085)](https://www.xilinx.com/support/documentation/user_guides/ug1085-zynq-ultrascale-trm.pdf)

## Notes

- This design uses the commercial-grade K26C SOM variant (XCK26-SFVC784-2LV-C)
- The KR260 shares the same SOM as the KV260 but with a robotics-focused carrier
- For robotics applications, consider extending this design with motor control or sensor interfaces

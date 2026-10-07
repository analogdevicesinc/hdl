<!-- no_build_example -->

# COTS/ZED HDL Project

## Supported boards

- [Zed Board](https://www.avnet.com/wps/portal/us/products/avnet-boards/avnet-board-families/zedboard/)

## Supported devices

- [XC7Z020-1CLG484C](https://www.xilinx.com/products/silicon-devices/soc/zynq-7000.html)

## Board configuration

This is a minimal COTS (Common Off-The-Shelf) design for the Zed board that 
provides just the processor system configured to boot Linux.

### Features

- Zynq-7000 SoC processing system (XC7Z020)
- DDR3 memory (512MB)
- SD card interface
- Ethernet (GEM0)
- USB 2.0 OTG
- UART
- HDMI output
- Audio I2S and SPDIF
- GPIO mapped to FMC connector and expansion pins
- I2C interfaces
- System ID for design identification

### On-Board Peripherals

The Zed board base system includes all standard peripherals:
- **HDMI output** for video display
- **Audio** codec with I2S and SPDIF
- **I2C** for EEPROM and peripheral control
- **GPIO** available on FMC LPC connector (gpio_bd[31:0])
- **LEDs, buttons, and switches** controlled via PS MIO pins

### GPIO Mapping

| GPIO Bits  | Function |
|------------|----------|
| [31:0]     | FMC LPC connector / General expansion |
| [63:32]    | Internal (loopback) |

## Building the project

Build the project as follows:

```
make
```

The built bitstream will be available at:
```
cots_zed.runs/impl_1/system_top.bit
```

or in the .sdk directory after the build completes:
```
cots_zed.sdk/system_top.xsa
```

## Resources

- [Zed Board Hardware User Guide](https://www.avnet.com/wps/wcm/connect/onesite/9e3e0c0d-8e2e-4a4e-9b38-e973b4a8fa1e/5279-UG-ZEDBOARD-HW-V2.2.pdf)
- [Zynq-7000 Technical Reference Manual (UG585)](https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf)

<!-- no_build_example -->

# COTS/MICROZED HDL Project

## Supported boards

- [Microzed](https://www.avnet.com/wps/portal/us/products/avnet-boards/avnet-board-families/microzed/)

## Supported devices

- [XC7Z010-1CLG400C](https://www.xilinx.com/products/silicon-devices/soc/zynq-7000.html)
- [XC7Z020-1CLG400C](https://www.xilinx.com/products/silicon-devices/soc/zynq-7000.html)

## Board configuration

This is a minimal COTS (Common Off-The-Shelf) design for the Microzed board that 
provides just the processor system configured to boot Linux.

### Features

- Zynq-7000 SoC processing system
- DDR3 memory (1GB)
- SD card interface
- Ethernet (GEM0)
- USB 2.0 OTG
- UART
- GPIO mapped to expansion header pins for LEDs and buttons
- System ID for design identification

### GPIO Mapping

The Microzed does not have on-board LEDs or buttons. GPIO signals are available
internally but not routed to external pins in this minimal COTS design.

| GPIO Bits | Function |
|-----------|----------|
| [63:0]    | Internal (loopback) |

**Note:** Users can modify `system_top.v` and `system_constr.xdc` to route GPIO
signals to the expansion headers (JX1, JX2, JX3) as needed for their specific hardware.

### Expansion Headers Available

- **JX1**: 32-pin expansion header
- **JX2**: 32-pin expansion header  
- **JX3**: 16-pin expansion header

All expansion pins can be configured for GPIO, SPI, I2C, or other functions based
on user requirements.

## Building the project

Build the project as follows:

```
make
```

The built bitstream will be available at:
```
cots_microzed.runs/impl_1/system_top.bit
```

or in the .sdk directory after the build completes:
```
cots_microzed.sdk/system_top.bit
```

## Resources

- [Microzed Hardware User Guide](https://www.avnet.com/wps/wcm/connect/onesite/f8a8e0e3-2a25-4f2e-97c1-f41bb24dbb46/MicroZed_HW_UG_v1_7.pdf)
- [Zynq-7000 Technical Reference Manual (UG585)](https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf)

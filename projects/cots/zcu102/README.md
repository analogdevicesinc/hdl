<!-- no_build_example -->

# COTS/ZCU102 HDL Project

## Supported boards

- [ZCU102 Rev 1.0](https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html)

## Supported devices

- [XCZU9EG-2FFVB1156E](https://www.xilinx.com/products/silicon-devices/soc/zynq-ultrascale-mpsoc.html)

## Board configuration

This is a minimal COTS (Common Off-The-Shelf) design for the ZCU102 board that 
provides just the processor system configured to boot Linux.

### Features

- Zynq UltraScale+ MPSoC processing system
- DDR4 memory (4GB)
- SD card interface
- Ethernet (GEM3)
- USB 3.0
- UART
- GPIO mapped to on-board LEDs, switches, and buttons
- System ID for design identification

### GPIO Mapping

| GPIO Bits | Function | Direction |
|-----------|----------|-----------|
| [7:0]     | LEDs (GPIO_LED_0 to GPIO_LED_7) | Output |
| [12:8]    | Switches and Buttons | Input |

### Switches and Buttons
- gpio_bd_i[0-3]: DIP switches SW19-SW16
- gpio_bd_i[4-8]: Directional switches (N, E, S, W, C)
- gpio_bd_i[9]: CPU_RESET button
- gpio_bd_i[10-12]: Push buttons GPIO_PB_2, GPIO_PB_1, GPIO_PB_0

## Building the project

Build the project as follows:

```
make
```

The built bitstream will be available at:
```
cots_zcu102.runs/impl_1/system_top.bit
```

or in the .sdk directory after the build completes:
```
cots_zcu102.sdk/system_top.bit
```

## Resources

- [ZCU102 Board User Guide (UG1182)](https://www.xilinx.com/support/documentation/boards_and_kits/zcu102/ug1182-zcu102-eval-bd.pdf)
- [Zynq UltraScale+ Device Technical Reference Manual (UG1085)](https://www.xilinx.com/support/documentation/user_guides/ug1085-zynq-ultrascale-trm.pdf)

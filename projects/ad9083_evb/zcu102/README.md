# AD9083_EVB/ZCU102 HDL Project

## Building the project

```
cd projects/ad9083_evb/zcu102
make
```

All of the RX/TX link modes can be found in the [AD9083 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9083.pdf). We offer support for only a few of them.

The overwritable parameters from the environment:

- [RX]_JESD_L - [RX] number of lanes per link
- [RX]_JESD_M - [RX] number of converters per link
- [RX]_JESD_S - [RX] number of samples per converter per frame

Corresponding device tree: [zynqmp-zcu102-rev10-ad9083-fmc-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9083-fmc-ebz.dts)
# FMCOMMS8/ZCU102 HDL Project

## Building the project

```
cd projects/fmcomms8/zcu102
make
```

All of the RX/TX link modes can be found in the [ADRV9009 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf). We offer support for only a few of them.

The overwritable parameters from the environment:

- [RX/TX/RX_OS]_JESD_M - [RX/TX/RX_OS] number of converters per link
- [RX/TX/RX_OS]_JESD_L - [RX/TX/RX_OS] number of lanes per link
- [RX/TX/RX_OS]_JESD_S - [RX/TX/RX_OS] number of samples per converter per frame

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9009-fmcomms8-jesd204-fsm.dts](https://github.com/analogdevicesinc/linux/tree/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9009-fmcomms8-jesd204-fsm.dts)
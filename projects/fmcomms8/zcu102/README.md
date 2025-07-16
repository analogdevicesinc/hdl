<!-- no_no_os -->

# FMCOMMS8/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/fmcomms8/zcu102
make
```

All of the RX/TX link modes can be found in the [ADRV9009 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- [RX/TX/RX_OS]_JESD_M - [RX/TX/RX_OS] number of converters per link
- [RX/TX/RX_OS]_JESD_L - [RX/TX/RX_OS] number of lanes per link
- [RX/TX/RX_OS]_JESD_S - [RX/TX/RX_OS] number of samples per converter per frame

### Example configurations

#### Default configuration

The following command is equivalent to running `make` only:

```
make RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=8 \
TX_JESD_S=1 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=4 \
RX_OS_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9009-fmcomms8-jesd204-fsm.dts](https://github.com/analogdevicesinc/linux/tree/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9009-fmcomms8-jesd204-fsm.dts)

#### TX L=4, RX_OS M=8

```
make RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
RX_OS_JESD_M=8 \
RX_OS_JESD_L=4 \
RX_OS_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l4.dts)

#### TX L=2 M=4, RX L=2, RX_OS L=2

```
make RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
TX_JESD_M=4 \
TX_JESD_L=2 \
TX_JESD_S=1 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=2 \
RX_OS_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l2-rx-l2-orx-l2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l2-rx-l2-orx-l2.dts)

#### TX L=4, RX L=2, RX_OS L=2

```
make RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=2 \
RX_OS_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l4-rx-l2-orx-l2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9009-fmcomms8-tx-l4-rx-l2-orx-l2.dts)

# AD9082-FMCA-EBZ/ZCU102 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the ../../ad9081_fmca_ebz/zcu102/timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9082_fmca_ebz/zcu102
make
```

All of the RX/TX link modes can be found in the [AD9082 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

:warning: **Only JESD204B (8B10B) is supported for this carrier!**

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M: [RX/TX] number of converters per link
- [RX/TX]_JESD_L: [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP: [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS: [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_TPL_WIDTH: [RX/TX] transport layer data width

### Example configurations

#### JESD204B, TX mode 17, RX mode 18, subclass 1 (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=15 \
TX_LANE_RATE=15 \
RX_JESD_M=4 \
RX_JESD_L=8 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=8 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9082-m4-l8.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-m4-l8.dts)


#### JESD24C, TX mode 20, RX mode 19, subclass 1

```
make JESD_MODE=64B66B \
RX_LANE_RATE=11.88 \
TX_LANE_RATE=11.88 \
RX_JESD_M=1 \
RX_JESD_L=8 \
RX_JESD_S=4 \
RX_JESD_NP=16 \
TX_JESD_M=1 \
TX_JESD_L=8 \
TX_JESD_S=4 \
TX_JESD_NP=16
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9082-m1-l8.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-m1-l8.dts)

#### AD9082 single link, JESD204C, TX mode 22, RX mode 23

```
make JESD_MODE=64B66B \
RX_LANE_RATE=11.88 \
TX_LANE_RATE=11.88 \
RX_JESD_M=2 \
RX_JESD_L=2 \
RX_JESD_S=4 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=2 \
TX_JESD_L=2 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1
```

Corresponding device trees:

- with subclass 0: [zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23.dts)
- with subclass 1: [zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-sc1.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-sc1.dts)

#### AD9082 dual link, JESD204C, TX mode 22, RX mode 23, subclass 0

```
make JESD_MODE=64B66B \
RX_LANE_RATE=11.88 \
TX_LANE_RATE=11.88 \
RX_JESD_M=2 \
RX_JESD_L=2 \
RX_JESD_S=4 \
RX_JESD_NP=12 \
RX_NUM_LINKS=2 \
TX_JESD_M=2 \
TX_JESD_L=2 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=2
```

Corresponding device trees:

- [zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-dual.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-dual.dts)
- multi top: [zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-dual-multi-top.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode22-rxmode23-dual-multi-top.dts)

#### AD9082, JESD204C, TX mode 36, RX mode 28, subclass 1

```
make JESD_MODE=64B66B \
RX_LANE_RATE=11.88 \
TX_LANE_RATE=11.88 \
RX_JESD_M=2 \
RX_JESD_L=8 \
RX_JESD_S=8 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=2 \
TX_JESD_L=8 \
TX_JESD_S=8 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1
```

Corresponding device trees:

- [zynqmp-zcu102-rev10-ad9082-204c-txmode36-rxmode28.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode36-rxmode28.dts)
- with TPL width 6 octets: [zynqmp-zcu102-rev10-ad9082-204c-txmode36-rxmode28-tplw6.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9082-204c-txmode36-rxmode28-tplw6.dts)

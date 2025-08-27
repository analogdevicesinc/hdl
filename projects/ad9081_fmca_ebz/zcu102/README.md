<!-- no_no_os -->

# AD9081-FMCA-EBZ/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/zcu102
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
  - 64B66B - 64b66b link layer defined in JESD204C
- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M: [RX/TX] number of converters per link
- [RX/TX]_JESD_L: [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP: [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS: [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_TPL_WIDTH: [RX/TX] transport layer data width
- TDD_SUPPORT: enables external synchronization through TDD; if enabled, then SHARED_DEVCLK must be enabled as well
- SHARED_DEVCLK: if the device clock is shared among devices
- TDD_CHANNEL_CNT
- TDD_SYNC_WIDTH
- TDD_SYNC_INT
- TDD_SYNC_EXT
- TDD_SYNC_EXT_CDC: adds the CDC circuitry for the external sync signal

### Example configurations

#### JESD204B subclass 1, TX mode 17, RX mode 18, VCXO 100 MHz (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=4 \
TX_JESD_L=8 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10, VCXO 100 MHz

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-m8-l4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-m8-l4.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10, VCXO 122.88 MHz

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-m8-l4-vcxo122p88.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-m8-l4-vcxo122p88.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10, with TDD support

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TDD_SUPPORT=1 \
SHARED_DEVCLK=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-m8-l4-tdd.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-m8-l4-tdd.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10, on AD9081-FMCA-EBZ rev. C with 100 MHz VCXO, using QPLL for both ADXCVR instances

```
make JESD_MODE=8B10B \
RX_LANE_RATE=11.5 \
TX_LANE_RATE=11.5 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-m8-l4-qpllrx.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-m8-l4-qpllrx.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10, overlay

```
make JESD_MODE=8B10B \
RX_LANE_RATE=5.76 \
TX_LANE_RATE=5.76 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-m8-l4-overlay.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-m8-l4-overlay.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 4

```
make JESD_MODE=8B10B \
RX_LANE_RATE=2 \
TX_LANE_RATE=4 \
RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-204b-txmode9-rxmode4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-204b-txmode9-rxmode4.dts)

#### JESD204C subclass 1, TX mode 0, RX mode 1

```
make JESD_MODE=64B66B \
RX_LANE_RATE=5.98 \
TX_LANE_RATE=11.96 \
RX_JESD_M=8 \
RX_JESD_L=1 \
RX_JESD_S=1 \
RX_JESD_NP=12 \
TX_JESD_M=8 \
TX_JESD_L=1 \
TX_JESD_S=1 \
TX_JESD_NP=12
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-204c-txmode0-rxmode1.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-204c-txmode0-rxmode1.dts)

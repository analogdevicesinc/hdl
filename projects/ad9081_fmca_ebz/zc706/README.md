<!-- no_no_os -->

# AD9081-FMCA-EBZ/ZC706 HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/zc706
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

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

#### XCVR build parameters

- PLL_TYPE: The PLL used for driving the XCVR link [CPLL/QPLL]
- REF_CLK: Value of the reference clock [MHz]
- LANE_RATE: Value of lane rate [gbps]

#### Optional XCVR overrides

The following parameters allow configuring the RX transceiver independently from the TX path. If omitted, the RX path inherits the corresponding base parameter (PLL_TYPE, LANE_RATE, REF_CLK).

- XCVR_RX_PLL_TYPE - RX PLL type [CPLL/QPLL0/QPLL1]
- XCVR_RX_LANE_RATE - RX lane rate [gbps]
- XCVR_RX_REF_CLK - RX reference clock [MHz] (usually XCVR_RX_LANE_RATE/20 or XCVR_RX_LANE_RATE/40)

### Example configurations

#### JESD204B subclass 1, TX mode 9, RX mode 10 (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1 \
PLL_TYPE=QPLL \
REF_CLK=250 \
LANE_RATE=10
```

Corresponding device tree: [zynq-zc706-adv7511-ad9081.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-ad9081.dts)

#### JESD204B subclass 1, TX mode 4, RX mode 5

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=8 \
TX_JESD_L=2 \
TX_JESD_S=1 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1 \
PLL_TYPE=QPLL \
REF_CLK=250 \
LANE_RATE=10
```

Corresponding device tree: [zynq-zc706-adv7511-ad9081-np12.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-ad9081-np12.dts)

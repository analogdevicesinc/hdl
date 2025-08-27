<!-- no_no_os -->

# AD9081-FMCA-EBZ/VCK190 HDL Project

- VADJ with which it was tested in hardware: 1.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/vck190
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
  - 64B66B - 64b66b link layer defined in JESD204C
- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- REF_CLK_RATE: frequency of the reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
- [RX/TX]_JESD_M: [RX/TX] number of converters per link
- [RX/TX]_JESD_L: [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP: [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS: [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_KS_PER_CHANNEL: [RX/TX] number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

### Example configurations

#### JESD204C subclass 1, TX mode 24, RX mode 26 (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
REF_CLK_RATE=375 \
RX_JESD_M=8 \
RX_JESD_L=8 \
RX_JESD_S=2 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=8 \
TX_JESD_L=8 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64
```

Corresponding device tree: [versal-vck190-reva-ad9081.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/versal-vck190-reva-ad9081.dts)

#### JESD204C subclass 0, TX mode 22, RX mode 23

```
make JESD_MODE=64B66B \
RX_LANE_RATE=11.88 \
TX_LANE_RATE=11.88 \
REF_CLK_RATE=180 \
RX_JESD_M=2 \
RX_JESD_L=2 \
RX_JESD_S=2 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=2 \
TX_JESD_L=2 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1
```

Corresponding device tree: [versal-vck190-reva-ad9081-204c-txmode22-rxmode23.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/versal-vck190-reva-ad9081-204c-txmode22-rxmode23.dts)

#### JESD204C subclass 0, TX mode 23, RX mode 25

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
REF_CLK_RATE=375 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=2 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1
```

Corresponding device tree: [versal-vck190-reva-ad9081-204c-txmode23-rxmode25.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/versal-vck190-reva-ad9081-204c-txmode23-rxmode25.dts)

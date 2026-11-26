<!-- no_dts, no_no_os -->

# AD9081-FMCA-EBZ/A5E HDL Project

- VADJ with which it was tested in hardware: 1.2V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the system_constr.sdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/a5e
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
  - 64B66B - 64b66b link layer defined in JESD204C
- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE); RX2 uses the RX lane rate
- REF_CLK_RATE: frequency of the reference clock in MHz used in 64B66B mode (LANE_RATE/66) or 8B10B mode (LANE_RATE/40)
- DEVICE_CLK_RATE: frequency of the device clock in MHz, usually equal to REF_CLK_RATE
- [RX/RX2/TX]_JESD_M: [RX/RX2/TX] number of converters per link
- [RX/RX2/TX]_JESD_L: [RX/RX2/TX] number of lanes per link
- [RX/RX2/TX]_JESD_S: [RX/RX2/TX] number of samples per converter per frame
- [RX/RX2/TX]_JESD_NP: [RX/RX2/TX] number of bits per sample, 12 or 16
- [RX/RX2/TX]_NUM_LINKS: [RX/RX2/TX] number of links, which matches the number of MxFE devices
- [RX/RX2/TX]_KS_PER_CHANNEL: [RX/RX2/TX] number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=9.6 \
TX_LANE_RATE=9.6 \
REF_CLK_RATE=240 \
DEVICE_CLK_RATE=240 \
RX_JESD_M=2 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
RX2_JESD_M=2 \
RX2_JESD_L=2 \
RX2_JESD_S=1 \
RX2_JESD_NP=16 \
RX2_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=2 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1 \
RX_KS_PER_CHANNEL=32 \
RX2_KS_PER_CHANNEL=32 \
TX_KS_PER_CHANNEL=32
```

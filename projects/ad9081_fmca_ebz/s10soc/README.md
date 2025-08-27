<!-- no_dts, no_no_os -->

# AD9081-FMCA-EBZ/S10SOC HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the system_constr.sdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/s10soc
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

:warning: **Only JESD204B (8B10B) is supported for this carrier!**

The overwritable parameters from the environment are:

- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- REF_CLK_RATE: frequency of the reference clock in MHz used in 8B10B mode (LANE_RATE/40)
- DEVICE_CLK_RATE: frequency of the device clock in MHz, usually equal to REF_CLK_RATE
- [RX/TX]_JESD_M: [RX/TX] number of converters per link
- [RX/TX]_JESD_L: [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP: [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS: [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_KS_PER_CHANNEL: [RX/TX] number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
REF_CLK_RATE=250 \
DEVICE_CLK_RATE=250 \
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
RX_KS_PER_CHANNEL=32 \
TX_KS_PER_CHANNEL=32
```

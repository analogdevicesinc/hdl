<!-- no_dts, no_no_os -->

# AD-XBAND16-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad_xband16_ebz/vcu118
make
```

All of the RX/TX link modes can be found in the [AD9084 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/eval-ad9084-ad9088-ug-2326.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- HW_REV : Used for different hardware revisions constraints:
  - OLD_REV - Builds the old hardware revision until REV C Quad-Apollo
  - NEW_REV - This is used for the latest hardware revision
- MCS_MODE : Used for multiple boards' synchronization
- JESD_MODE : Used link layer encoder mode
  - 64B66B - 64b66b link layer defined in JESD 204C
  - 8B10B  - 8b10b link layer defined in JESD 204B
- RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
- TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
- [RX/TX]_JESD_M : Number of converters per link
- [RX/TX]_JESD_L : Number of lanes per link
- [RX/TX]_JESD_S : Number of samples per converter per frame
- [RX/TX]_JESD_NP : Number of bits per sample
- [RX/TX]_NUM_LINKS : Number of links
- [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
- DO_HAS_BYPASS : If set, the data offload IPs are built with the bypass path enabled

### Example configurations

#### JESD204C, 26.4 Gbps lane rate (default)

This specific command is equivalent to running `make` only:

```
make HW_REV=OLD_REV
MCS_MODE=MASTER
JESD_MODE=64B66B \
RX_LANE_RATE=26.4 \
TX_LANE_RATE=26.4 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=4 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=4 \
RX_KS_PER_CHANNEL=8 \
TX_KS_PER_CHANNEL=8 \
DO_HAS_BYPASS=0
```

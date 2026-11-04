<!-- no_dts, no_no_os -->

# AD9084-EBZ/VPK180 HDL Project

- VADJ with which it was tested in hardware: 1.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9084_ebz/vpk180
make
```

All of the RX/TX link modes can be found in the [AD9084 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/eval-ad9084-ad9088-ug-2326.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE : Used link layer encoder mode
  - 64B66B - 64b66b link layer defined in JESD 204C
  - 8B10B  - 8b10b link layer defined in JESD 204B
-
- REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
- HSCI_ENABLE : If set, adds and enables the HSCI core in the design
- RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
- TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
- [RX/TX]_JESD_M : Number of converters per link
- [RX/TX]_JESD_L : Number of lanes per link
- [RX/TX]_JESD_S : Number of samples per converter per frame
- [RX/TX]_JESD_NP : Number of bits per sample
- [RX/TX]_NUM_LINKS : Number of links - only when ASYMMETRIC_A_B_MODE = 0
- [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
- ASYMMETRIC_A_B_MODE : When set, each Apollo side has its own JESD link
- RX_B_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA ) for B side
- TX_B_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo ) for B side
- [RX/TX]_B_JESD_M : Number of converters per link for B side
- [RX/TX]_B_JESD_L : Number of lanes per link for B side
- [RX/TX]_B_JESD_S : Number of samples per converter per frame for B side
- [RX/TX]_B_JESD_NP : Number of bits per sample for B side
- [RX/TX]_B_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M) for B side
- AION_ENABLE : If set, adds and enables the AION core in the design; the adf4030 then sources sysref and drives the trigger pins
- FSRC_ENABLE : When set, fractional sample rate conversion is inserted in both directions: RX deletes the samples Apollo marked invalid and compacts what is left, TX leaves holes where Apollo will not read
- FSRC_ACCUM_WIDTH : Width of the FSRC rate accumulator, which sets the granularity of the achievable ratio

### Example configurations

#### JESD204C, 20.625 Gbps lane rate (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
REF_CLK_RATE=312.5 \
HSCI_ENABLE=1 \
AION_ENABLE=0 \
RX_LANE_RATE=20.625 \
TX_LANE_RATE=20.625 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=2 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=2 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64 \
ASYMMETRIC_A_B_MODE=0 \
FSRC_ENABLE=0 \
FSRC_ACCUM_WIDTH=56
```

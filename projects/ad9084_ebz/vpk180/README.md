<!-- no_no_os -->

# AD9084-EBZ/VPK180 HDL Project

- VADJ with which it was tested in hardware: 1.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9084_ebz/vpk180
make
```

All of the RX/TX link modes can be found in the [AD9084 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/eval-ad9084-ug-2326.pdf). We offer support for only a few of them.

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
- [RX/TX]_JESD_NP : Number of bits per sample
- [RX/TX]_NUM_LINKS : Number of links - only when ASYMMETRIC_A_B_MODE = 0
- [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
- ASYMMETRIC_A_B_MODE : When set, each Apollo side has its own JESD link
- RX_B_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA ) for B side
- TX_B_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo ) for B side
- [RX/TX]_B_JESD_M : Number of converters per link for B side
- [RX/TX]_B_JESD_L : Number of lanes per link for B side
- [RX/TX]_B_JESD_NP : Number of bits per sample for B side
- [RX/TX]_B_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M) for B side

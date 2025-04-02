# AD9082-FMCA-EBZ/ZC706 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the ../../ad9081_fmca_ebz/zc706/timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9082_fmca_ebz/zc706
make
```

All of the RX/TX link modes can be found in the [AD9082 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

:warning: **Only JESD204B (8B10B) is supported for this carrier!**

The overwritable parameters from the environment are:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP - [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_TPL_WIDTH - [RX/TX] transport layer data width

### Example configurations


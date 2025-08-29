<!-- no_no_os -->

# AD9209-FMCA-EBZ/VCK190 HDL Project

- VADJ with which it was tested in hardware: 1.5V

## Building the project

```
cd projects/ad9209_fmca_ebz/vck190
make
```

All of the RX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). Other details can be consulted in the [AD9209 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9209.pdf). We offer support for only a few of these RX modes.

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- RX_LANE_RATE: lane rate of the RX link (MxFE to FPGA)
- REF_CLK_RATE: frequency of the reference clock in MHz used in 64B66B mode (LANE_RATE/66)
- RX_JESD_M: RX number of converters per link
- RX_JESD_L: RX number of lanes per link
- RX_JESD_S: RX number of samples per converter per frame
- RX_JESD_NP: RX number of bits per sample, only 16 is supported
- RX_NUM_LINKS: RX number of links, which matches the number of MxFE devices
- RX_KS_PER_CHANNEL: RX number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
REF_CLK_RATE=375 \
RX_JESD_M=4 \
RX_JESD_L=8 \
RX_JESD_S=4 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
RX_KS_PER_CHANNEL=64
```

Corresponding device tree: [versal-vck190-reva-ad9209.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/versal-vck190-reva-ad9209.dts)

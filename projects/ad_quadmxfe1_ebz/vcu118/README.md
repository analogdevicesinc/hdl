<!-- no_no_os -->

# AD-QUADMXFE1-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad_quadmxfe1_ebz/vcu118
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

:warning: [RX/TX]_LANE_RATE, [RX/TX]_PLL_SEL, REF_CLK_RATE are used only in 64B66B mode!

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_PLL_SEL - used only in 64B66B mode:
  - 0 - CPLL for lane rates 4-12.5 Gbps and integer sub-multiples
  - 1 - QPLL0 for lane rates 19.6–32.75 Gbps and integer sub-multiples (e.g. 9.8–16.375;)
  - 2 - QPLL1 for lane rates 16.0–26.0 Gbps and integer sub-multiple (e.g. 8.0–13.0;)
  - For more details, see [JESD204 PHY v4.0 PG198](https://docs.amd.com/v/u/en-US/pg198-jesd204-phy) and [UltraScale Architecture GTY Transceivers UG578](https://docs.amd.com/v/u/en-US/ug578-ultrascale-gty-transceivers)
- REF_CLK_RATE - frequency of the reference clock in MHz, used only in 64B66B mode
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP - [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices
- RX_KS_PER_CHANNEL: RX number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture
- TX_KS_PER_CHANNEL: TX number of samples loaded for each channel in a block RAM for a contiguous cyclic streaming
- DAC_TPL_XBAR_ENABLE: Enable NxN crossbar functionality at the transport layer, where N is the number of channels

### Example configurations

#### AD9081, JESD204C subclass 1, TX mode 11, RX mode 4 (default)

This specific command is equivalent to running "make" only:

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.5 \
TX_LANE_RATE=16.5 \
RX_PLL_SEL=2 \
TX_PLL_SEL=2 \
REF_CLK_RATE=250 \
RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=4 \
TX_JESD_M=16 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=4 \
RX_KS_PER_CHANNEL=32 \
TX_KS_PER_CHANNEL=16
```

Corresponding device trees:

- [vcu118_quad_ad9081_204c_txmode_11_rxmode_4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_11_rxmode_4.dts)
- for Quad MxFE rev. C: [vcu118_quad_ad9081_204c_txmode_11_rxmode_4_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_11_rxmode_4_revc.dts)
- for direct 6 GHz: [vcu118_quad_ad9081_204c_txmode_11_rxmode_4_direct_6g.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_11_rxmode_4_direct_6g.dts)

#### AD9081, JESD204B subclass 1, TX mode 5, RX mode 6

- TX JESD204B lane rate = 5 Gbps
- RX JESD205B lane rate = 5 Gbps

```
make JESD_MODE=8B10B \
RX_JESD_M=4 \
RX_JESD_L=2 \
TX_JESD_M=4 \
TX_JESD_L=2
```

Corresponding device trees:

- [vcu118_quad_ad9081_204b_txmode_5_rxmode_6.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204b_txmode_5_rxmode_6.dts)
- for Quad MxFE rev. C: [vcu118_quad_ad9081_204b_txmode_5_rxmode_6_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204b_txmode_5_rxmode_6_revc.dts)

#### AD9081, JESD204B subclass 1, TX mode 9, RX mode 10

- TX JESD204B lane rate = 10 Gbps
- RX JESD205B lane rate = 10 Gbps

```
make JESD_MODE=8B10B \
RX_JESD_L=4 \
RX_JESD_M=8 \
RX_JESD_NP=16 \
RX_NUM_LINKS=4 \
TX_JESD_L=4 \
TX_JESD_M=8 \
TX_JESD_NP=16 \
TX_NUM_LINKS=4
```

Corresponding device trees:

- [vcu118_quad_ad9081_204b_txmode_9_rxmode_10.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204b_txmode_9_rxmode_10.dts)
- for Quad MxFE rev. C: [vcu118_quad_ad9081_204b_txmode_9_rxmode_10_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204b_txmode_9_rxmode_10_revc.dts)

#### AD9081, JESD204C subclass 1, TX mode 10, RX mode 11

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.5 \
TX_LANE_RATE=16.5 \
REF_CLK_RATE=250 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=16
```

Corresponding device trees:

- [vcu118_quad_ad9081_204c_txmode_10_rxmode_11.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_10_rxmode_11.dts)
- for Quad MxFE rev. C: [vcu118_quad_ad9081_204c_txmode_10_rxmode_11_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_10_rxmode_11_revc.dts)


#### AD9081, JESD204C subclass 1, TX mode 29, RX mode 24

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_PLL_SEL=1 \
TX_PLL_SEL=1 \
REF_CLK_RATE=250 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=12 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=12 \
RX_KS_PER_CHANNEL=16 \
TX_KS_PER_CHANNEL=16
```

Corresponding device tree (for Quad MxFE rev. C): [vcu118_quad_ad9081_204c_txmode_29_rxmode_24_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_29_rxmode_24_revc.dts)

#### AD9082, JESD204C subclass 1, TX mode 3, RX mode 2

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.5 \
TX_LANE_RATE=16.5 \
REF_CLK_RATE=250 \
RX_JESD_M=4 \
RX_JESD_L=1 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=8 \
TX_JESD_L=2 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_KS_PER_CHANNEL=16 \
TX_KS_PER_CHANNEL=16
```

Corresponding device trees:

- [vcu118_quad_ad9082_204c_txmode_3_rxmode_2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_3_rxmode_2.dts)
- with on-chip PLL: [vcu118_quad_ad9082_204c_txmode_3_rxmode_2_onchip_pll.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_3_rxmode_2_onchip_pll.dts) (check the comments in the dts for hardware changes)

#### AD9082, JESD204C subclass 1, TX mode 12, RX mode 13

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_PLL_SEL=1 \
TX_PLL_SEL=1 \
REF_CLK_RATE=250 \
RX_JESD_M=2 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=2 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64
```

Corresponding device trees:

- [vcu118_quad_ad9082_204c_txmode_12_rxmode_13.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_12_rxmode_13.dts)
- with on-chip PLL: [vcu118_quad_ad9082_204c_txmode_12_rxmode_13_onchip_pll.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_12_rxmode_13_onchip_pll.dts) (check the comments in the dts for hardware changes)

#### AD9082, JESD204C subclass 1, TX mode 23, RX mode 25

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_PLL_SEL=1 \
TX_PLL_SEL=1 \
REF_CLK_RATE=250 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=2 \
RX_JESD_NP=12 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
RX_KS_PER_CHANNEL=16 \
TX_KS_PER_CHANNEL=16
```

Corresponding device trees:

- [vcu118_quad_ad9082_204c_txmode_23_rxmode_25.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_23_rxmode_25.dts)
- for Quad MxFE rev. C: [vcu118_quad_ad9081_204c_txmode_23_rxmode_25_revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_23_rxmode_25_revc.dts)
- with on-chip PLL: [vcu118_quad_ad9082_204c_txmode_23_rxmode_25_onchip_pll.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9082_204c_txmode_23_rxmode_25_onchip_pll.dts) (check the comments in the dts for hardware changes)

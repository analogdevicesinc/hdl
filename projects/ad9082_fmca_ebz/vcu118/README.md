<!-- no_no_os -->

# AD9082-FMCA-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the ../../ad9081_fmca_ebz/vcu118/timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9082_fmca_ebz/vcu118
make
```

All of the RX/TX link modes can be found in the [AD9082 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
  - 64B66B - 64b66b link layer defined in JESD204C
- [RX/TX]_LANE_RATE: lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M: [RX/TX] number of converters per link
- [RX/TX]_JESD_L: [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP: [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS: [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_KS_PER_CHANNEL: [RX/TX] number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

### Example configurations

#### JESD204B subclass 1, TX mode 17, RX mode 18 (default)

```
make JESD_MODE=8B10B \
RX_LANE_RATE=15 \
TX_LANE_RATE=15 \
RX_JESD_M=4 \
RX_JESD_L=8 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=8 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64
```

Corresponding device tree: [vcu118_ad9082.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9082.dts)

#### JESD204C subclass 1, TX mode 18, RX mode 19

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_JESD_M=2 \
RX_JESD_L=8 \
RX_JESD_S=2 \
RX_JESD_NP=16 \
TX_JESD_M=2 \
TX_JESD_L=8 \
TX_JESD_S=2 \
TX_JESD_NP=16
```

Corresponding device tree: [vcu118_ad9082_204c_txmode_18_rxmode_19_lr_24_75Gbps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9082_204c_txmode_18_rxmode_19_lr_24_75Gbps.dts)

#### JESD204C subclass 1, TX mode 18, RX mode 19

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.22016 \
TX_LANE_RATE=16.22016 \
RX_JESD_M=8 \
RX_JESD_L=2 \
TX_JESD_M=16 \
TX_JESD_L=4
```

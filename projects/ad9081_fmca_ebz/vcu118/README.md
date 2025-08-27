<!-- no_no_os -->

# AD9081-FMCA-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz/vcu118
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

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
- CORUNDUM: includes and enables the Corundum Network Stack in the design

### Example configurations

#### JESD204B subclass 1, TX mode 9, RX mode 10 (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
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
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64
```

Corresponding device tree: [vcu118_ad9081_m8_l4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_m8_l4.dts)

#### JESD204B subclass 1, TX mode 17, RX mode 18

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
TX_NUM_LINKS=1
```

Corresponding device tree: [vcu118_ad9081.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081.dts)

#### JESD204C subclass 1, TX mode 10, RX mode 11

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.5 \
TX_LANE_RATE=16.5 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1
```

Corresponding device tree: [vcu118_ad9081_204c_txmode_10_rxmode_11.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_204c_txmode_10_rxmode_11.dts)

#### JESD204C subclass 1, TX mode 10, RX mode 11, lane rate 24.75Gbps

- RX/TX lane rate = 24.75 Gbps
- RX/TX_JESD_NP = 16
- RX/TX_JESD_S = 1

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=1 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=1
```

Corresponding device tree: [vcu118_ad9081_204c_txmode_10_rxmode_11_lr_24_75Gbps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_204c_txmode_10_rxmode_11_lr_24_75Gbps.dts)

#### JESD204C subclass 1, TX mode 23, RX mode 25

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.5 \
TX_LANE_RATE=16.5 \
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

Corresponding device trees:

- with RX/TX lane rate of 16.5Gbps: [vcu118_ad9081_204c_txmode_23_rxmode_25.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_204c_txmode_23_rxmode_25.dts)
- with RX/TX lane rate of 24.75Gbps: [vcu118_ad9081_204c_txmode_23_rxmode_25_lr_24_75Gbps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_204c_txmode_23_rxmode_25_lr_24_75Gbps.dts)

#### JESD204C subclass 1, TX mode 24, RX mode 26

```
make JESD_MODE=64B66B \
RX_LANE_RATE=24.75 \
TX_LANE_RATE=24.75 \
RX_JESD_M=8 \
RX_JESD_L=8 \
RX_JESD_S=2 \
RX_JESD_NP=12 \
RX_NUM_LINKS=1 \
TX_JESD_M=8 \
TX_JESD_L=8 \
TX_JESD_S=2 \
TX_JESD_NP=12 \
TX_NUM_LINKS=1
```

Corresponding device tree: [vcu118_ad9081_204c_txmode_24_rxmode_26_lr_24_75Gbps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_ad9081_204c_txmode_24_rxmode_26_lr_24_75Gbps.dts)

#### JESD204B subclass 1, TX mode 9, RX mode 10 (default) with Corundum Network Stack

This specific command is equivalent to running `make CORUNDUM=1`:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
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
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64 \
CORUNDUM = 1
```

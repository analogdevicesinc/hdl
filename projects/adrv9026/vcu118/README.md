<!-- no_no_os -->

# ADRV9026/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/adrv9026/vcu118
make
```

All of the RX/TX link modes can be found in the [ADRV9026 data sheet](https://www.analog.com/media/radioverse-adrv9026/adrv9026.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

**Warning**: The JESD link mode is configured using the [ADRV9026 Evaluation Software](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/eval-adrv9026.html#eb-relatedsoftware:~:text=Design%20Tool%20(1)-,Evaluation%20Software,-ADRV9026%20Released%20Software) application. The default device tree is: [vcu118_adrv9025.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025.dts). For ORX integration in NLS mode the device tree is: [vcu118_adrv9025_nls.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025_nls.dts). For JESD204C and ORX in NLS mode the device tree is: [vcu118_adrv9025_jesd204c.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025_jesd204c.dts).


The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204Br
  - 64B66B - 64b66b link layer defined in JESD204C
- ORX_ENABLE : Additional data path for RX-OS
  - 0 - Disabled (used for profiles with RX-OS disabled)
  - 1 - Enabled (used for profiles with RX-OS enabled)
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link
- [RX/TX/RX_OS]_JESD_M - [RX/TX/RX_OS] number of converters per link
- [RX/TX/RX_OS]_JESD_L - [RX/TX/RX_OS] number of lanes per link
- [RX/TX/RX_OS]_JESD_S - [RX/TX/RX_OS] number of samples per converter per frame
- [RX/TX/RX_OS]_JESD_NP - [RX/TX/RX_OS] number of bits per sample
- [RX/TX/RX_OS]_NUM_LINKS - [RX/TX/RX_OS] number of links

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
ORX_ENABLE=0 \
RX_LANE_RATE=9.83 \
TX_LANE_RATE=9.83 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_OS_JESD_M=0 \
RX_OS_JESD_L=0 \
RX_OS_JESD_S=0 \
RX_OS_JESD_NP=0
```

Corresponding device tree: [vcu118_adrv9025.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025.dts)

#### ORX enabled in NLS mode

```
make JESD_MODE=8B10B \
ORX_ENABLE=1 \
RX_LANE_RATE=9.83 \
TX_LANE_RATE=9.83 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=4 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=2 \
RX_OS_JESD_S=1 \
RX_OS_JESD_NP=16
```

Corresponding device tree: [vcu118_adrv9025_nls.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025_nls.dts)

#### JESD204C with ORX in NLS mode

```
make JESD_MODE=64B66B \
ORX_ENABLE=1 \
RX_LANE_RATE=16.22 \
TX_LANE_RATE=16.22 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=8 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=2 \
RX_OS_JESD_S=1 \
RX_OS_JESD_NP=16
```

Corresponding device tree: [vcu118_adrv9025_jesd204c.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_adrv9025_jesd204c.dts)

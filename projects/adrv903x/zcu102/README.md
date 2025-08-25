<!-- no_no_os -->

# ARDV903x/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/adrv903x/zcu102
make
```

All of the RX/TX link modes can be found in the [ADRV9030 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adrv9030.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

**Warning**: The JESD link mode is configured using the ADRV903x plugin from [ACE](https://wiki.analog.com/resources/tools-software/ace) application. The device tree is the same, regardless of the configuration: [zynqmp-zcu102-rev10-adrv903x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv903x.dts)

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
  - 64B66B - 64b66b link layer defined in JESD204C
- ORX_ENABLE : Additional data path for RX-OS
  - 0 - Disabled (used for profiles with RX-OS disabled)
  - 1 - Enabled (used for profiles with RX-OS enabled)
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link
- [RX/TX/ORX]_JESD_M - [RX/TX/ORX] number of converters per link
- [RX/TX/ORX]_JESD_L - [RX/TX/ORX] number of lanes per link
- [RX/TX/ORX]_JESD_S - [RX/TX/ORX] number of samples per converter per frame
- [RX/TX/ORX]_JESD_NP - [RX/TX/ORX] number of bits per sample
- [RX/TX/ORX]_NUM_LINKS - [RX/TX/ORX] number of links

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.22 \
TX_LANE_RATE=16.22 \
ORX_ENABLE=1 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=16 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_OS_JESD_M=8 \
RX_OS_JESD_L=4 \
RX_OS_JESD_S=1 \
TX_JESD_M=16 \
TX_JESD_L=8 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv903x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv903x.dts)
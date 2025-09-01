<!-- no_no_os -->

# ADRV904X/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/adrv904x/zcu102
make
```

All of the RX/TX link modes can be found in the [ADRV9040 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adrv9040.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

**Warning**: The JESD link mode is configured using the ADRV904x plugin from [ACE](https://wiki.analog.com/resources/tools-software/ace) application. The default device tree is: [zynqmp-zcu102-rev10-adrv904x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x.dts). For ORX integration in NLS mode the device tree is: [zynqmp-zcu102-rev10-adrv904x-nls.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x-nls.dts).

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
- [RX/TX/RX_OS]_JESD_NP - [RX/TX/RX_OS] number of bits per sample, only 16 is supported
- [RX/TX/RX_OS]_NUM_LINKS - [RX/TX/RX_OS] number of links

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
ORX_ENABLE=0 \
RX_LANE_RATE=16.22 \
TX_LANE_RATE=16.22 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=16 \
RX_JESD_L=8 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=16 \
TX_JESD_L=8 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_OS_JESD_M=0 \
RX_OS_JESD_L=0 \
RX_OS_JESD_S=0 \
RX_OS_JESD_NP=0
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv904x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x.dts)

#### ORX enabled in NLS mode

```
make JESD_MODE=64B66B \
ORX_ENABLE=1 \
RX_LANE_RATE=16.22 \
TX_LANE_RATE=16.22 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_OS_NUM_LINKS=1 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
TX_JESD_M=16 \
TX_JESD_L=8 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
RX_OS_JESD_M=8 \
RX_OS_JESD_L=4 \
RX_OS_JESD_S=1 \
RX_OS_JESD_NP=16
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv904x-nls.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x-nls.dts)
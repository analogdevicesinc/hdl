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

**Warning**: The JESD link mode is configured using the ADRV904x plugin from [ACE](https://wiki.analog.com/resources/tools-software/ace) application. The device tree is the same, regardless of the configuration: [zynqmp-zcu102-rev10-adrv904x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x.dts)

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP - [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
RX_LANE_RATE=16.22 \
TX_LANE_RATE=16.22 \
RX_NUM_LINKS=1 \
TX_NUM_LINK=1 \
RX_JESD_M=16 \
RX_JESD_L=8 \
RX_JESD_S=1 \
TX_JESD_M=16 \
TX_JESD_L=8 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv904x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv904x.dts)
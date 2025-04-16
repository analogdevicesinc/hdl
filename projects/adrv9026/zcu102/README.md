# ADRV9026/ZCU102 HDL Project

## Building the project

```
cd projects/adrv9026/zcu102
make
```

All of the RX/TX link modes can be found in the [ADRV9026 data sheet](https://www.analog.com/media/radioverse-adrv9026/adrv9026.pdf). We offer support for only a few of them.

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame

### Example configurations

#### JESD204B subclass 1, TX mode 17, RX mode 18 (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=9.83 \
TX_LANE_RATE=9.83 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-adrv9025.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9025.dts)
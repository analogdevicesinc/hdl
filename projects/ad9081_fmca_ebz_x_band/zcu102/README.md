<!-- no_no_os -->

# AD9081-FMCA-EBZ-X-BAND/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the ../../ad9081_fmca_ebz/zcu102/timing_constr.xdc constraints should be updated as well!**

```
cd projects/ad9081_fmca_ebz_x_band/zcu102
make
```

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

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
- [RX/TX]_KS_PER_CHANNEL - Data Offload IP depth capability, kilosamples per channel
- TDD_SUPPORT - enables external synchronization through TDD; if enabled, then SHARED_DEVCLK must be enabled as well
- SHARED_DEVCLK - if the device clock is shared among devices
- TDD_CHANNEL_CNT
- TDD_SYNC_WIDTH
- TDD_SYNC_INT
- TDD_SYNC_EXT
- TDD_SYNC_EXT_CDC - adds the CDC circuitry for the external sync signal

### Example configurations

#### RX link mode 10, TX link mode 9, subclass 1 with TDD support (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=8B10B \
RX_LANE_RATE=10 \
TX_LANE_RATE=10 \
RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TDD_SUPPORT=1 \
SHARED_DEVCLK=1 \
TDD_CHANNEL_CNT=6 \
TDD_SYNC_WIDTH=0 \
TDD_SYNC_INT=0 \
TDD_SYNC_EXT=1 \
TDD_SYNC_EXT_CDC=1
```

Corresponding device trees:

- [zynqmp-zcu102-rev10-stingray.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-stingray.dts)
- using VCXO of 100MHz: [zynqmp-zcu102-rev10-stingray-vcxo100.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-stingray-vcxo100.dts)

# AD9083-VNA/ZCU102 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9083_vna/zcu102
make
```

All of the RX link modes can be found in the [AD9083 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9083.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- RX_JESD_M - RX number of converters per link
- RX_JESD_L - RX number of lanes per link
- RX_JESD_S - RX number of samples per converter per frame

### Example configurations

#### Default configuration:

This specific command is equivalent to running `make` only:

```
make RX_JESD_L=1 RX_JESD_M=32 RX_JESD_S=1
```

Corresponding device tree:
- [zynqmp-zcu102-rev10-ad9083-vna-15p625msps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9083-vna-15p625msps.dts)
- AD9083 cut-off frequency 125 MHz [zynqmp-zcu102-rev10-ad9083-vna-7p8125msps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9083-vna-7p8125msps.dts)
- AD9083 frequency 1 GHz [zynqmp-zcu102-rev10-ad9083-vna-3p90625msps.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9083-vna-3p90625msps.dts)
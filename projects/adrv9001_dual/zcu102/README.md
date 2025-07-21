<!-- no_no_os -->

# ADRV9001_DUAL/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd hdl/projects/adrv9001_dual/zcu102
make
```

The overwritable parameters from the environment:
 - CMOS_LVDS_N - type of interface
        0 - LVDS
        1 - CMOS

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd hdl/projects/adrv9001_dual/zcu102
make CMOS_LVDS_N=0
```

Corresponding device trees:
 - [zynqmp-zcu102-rev10-adrv9002.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9002.dts)
 - [zynqmp-zcu102-rev10-adrv9002-rx2tx2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-adrv9002-rx2tx2.dts)

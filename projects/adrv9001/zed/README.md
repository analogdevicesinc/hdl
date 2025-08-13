<!-- no_no_os -->

# ADRV9001/ZED HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/adrv9001/zed
make
```

The overwritable parameter from the environment:

- CMOS_LVDS_N - specific to the type of the data and clock signals
  - 0 - Differential data and clock signals 
  - 1 - Single-ended data and clock signals (default)

### Example configurations

#### Configuration using CMOS interface (default)

This specific command is equivalent to running "make" only:

```
make CMOS_LVDS_N=1
```

Corresponding device tree: [zynq-zed-adv7511-adrv9002.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adrv9002.dts)

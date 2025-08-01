<!-- no_no_os -->

# DC2677A/C5SOC HDL Project

- VADJ with which it was tested in hardware: 
  - 2.5V - LVDS
  - 3.3V - CMOS

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/dc2677a/c5soc
make
```

The overwritable parameter from the environment:

- LVDS_CMOS_N - specific to the type of the data and clock signals
  - 0 - Single-ended data and clock signals (default)
  - 1 - Differential data and clock signals
### Example configurations

#### Configuration using CMOS interface (default)

This specific command is equivalent to running "make" only:

```
make LVDS_CMOS_N=0
```

Corresponding device tree: [socfpga_cyclone5_sockit_dc2677a.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_cyclone5_sockit_dc2677a.dts)

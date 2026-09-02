<!-- no_no_os, no_dts -->

# AD4858-FMCZ-DUAL/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad4858_fmcz_dual/zcu102
make
```

The overwritable parameters from the environment are:

- LVDS_CMOS_N - selects the interface type to be used:
  - 0 - CMOS interface
  - 1 - LVDS interface (default)

### Example configurations

#### Configuration using LVDS interface (default)

Connect the evaluation boards FMC to the FMC HPC0 and FMC HPC1 connectors of ZCU102.

This specific command is equivalent to running "make" only:

```
make LVDS_CMOS_N=1
```

#### Configuration using CMOS interface

```
make LVDS_CMOS_N=0
```

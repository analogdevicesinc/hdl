<!-- no_no_os, no_dts -->

# AD485X-FMCZ/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad485x_fmcz/zcu102
make
```

The overwritable parameters from the environment are:

- LVDS_CMOS_N - selects the interface type to be used:
  - 0 - CMOS interface (default)
  - 1 - LVDS interface

### Example configurations

#### Configuration using CMOS interface (default)

Connect the evaluation board FMC to the FMC HPC0 connector of ZCU102.

This specific command is equivalent to running "make" only:

```
make LVDS_CMOS_N=0
```

#### Configuration using LVDS interface

```
make LVDS_CMOS_N=1
```

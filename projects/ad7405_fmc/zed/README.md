# AD7405-FMC/ZED HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad7405_fmc/zed
make
```

The overwritable parameter from the environment:

- LVDS_CMOS_N - specific to the type of the data and clock signals
  - 0 - Single-ended data and clock signals (default)
  - 1 - Differential data and clock signals
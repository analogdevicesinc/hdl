<!-- no_build_example, no_dts, no_no_os -->

# AD9740-FMC/ZED HDL Project

- VADJ with which it was tested in hardware: 3.3V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9740_fmc/zed
make
```

The overwritable parameters from the environment are:

- DEVICE - selects the target DAC device:
  - AD9748 - 8-bit DAC
  - AD9740 - 10-bit DAC
  - AD9742 - 12-bit DAC
  - AD9744 - 14-bit DAC (default)

### Example configurations

#### Default configuration (AD9744, 14-bit)

This specific command is equivalent to running "make" only:

```
make DEVICE=AD9744
```

#### Configuration for AD9740 (10-bit)

```
make DEVICE=AD9740
```

#### Configuration for AD9742 (12-bit)

```
make DEVICE=AD9742
```

#### Configuration for AD9748 (8-bit)

```
make DEVICE=AD9748
```

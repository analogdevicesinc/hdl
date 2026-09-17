<!-- no_dts, no_no_os -->

# AD559XR/CORAZ7S HDL Project

- VIO with which it was tested in hardware: 3.3V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```bash
cd projects/ad559xr/coraz7s
make
```

The overwritable parameters from the environment:

- INTF - Communication interface used by the device
  - SPI - Serial Peripheral Interface, AD5596R (default)
  - I2C - Inter-Integrated Circuit, AD5597R

### Example configurations

#### Default configuration (SPI - AD5596R)

This specific command is equivalent to running `make` only:

```bash
cd projects/ad559xr/coraz7s
make INTF=SPI
```

#### I2C configuration (AD5597R)

```bash
cd projects/ad559xr/coraz7s
make INTF=I2C
```

# AD469X-FMC/CORAZ7S HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad469x_evb/coraz7s
make
```

The overwritable parameter from the environment:

- SPI_4WIRE - Defines if CNV signal is linked to PWM or to SPI_CS
   - 0 - CNV signal is linked to PWM
   - 1 - CNV signal is linked to SPI_CS

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/ad469x_evb/coraz7s
make SPI_4WIRE=0
```
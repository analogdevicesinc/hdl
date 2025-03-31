# AD469X-EVB HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

**SPI_4WIRE** - Defines if CNV signal is linked to PWM or to SPI_CS
* 0 - CNV signal is linked to PWM (default option)
* 1 - CNV signal is linked to SPI_CS

```
hdl/projects/ad469x_fmc/zed> make SPI_4WIRE=0
```

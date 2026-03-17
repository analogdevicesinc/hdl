<!-- no_dts, no_no_os -->

# AD469X-EVB/CORAZ7S HDL Project

- VIO with which it was tested in hardware: 3.3V

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
- PWM_OFFLOAD - Defines the SPI Engine offload trigger and CNV gating
   - 0 - BUSY edge trigger, DMA+PWM gated CNV (ad469x)
   - 1 - BUSY edge trigger, PWM+BUSY gated CNV (ad4692 register)
   - 2 - PWM+DMA gated trigger, no CNV gating (ad4692 manual)

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/ad469x_evb/coraz7s
make SPI_4WIRE=0 PWM_OFFLOAD=0
```
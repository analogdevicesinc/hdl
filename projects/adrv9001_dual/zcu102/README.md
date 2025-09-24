<!-- no_dts, no_no_os -->

# ADRV9001-DUAL/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd hdl/projects/adrv9001_dual/zcu102
make
```

The overwritable parameters from the environment:

- CMOS_LVDS_N - selects the interface type
  - 0 = LVDS (default)
  - 1 = CMOS
- USE_RX_CLK_FOR_TX1 - selects the clock to drive the TX1 SSI interface
  - 0 = TX1 dedicated clock (default)
  - 1 = RX1 SSI clock
  - 2 = RX2 SSI clock
- USE_RX_CLK_FOR_TX2 - selects the clock to drive the TX2 SSI interface
  - 0 = TX2 dedicated clock (default)
  - 1 = RX1 SSI clock
  - 2 = RX2 SSI clock

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd hdl/projects/adrv9001_dual/zcu102
make CMOS_LVDS_N=0 \
USE_RX_CLK_FOR_TX1=0 \
USE_RX_CLK_FOR_TX2=0
```

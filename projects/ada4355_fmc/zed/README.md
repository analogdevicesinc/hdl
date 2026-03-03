<!-- no_build_example, no_dts, no_no_os -->

# ADA4355-FMC/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default
configuration.

```
cd projects/ada4355_fmc/zed
make
```

This project supports two pinout variants, which are differentiated by how the frame clock signals are distributed.

For ADA4355 the XDC constraints are not optimized for ISERDES, as the frame clock signals are located in a different I/O bank from the other related signals. To address this, a BUFMRCE buffer is used to distribute the frame clock to all ISERDES instances.

The overwritable parameters from the environment:

- BUFMRCE_EN - Specifies the evaluation board type
  - 0 - ADA4356 - pinout with optimized constraints (default)
  - 1 - ADA4355 - pinout with non-optimized constraints
- TDD_EN - Enables the TDD controller for LiDAR timing control; only supported with BUFMRCE_EN=0 (ADA4356)
  - 0 - TDD disabled, plain ADC capture (default)
  - 1 - TDD enabled, adds axi_tdd IP with laser trigger and DMA synchronization

### Example configurations

#### ADA4356 - plain ADC capture (default)

This specific command is equivalent to running `make` only:

```
make BUFMRCE_EN=0 TDD_EN=0
```

#### ADA4356 - with TDD for LiDAR

```
make BUFMRCE_EN=0 TDD_EN=1
```

#### ADA4355 - plain ADC capture

```
make BUFMRCE_EN=1 TDD_EN=0
```

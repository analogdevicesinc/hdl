<!-- no_dts, no_no_os -->

# AD4062-ARDZ/CORAZ7S HDL Project

- VIO with which it was tested in hardware: 3.3V

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad4062_ardz/coraz7s
make
```

The overwritable parameter from the environment:

- OFFLOAD - enables the offload mode, which adds the AXI_DMAC and AXI_PWM to the design;
  - 0 - offload mode disabled (default)
  - 1 - offload mode enabled

### Example configurations

#### Offload mode disabled (default)

This specific command is equivalent to running `make` only:

```
make OFFLOAD=0
```

#### Offload mode enabled

```
make OFFLOAD=1
```

<!-- no_no_os -->

# CN0577/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the ``make`` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/cn0577/zed
make
```

The overwritable parameters from the environment are:

- TWOLANES: whether to use two lanes or one lane mode;
  - 1 - two-lane mode used (default)
  - 0 - one-lane mode used

### Example configurations

#### Two lanes, 18-bit resolution (default)

This specific command is equivalent to running `make` only:

```
make TWOLANES=1
```

Corresponding device tree: [zynq-zed-adv7511-cn0577.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-cn0577.dts)

#### One lane, 18-bit resolution

```
make TWOLANES=0
```

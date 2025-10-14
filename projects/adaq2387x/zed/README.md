<!-- no_no_os -->

# ADAQ2387X/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the ``make`` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/adaq2387x/zed
make
```

The overwritable parameters from the environment are:

- TWOLANES: whether to use two lanes or one lane mode;
  - 1 - two-lane mode used (default)
  - 0 - one-lane mode used
- ADC_RES: the resolution of the ADC input data;
  - 18 - the resolution is 18 bits (default)
  - 16 - the resolution is 16 bits
- USE_MMCM: choose between default 100MHz ref_clk or 240MHz
  - 1 - 240Mhz
  - 0 - 100MHz (default)

### Example configurations

#### Two lanes, 18-bit resolution, 100MHz ref_clk (default)

This specific command is equivalent to running `make` only:

```
make TWOLANES=1 \
ADC_RES=18 \
USE_MMCM=0
```

Corresponding device tree: [zynq-zed-adv7511-adaq23878.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq23878.dts)

#### One lane, 18-bit resolution

```
make TWOLANES=0 \
ADC_RES=18
```

#### Two lanes, 16-bit resolution

```
make TWOLANES=1 \
ADC_RES=16
```

Corresponding device tree: [zynq-zed-adv7511-adaq23875.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq23875.dts)

#### One lane, 16-bit resolution

```
make TWOLANES=0 \
ADC_RES=16
```

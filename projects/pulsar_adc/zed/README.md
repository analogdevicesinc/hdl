# PULSAR-ADC/Zed HDL Project

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/pulsar_adc/zed
make
```

The overwritable parameter from the environment is:

- AD40XX_ADAQ400X_N - selects the evaluation board to be used:
  - 1 - EVAL-AD40XX-FMCZ (default option)
  - 0 - EVAL-ADAQ400X

### Example configurations

#### Building the project for EVAL-AD40XX-FMCZ (default)

This specific command is equivalent to running `make` only:

```
make AD40XX_ADAQ400X_N=1
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4003.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4003.dts)
- [zynq-zed-adv7511-ad4020.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4020.dts)

#### Building the project for EVAL-ADAQ400x

```
make AD40XX_ADAQ400X_N=0
```

Corresponding device tree: [zynq-zed-adv7511-adaq4003.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4003.dts)

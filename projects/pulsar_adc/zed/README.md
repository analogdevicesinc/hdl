<!-- no_no_os-->

# PULSAR-ADC/ZED HDL Project

- VIO with which it was tested in hardware: 3.3V

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/pulsar_adc/zed
make
```

The overwritable parameters from the environment are:

- FMC_N_PMOD - selects the evaluation board to be used:
  - 1 - EVAL-AD40XX-FMCZ (default option)
  - 0 - EVAL-ADAQ400x

- SPI_OP_MODE - selects the SPI operating mode (only applies when FMC_N_PMOD=1):
  - 0 - standard FMC version (default option)
  - 1 - FMC version with ADC SDO pin driven by SPI Engine CS and ADC CS pin driven by GPIO
  - 2 - FMC version with ADC SDO pin driven by GPIO and ADC CS pin driven by SPI Engine CS

### Example configurations

#### Building the project for EVAL-AD40XX-FMCZ, standard mode (default)

This specific command is equivalent to running `make` only:

```
make FMC_N_PMOD=1 SPI_OP_MODE=0
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4000.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4000.dts)
- [zynq-zed-adv7511-ad4001.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4001.dts)
- [zynq-zed-adv7511-ad4002.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4002.dts)
- [zynq-zed-adv7511-ad4003.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4003.dts)
- [zynq-zed-adv7511-ad4004.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4004.dts)
- [zynq-zed-adv7511-ad4005.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4005.dts)
- [zynq-zed-adv7511-ad4006.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4006.dts)
- [zynq-zed-adv7511-ad4007.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4007.dts)
- [zynq-zed-adv7511-ad4008.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4008.dts)
- [zynq-zed-adv7511-ad4010.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4010.dts)
- [zynq-zed-adv7511-ad4011.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4011.dts)
- [zynq-zed-adv7511-ad4020.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4020.dts)
- [zynq-zed-adv7511-ad4021.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4021.dts)

#### Building the project for EVAL-AD40XX-FMCZ, SPI Engine CS drives ADC SDO

```
make FMC_N_PMOD=1 SPI_OP_MODE=1
```

The same device trees as for SPI_OP_MODE=0 apply.

#### Building the project for EVAL-AD40XX-FMCZ, GPIO drives ADC SDO

```
make FMC_N_PMOD=1 SPI_OP_MODE=2
```

The same device trees as for SPI_OP_MODE=0 apply.

#### Building the project for EVAL-ADAQ400x

```
make FMC_N_PMOD=0
```

Corresponding device tree: [zynq-zed-adv7511-adaq4003.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4003.dts)

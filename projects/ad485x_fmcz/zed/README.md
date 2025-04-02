# AD485X-FMCZ/Zed HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad485x/zed
make
```

The overwritable parameters from the environment are:

- LVDS_CMOS_N - selects the interface type to be used:
  - 0 - CMOS interface (default)
  - 1 - LVDS interface
  
- THREE_W_SPI - selects the SPI configuration to be used:
  - 0 - 4 wire SPI (default)
  - 1 - 3 wire SPI
  
- DEVICE - selects the device to be used:
  - AD4851
  - AD4852 
  - AD4853
  - AD4854 
  - AD4855
  - AD4856 
  - AD4857
  - AD4858 (default)

### Example configurations

#### Configuration using CMOS interface, 4 wire SPI (default)

Connect the evaluation board FMC to the FMC connector of Zedboard.

This specific command is equivalent to running "make" only:

```
make LVDS_CMOS_N=0 THREE_W_SPI=0
```

#### Configurations using LVDS interface

To build the LVDS interface - 4 wire SPI:

```
make LVDS_CMOS_N=1 THREE_W_SPI=0
```

To build the LVDS interface - 3 wire SPI:

```
make LVDS_CMOS_N=1 THREE_W_SPI=1
```

#### Configurations using LVDS interface

To build a specific part configuration:

```
make DEVICE=AD4851
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4851-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4851-fmcz.dts)
- [zynq-zed-adv7511-ad4852-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4852-fmcz.dts)
- [zynq-zed-adv7511-ad4853-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4853-fmcz.dts)
- [zynq-zed-adv7511-ad4854-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4854-fmcz.dts)
- [zynq-zed-adv7511-ad4855-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4855-fmcz.dts)
- [zynq-zed-adv7511-ad4856-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4856-fmcz.dts)
- [zynq-zed-adv7511-ad4857-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4857-fmcz.dts)
- [zynq-zed-adv7511-ad4858-fmcz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/zynq-zed-adv7511-ad4858-fmcz.dts)


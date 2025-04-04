# AD9434-FMC/ZC706 HDL Project

## Building the project

```
cd projects/ad9434_fmc/zc706
make
```

Corresponding device trees:

- [zynq-zc706-adv7511-ad9434-fmc-500ebz.dts](https://github.com/analogdevicesinc/linux/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-ad9434-fmc-500ebz.dts)
- [ad9467.c](https://github.com/analogdevicesinc/linux/blob/main/drivers/iio/adc/ad9467.c) (used for AD9434-FMC as well)

## Configuration using FMC connector

Connect the evaluation board to the FMC LPC connector of ZC706.

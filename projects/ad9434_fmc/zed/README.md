# AD9434-FMC/Zed HDL Project

## Building the project

```
cd projects/ad9434_fmc/zed
make
```

Corresponding device trees:

- [zynq-zed-adv7511-ad9434-fmc-500ebz.dts](https://github.com/analogdevicesinc/linux/blob/eef6f463a90dc47af51a0a7d70f96609ef7d5f35/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad9434-fmc-500ebz.dts)
- [ad9467.c](https://github.com/analogdevicesinc/linux/blob/main/drivers/iio/adc/ad9467.c) (used for AD9434-FMC as well)

## Configuration using FMC connector

Connect the evaluation board to the FMC LPC connector of Zed.

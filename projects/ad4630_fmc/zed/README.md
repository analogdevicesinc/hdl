# EVAL-AD463X-FMC/ZED HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as
well as in the **system_project.tcl** file.

```
cd projects/ad4630_fmc/zed
make
```

This design supports almost all the digital interface modes of AD463x, AD403x
and ADAQ42xx. A new bit stream should be generated each time when the targeted
configuration changes. More context on the supported modes can be found in the:

- [AD403x-24 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad4030-24-4032-24.pdf)
- [AD463x-16 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad4630-16-4632-16.pdf)
- [AD463x-24 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad4630-24_ad4632-24.pdf)
- [ADAQ4216 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adaq4216.pdf)
- [ADAQ4224 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/adaq4224.pdf)

If other configurations are desired, then the parameters from the HDL project
need to be changed, as well as the Linux project configurations:

The overwritable parameters from the environment are:

- CLK_MODE: clocking mode of the device's digital interface
  - 0 - SPI
  - 1 - Echo-clock or Master clock 
- NUM_OF_SDI: the number of MOSI lines of the SPI interface
  - 1 - Interleaved
  - 2 - 1LPC
  - 4 - 2LPC
  - 8 - 4LPC
- CAPTURE_ZONE: the capture zone of the next sample
  - 1 - neg. edge of BUSY
  - 2 - next pos. edge of CNV
- DDR_EN: in echo and master clock mode the SDI lines can have Single or Double data rates
  - 0 - MISO runs on SDR
  - 1 - MISO runs on DDR

### Example configurations

#### Clock mode 0, MOSI lines 2, Capture zone 2, DDR_EN 0

This specific command is equivalent to running `make` only:

```
make CLK_MODE=0 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0
``` 

#### Clock mode 0, MOSI lines 2, Capture zone 2, DDR_EN 0

```
make CLK_MODE=0 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 0, MOSI lines 4, Capture zone 2, DDR_EN 0

```
make CLK_MODE=0 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 0, MOSI lines 8, Capture zone 2, DDR_EN 0

```
make CLK_MODE=0 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 1, MOSI lines 2, Capture zone 2, DDR_EN 0

```
make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 1, MOSI lines 4, Capture zone 2, DDR_EN 0

```
make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 1, MOSI lines 8, Capture zone 2, DDR_EN 0

```
make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode 1, MOSI lines 2, Capture zone 2, DDR_EN 1

```
make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode 1, MOSI lines 4, Capture zone 2, DDR_EN 1

```
make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode 1, MOSI lines 8, Capture zone 2, DDR_EN 1

```
make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=1
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4030-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4030-24.dts)
- [zynq-zed-adv7511-ad4032-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4032-24.dts)
- [zynq-zed-adv7511-ad4630-16.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-16.dts)
- [zynq-zed-adv7511-ad4630-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-24.dts)
- [zynq-zed-adv7511-adaq4216.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4216.dts)
- [zynq-zed-adv7511-adaq4220.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4220.dts)
- [zynq-zed-adv7511-adaq4224-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4224-24.dts)
- [zynq-zed-adv7511-adaq4224-24_cm0_sdi4_cz2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4224-24_cm0_sdi4_cz2.dts)

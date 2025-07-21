<!-- no_no_os -->

# AD4630-FMC/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as
well as in the **system_project.tcl** file.

```
cd projects/ad4630_fmc/zed
make
```

This design supports almost all the digital interface modes of AD463x, AD403x
and ADAQ42xx. A new bitstream should be generated each time when the targeted
configuration changes.

If other configurations are desired, then the parameters from the HDL project
need to be changed, as well as the Linux project configurations:

The overwritable parameters from the environment are:

- CLK_MODE: clocking mode of the device's digital interface
  - 0 - SPI (default)
  - 1 - Echo-clock or Master clock 
- NUM_OF_SDI: the number of MISO lines of the SPI interface
  - 1 - Interleaved
  - 2 - 1LPC
  - 4 - 2LPC (default)
  - 8 - 4LPC
- CAPTURE_ZONE: the capture zone of the next sample
  - 1 - negative edge of BUSY
  - 2 - next positive edge of CNV (default)
- DDR_EN: in echo and master clock mode, the SDI lines can have Single or Double data rates
  - 0 - MISO runs on SDR (default)
  - 1 - MISO runs on DDR
- NO_REORDER: removes the spi_axis_reorder from system for CAPTURE_ZONE = 1 and
  NUM_OF_SDI = 1 (AD4030) or NUM_OF_SDI = 2 (AD4630) and directly connects the SPI
  Engine to DMA
  - 0 - spi_axis_reorder present (default)
  - 1 - spi_axis_reorder removed

### Example configurations

#### Clock mode SPI, MISO lines 4, Capture zone 2, SDR (default)

This specific command is equivalent to running `make` only:

```
make CLK_MODE=0 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

Corresponding device trees:
- [zynq-zed-adv7511-ad4630-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-24.dts)
- [zynq-zed-adv7511-ad4630-16.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-16.dts)

#### Clock mode SPI, MISO lines 2, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4030-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4030-24.dts)
- [zynq-zed-adv7511-ad4032-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4032-24.dts)
- [zynq-zed-adv7511-adaq4216.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4216.dts)
- [zynq-zed-adv7511-adaq4220.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4220.dts)
- [zynq-zed-adv7511-adaq4224-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4224-24.dts)

#### Clock mode SPI, MISO lines 4, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

#### Clock mode SPI, MISO lines 8, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 2, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 4, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 8, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 2, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=1 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 4, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=1 NO_REORDER=0
```

#### Clock mode ECHO, MISO lines 8, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=1 NO_REORDER=0
```

#### Clock mode SPI, MISO lines 1, Capture zone 1, SDR (AD4030)

```
make CLK_MODE=0 NUM_OF_SDI=1 CAPTURE_ZONE=1 DDR_EN=0 NO_REORDER=1
```

#### Clock mode SPI, MISO lines 2, Capture zone 1, SDR (AD4630)

```
make CLK_MODE=0 NUM_OF_SDI=2 CAPTURE_ZONE=1 DDR_EN=1 NO_REORDER=1
```

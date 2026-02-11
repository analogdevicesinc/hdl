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
  - 0 - SPI (default);
  - 1 - Echo-clock or Master clock;
- NUM_OF_CHANNEL: the number of ADC channels
  - 1 - AD403x devices;
  - 2 - AD463x/adaq42xx devices (default).
- LANES_PER_CHANNEL: the number of MISO lanes of the SPI interface per channel
  - 1 - 1 lane per channel: Interleaved mode or single lane per channel;
  - 2 - 2 lanes per channel;
  - 4 - 4 lanes per channel (default).
- CAPTURE_ZONE: the capture zone of the next sample
  - 1 - negative edge of BUSY;
  - 2 - next positive edge of CNV (default);
- DDR_EN: in echo or master clock mode, the MISO lanes can have Single or Double data rates
  - 0 - MISO runs on SDR (default);
  - 1 - MISO runs on DDR;
- INTERLEAVE_MODE: parameter used for NUM_OF_CHANNEL = 2 and LANES_PER_CHANNEL = 1 (ad463x).
  Enabling INTERLEAVE_MODE for any other configuration is invalid.
  - 0 - interleave mode disabled, each channel has their own MISO lanes. (default);
  - 1 - interleave mode enabled, the ad463x ADC share the same MISO lanes.

### Example configurations

#### Clock mode SPI, 2 channels, MISO lanes 4 (2 per channel), Capture zone 2, SDR (default)

This specific command is equivalent to running `make` only:

```
make CLK_MODE=0 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=0
```

Corresponding device trees:
- [zynq-zed-adv7511-ad4630-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-24.dts)
- [zynq-zed-adv7511-ad4630-16.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4630-16.dts)

#### Clock mode SPI, 1 channel, MISO lane 1, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=0
```

Corresponding device trees:

- [zynq-zed-adv7511-ad4030-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4030-24.dts)
- [zynq-zed-adv7511-ad4032-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4032-24.dts)
- [zynq-zed-adv7511-adaq4216.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4216.dts)
- [zynq-zed-adv7511-adaq4220.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4220.dts)
- [zynq-zed-adv7511-adaq4224-24.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-adaq4224-24.dts)

#### 1-Channel options
#### Clock mode SPI, 1 channel, MISO lane 1, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode SPI, 1 channel, MISO lanes 2, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode SPI, 1 channel, MISO lanes 4, Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 1 channel, MISO lane 1, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 1 channel, MISO lanes 2, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 1 channel, MISO lanes 4, Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 1 channel, MISO lane 1, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode Echo, 1 channel, MISO lanes 2, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode Echo, 1 channel, MISO lanes 4, Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=1 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=1
```

#### 2-Channel options
#### Clock mode SPI, 2 channels, MISO lanes 2 (1 per channel), Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode SPI, 2 channels, MISO lanes 4 (2 per channel), Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode SPI, 2 channels, MISO lanes 8 (4 per channel), Capture zone 2, SDR

```
make CLK_MODE=0 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 2 channels, MISO lanes 2 (1 per channel), Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 2 channels, MISO lanes 4 (2 per channel), Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 2 channels, MISO lanes 8 (4 per channel), Capture zone 2, SDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=0
```

#### Clock mode Echo, 2 channels, MISO lanes 2 (1 per channel), Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=1 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode Echo, 2 channels, MISO lanes 4 (2 per channel), Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=2 CAPTURE_ZONE=2 DDR_EN=1
```

#### Clock mode Echo, 2 channels, MISO lanes 8 (4 per channel), Capture zone 2, DDR

```
make CLK_MODE=1 NUM_OF_CHANNEL=2 LANES_PER_CHANNEL=4 CAPTURE_ZONE=2 DDR_EN=1
```

#### Unsupported options

Any combination of NUM_OF_CHANNEL=1 and INTERLEAVE_MODE=1. It makes no sense to interleave the data of a single channel.

Any combination of LANES_PER_CHANNEL > 1 and INTERLEAVE_MODE=1. It is necessary a single MISO lane for interleaving.

Any combination of CLK_MODE=0 and DDR_EN=1. The DDR mode is available only valid for echo clock and host clock modes - see MODES REGISTER specification.
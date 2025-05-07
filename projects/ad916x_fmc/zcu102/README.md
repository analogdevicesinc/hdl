# AD916x-FMC/ZCU102 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below.

```
cd projects/ad916x_fmc/zcu102
make
```

All of the TX link modes can be found in the:

- [AD9161/AD9162 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9161-9162.pdf)
- [AD9163 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9163.pdf)
- [AD9164 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9164.pdf)

We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux project configurations.

The overwritable parameters from the environment are:

- ADI_DAC_DEVICE - the target device (AD9161/AD9162/AD9163/AD9164); 
- ADI_LANE_RATE - lane rate of the [TX] link (:warning: must be supported by the device, check the data sheet);
- ADI_DAC_MODE - predefined configuration of JESD M, L, S, F, HD, N, NP parameters based on the no. of lanes (check **common/config.tcl**);
- M - number of converters per link
- L - number of lanes per link
- S - number of samples per converter per frame
- NP - number of bits per sample, only 16 is supported

### Example configurations

#### AD9162, TX mode 08 (default)

This specific command is equivalent to running `make` only:

```
make ADI_DAC_MODE=08 ADI_DAC_DEVICE=AD9162 ADI_LANE_RATE=12.5
``` 

For this mode Lane rate = 12.5 Gbps.

Corresponding device tree: [zynqmp-zcu102-rev10-ad9162-fmc-ebz_m2_s2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9162-fmc-ebz_m2_s2.dts)

#### AD9161, TX mode 08

This specific command is equivalent to running `make` only:

```
make ADI_DAC_MODE=08 ADI_DAC_DEVICE=AD9161 ADI_LANE_RATE=12.5
``` 

For this mode Lane rate = 12.5 Gbps.

Corresponding device tree: [zynqmp-zcu102-rev10-ad9161-fmc-ebz_m2_s2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9161-fmc-ebz_m2_s2.dts)

#### AD9163, TX mode 02, external clock source

```
make ADI_DAC_MODE=02 ADI_DAC_DEVICE=AD9163 ADI_LANE_RATE=12.5
``` 

For this mode Lane rate = 12.5 Gbps.

Corresponding device tree: [zynqmp-zcu102-rev10-ad9163-fmc-ebz_m2_l2_f2_s1.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9163-fmc-ebz_m2_l2_f2_s1.dts)

#### AD9163, TX mode 08

```
make ADI_DAC_MODE=08 ADI_DAC_DEVICE=AD9163 ADI_LANE_RATE=4.16
``` 

For this mode Lane rate = 4.16 Gbps.

Corresponding device tree: [zynqmp-zcu102-rev10-ad9163-fmc-ebz_m2_l8.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9163-fmc-ebz_m2_l8.dts)

#### Target device AD9164, TX mode 08

```
make ADI_DAC_MODE=08 ADI_DAC_DEVICE=AD9164 ADI_LANE_RATE=12.5
``` 

For this mode Lane rate = 12.5 Gbps.

Corresponding device tree: [zynqmp-zcu102-rev10-ad9164-fmc-ebz_m2_s2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9164-fmc-ebz_m2_s2.dts)
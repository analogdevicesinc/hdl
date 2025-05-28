# DAC-FMC-EBZ/ZCU102 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **common/config.tcl** file; it contains the default configuration.

```
cd projects/dac_fmc_ebz/zcu102
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- ADI_DAC_DEVICE: desired device (currently supported: AD9144, AD9154, AD917x); 
- ADI_DAC_MODE: configuration mode of JESD parameters supported by the device (check **common/config.tcl**);
- M: TX number of converters per link
- L: TX number of lanes per link
- S: TX number of samples per converter per frame
- NP: TX number of bits per sample, only 16 is supported

### Example configurations

#### ADI_DAC_DEVICE=AD9172, ADI_DAC_MODE=04 (default)

This specific command is equivalent to running `make` only:

```
make ADI_DAC_DEVICE=AD9172 ADI_DAC_MODE=04
``` 

Corresponding device trees: 
- [zynqmp-zcu102-rev10-ad9172-fmc-ebz-mode4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9172-fmc-ebz-mode4.dts)
- [zynqmp-zcu102-rev10-ad9172-fmc-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9172-fmc-ebz.dts)

#### ADI_DAC_DEVICE=AD9154, ADI_DAC_MODE=00

```
make ADI_DAC_DEVICE=AD9154 ADI_DAC_MODE=00
``` 

Corresponding device tree: [zynqmp-zcu102-rev10-ad9154-fmc-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9154-fmc-ebz.dts)

#### ADI_DAC_DEVICE=AD9144, ADI_DAC_MODE=04

```
make ADI_DAC_DEVICE=AD9154 ADI_DAC_MODE=04
``` 

Corresponding device tree: [zynqmp-zcu102-rev10-ad9144-fmc-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9144-fmc-ebz.dts)
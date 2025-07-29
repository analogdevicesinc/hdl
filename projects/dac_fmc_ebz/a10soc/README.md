<!-- no_no_os -->

# DAC-FMC-EBZ/A10SOC HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **common/config.tcl** file; it contains the default configuration.

```
cd projects/dac_fmc_ebz/a10soc
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- ADI_DAC_DEVICE: **AD9172**; desired device (currently supported: AD9144, AD9154, AD917x); 
- ADI_DAC_MODE: **04**; configuration mode of JESD parameters supported by the device (check **common/config.tcl**);
- L: **4**; TX number of lanes per link

### Example configurations

#### ADI_DAC_DEVICE=AD9172, ADI_DAC_MODE=04 (default)

This specific command is equivalent to running `make` only:

```
make ADI_DAC_DEVICE=AD9172 ADI_DAC_MODE=04
``` 

Corresponding device tree: [socfpga_arria10_socdk_ad9172_fmc.dts](https://github.com/analogdevicesinc/linux/blob/2019_R1_altera/arch/arm/boot/dts/socfpga_arria10_socdk_ad9172_fmc.dts)

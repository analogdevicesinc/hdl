<!-- no_dts, no_no_os -->

# DAC-FMC-EBZ/VCU118 HDL Project

## Building the project

- VADJ with which it was tested in hardware: 1.8V

The parameters configurable through the `make` command, can be found below, as well as in the **common/config.tcl** file; it contains the default configuration.

```
cd projects/dac_fmc_ebz/vcu118
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- ADI_DAC_DEVICE: **AD9172**: desired device (currently supported: AD9144, AD9154, AD917x); 
- ADI_DAC_MODE: **04**; configuration mode of JESD parameters supported by the device (check **common/config.tcl**);
- M: **4**; TX number of converters per link
- L: **4**; TX number of lanes per link
- S: **1**; TX number of samples per converter per frame
- NP: TX number of bits per sample, only 16 is supported

### Example configurations

#### ADI_DAC_DEVICE=AD9172, ADI_DAC_MODE=04 (default)

This specific command is equivalent to running `make` only:

```
make ADI_DAC_DEVICE=AD9172 ADI_DAC_MODE=04
``` 

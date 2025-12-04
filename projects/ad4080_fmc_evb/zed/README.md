<!-- no_build_example, no_no_os -->

# AD4080-FMC-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad4080_fmc_evb/zed
make
```

The overwritable parameters from the environment:

- ADC_N_BITS - Optimizes for the maximum available ADC sample data width.
values:
   - 20 (default required for AD4080) -> 32bit data bus
   - 16 -> 16bit data bus
   - 14 -> 16bit data bus

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/ad4080_fmc_evb/zed
make ADC_N_BITS=20
```

Corresponding device tree: [zynq-zed-adv7511-ad4080.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4080.dts)

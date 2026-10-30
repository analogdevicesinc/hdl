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

- NUM_LANES - LVDS data lanes, 1 or 2 (default 2); a two lane build also runs
  a converter set to one lane
- ENABLE_20BIT, ENABLE_16BIT, ENABLE_14BIT - build the 20, 16 and 14 bit
  datapaths (default 1 each); at least one must be set

The adc_data bus, and the DMA source width, is 32 bits with ENABLE_20BIT, or
with ENABLE_14BIT on two lanes, and 16 bits otherwise.

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/ad4080_fmc_evb/zed
make NUM_LANES=2 ENABLE_20BIT=1 ENABLE_16BIT=1 ENABLE_14BIT=1
```

#### Selected datapaths

```
cd projects/ad4080_fmc_evb/zed
make ENABLE_20BIT=0 ENABLE_14BIT=0
```

Corresponding device tree: [zynq-zed-ad4080.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-ad4080.dts)

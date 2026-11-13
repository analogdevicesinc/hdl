<!-- no_build_example, no_no_os -->

# AD4880-FMC-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project
 - Default configuration (the 20-bit datapath on two lanes)
```
cd projects/ad4880_fmc_evb/zed
make
```
 - The 16-bit and 14-bit datapaths
```
cd projects/ad4880_fmc_evb/zed
make ENABLE_20BIT=0 ENABLE_16BIT=1 ENABLE_14BIT=1
```

The overwritable parameters from the environment:

- NUM_LANES - LVDS data lanes per converter, 1 or 2 (default 2)
- ENABLE_20BIT, ENABLE_16BIT, ENABLE_14BIT - build the 20, 16 and 14 bit
  datapaths (default 1, 0, 0); the 20 bit datapath can not be built together
  with the 16 or 14 bit one

The adc_data bus of each converter is 32 bits with ENABLE_20BIT, or with
ENABLE_14BIT on two lanes, and 16 bits otherwise.

Corresponding device tree: [zynq-zed-ad4880.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-ad4880.dts)

<!-- no_build_example, no_no_os -->

# AD4880-FMC-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project
 - Default configuration (two lanes, all bit depths: 20, 16 and 14)
```
cd projects/ad4880_fmc_evb/zed
make
```
 - Selected datapaths
```
cd projects/ad4880_fmc_evb/zed
make NUM_LANES=1 ENABLE_20BIT=0 ENABLE_16BIT=1 ENABLE_14BIT=1
```

Build parameters:
 - NUM_LANES: LVDS data lanes per converter, 1 or 2 (default 2)
 - ENABLE_20BIT, ENABLE_16BIT, ENABLE_14BIT: build the 20, 16 and 14 bit
   datapaths (default 1 each); at least one must be set

The converter word is 32 bits with ENABLE_20BIT, or with ENABLE_14BIT on two
lanes, and 16 bits otherwise.

Corresponding device tree: [zynq-zed-ad4880.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-ad4880.dts)

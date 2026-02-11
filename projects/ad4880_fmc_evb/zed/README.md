<!-- no_build_example, no_no_os -->

# AD4880-FMC-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project
 - Default configuration (i.e. ADC_N_BITS = 20)
```
cd projects/ad4880_fmc_evb/zed
make
```
 - Different resolution
```
cd projects/ad4880_fmc_evb/zed
make ADC_N_BITS=16
```

All possible values for ADC_N_BITS:
 - 20 (default required for AD4880) -> 32-bit data bus
 - 16 -> 16-bit data bus
 - 14 -> 16-bit data bus

Corresponding device tree: [zynq-zed-adv7511-ad4880.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4880.dts)

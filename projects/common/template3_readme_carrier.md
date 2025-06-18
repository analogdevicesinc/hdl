<!-- Put flags here, i.e. no_build_example, no_dts, no_no_os -->

# EVAL-BOARD/CARRIER HDL Project

- VADJ/VIO with which it was tested in hardware: 3.3V

## Building the project

```
cd projects/adrv9009/a10soc
make
```

This project is not parameterizable, it has a fixed configuration:

- TX_JESD_M: **4**; TX number of converters per link
- TX_JESD_L: **4**; TX number of lanes per link
- TX_JESD_S: **1**; TX number of samples per converter per frame
- RX_JESD_M: **4**; RX number of converters per link
- RX_JESD_L: **2**; RX number of lanes per link
- RX_JESD_S: **1**; RX number of samples per converter per frame
- RX_OS_JESD_M: **2**; RX_OS number of converters per link
- RX_OS_JESD_L: **2**; RX_OS number of lanes per link
- RX_OS_JESD_S: **1**; RX_OS number of samples per converter per frame

RX_OS means RX Observation path.

Corresponding device tree: [socfpga_arria10_socdk_adrv9009_jesd204_fsm.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_adrv9009_jesd204_fsm.dts)

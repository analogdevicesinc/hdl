<!-- no_build_example, no_no_os-->

# ADRV9371X/A10SOC HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/adrv9371x/a10soc
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

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

Corresponding device tree: [socfpga_arria10_socdk_adrv9371.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_adrv9371.dts)

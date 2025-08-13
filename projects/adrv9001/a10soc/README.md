<!-- no_build_example, no_no_os -->

# ADRV9001/A10SOC HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

This project is not parameterizable, it has a fixed configuration that supports only the CMOS interface.

```
cd projects/adrv9001/a10soc
make
```

Corresponding device trees:
- [socfpga_arria10_socdk_adrv9002.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_adrv9002.dts)
- [socfpga_arria10_socdk_adrv9002_rx2tx2.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_adrv9002_rx2tx2.dts)

# ADRV9371X/A10SOC HDL Project

## Building the project

```
cd projects/adrv9371x/a10soc
make
```

All of the RX link modes can be found in the [AD9371 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9371.pdf). We offer support for only one of them.

If other configurations are desired, then the parameters from the HDL project (found in *common/adrv9371x_bd.tcl*) need to be changed, as well as the Linux project configurations.

The overwritable parameters from the environment:

- [TX/RX/RX_OS]_JESD_M: TX: **4**, RX: **4** & RX_OS: **2**; [RX/TX] number of converters per link
- [TX/RX/RX_OS]_JESD_L: TX: **4**, RX: **2** & RX_OS: **2**; [RX/TX] number of lanes per link
- [TX/RX/RX_OS]_JESD_S: TX: **1**, RX: **1** & RX_OS: **1**; [RX/TX] number of samples per converter per frame

Corresponding device tree: [socfpga_arria10_socdk_adrv9371.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_adrv9371.dts)
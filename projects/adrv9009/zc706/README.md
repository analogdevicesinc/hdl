# ADRV9009/ZC706 HDL Project

## Building the project

```
cd projects/adrv9001/zc706
make
```

All of the RX/TX link modes can be found in the [ADRV9009 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (found in *zc706/system_project.tcl*) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- [RX/TX]_JESD_M: RX: **4** & TX: **4**; [RX/TX] number of converters per link
- [RX/TX]_JESD_L: RX: **2** & TX: **4**; [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: RX: **1** & TX: **1**; [RX/TX] number of samples per converter per frame
- RX_OS_JESD_M: **2**; number of converters per link
- RX_OS_JESD_L: **2**; number of lanes per link
- RX_OS_JESD_S: **1**; number of samples per frame

Corresponding device tree: [zynq-zc706-adv7511-adrv9009-jesd204-fsm.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-adrv9009-jesd204-fsm.dts)
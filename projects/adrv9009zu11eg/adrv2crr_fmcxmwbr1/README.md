# ADRV9009ZU11EG/ADRV2CRR-FMCXMWBR1 HDL Project

Aside from the [ADRV9009ZU11EG](https://www.analog.com/adrv9009-zu11eg) SoM attached to the mother board [ADRV2CRR-FMC](https://www.analog.com/adrv2crr-fmc), an extra evaluation board [FMCXMWBR1](https://www.analog.com/ad-fmcxmwbr1-ebz) should be attached on the FMC HPC connecter.

## Building the project

This project is not parameterizable, it has a fixed configuration.

```
cd projects/adrv9009zu11eg/adrv2crr_fmcxmwbr1
make
```

All of the RX/TX link modes can be found in the [ADRV9009 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf). We offer support for only a few of them.

The parameters from the environment:

- [RX/TX]_JESD_M: RX: **8** & TX: **8**; [RX/TX] number of converters per link
- [RX/TX]_JESD_L: RX: **4** & TX: **8**; [RX/TX] number of lanes per link
- [RX/TX]_JESD_S: RX: **1** & TX: **1**; [RX/TX] number of samples per converter per frame
- RX_OS_JESD_M: **4**; number of converters per link
- RX_OS_JESD_L: **4**; number of lanes per link
- RX_OS_JESD_S: **1**; number of samples per frame

Corresponding device tree: [zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm-xmicrowave.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm-xmicrowave.dts)
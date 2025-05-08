# CN0506/A10SOC HDL Project

## Building the project

- Connect on FMC A HPC(V57.1)
- VADJ = 1.8V
- Only the default configuration is supported in MII mode.
- Connected to HPS (EMAC1-PHY0 and EMAC2-PHY1).

```
cd projects/cn0506/a10soc
make
```

Corresponding device trees:
- [socfpga_arria10_socdk_cn0506_mii.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_cn0506_mii.dts)
- [socfpga_arria10_socdk_cn0506_rgmii.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/intel/socfpga/socfpga_arria10_socdk_cn0506_rgmii.dts)
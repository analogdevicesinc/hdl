# M2K HDL Project

- Board product page: [ADALM2000](https://www.analog.com/adalm2000)
- System documentation: https://analogdevicesinc.github.io/documentation/tools/m2k/index.html
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/m2k/index.html
- VIO range can be found here: [M2K](https://wiki.analog.com/university/tools/m2k/devs/intro)

## Supported parts

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9963](https://www.analog.com/ad9963)        | 12-Bit, Low Power, Broadband MxFE                            |

## Building the project

```
cd projects/m2k
make
```

Corresponding device trees:
- [zynq-m2k-revb.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k-revb.dts)
- [zynq-m2k-revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k-revc.dts)
- [zynq-m2k-revd.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k-revd.dts)
- [zynq-m2k-reve.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k-reve.dts)
- [zynq-m2k-revf.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k-revf.dts)
- [zynq-m2k.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-m2k.dts)
- [zynq-zed-adv7511-m2k-revb.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-m2k-revb.dts)
- [zynq-zed-adv7511-m2k-revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-m2k-revc.dts)

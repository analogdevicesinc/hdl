# PLUTO HDL Project

- Evaluation board product page: [ADALM-PLUTO](https://www.analog.com/adalm-pluto)
- System documentation: https://analogdevicesinc.github.io/documentation/tools/pluto/index.html
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/pluto/index.html
- Evaluation board VADJ: 1.8V

## Supported parts

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9363](https://www.analog.com/ad9363)        | Radio frequency (RF) 2 × 2 transceiver with integrated 12-bit DACs and ADCs |                                        |

## Building the project

```
cd projects/pluto
make
```

Corresponding device trees:

- [zynq-pluto-sdr-revb.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-pluto-sdr-revb.dts)
- [zynq-pluto-sdr-revc.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-pluto-sdr-revc.dts)

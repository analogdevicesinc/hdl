# PLUTO HDL Project

- Evaluation board product page: [ADALM-PLUTO](https://www.analog.com/adalm-pluto)
- System documentation: https://wiki.analog.com/university/tools/pluto/users/quick_start
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/pluto/index.html

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

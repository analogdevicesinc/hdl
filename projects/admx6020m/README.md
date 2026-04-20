# ADMX6020M HDL Project

- Evaluation board product page: TO BE ADDED
- System documentation: TO BE ADDED
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/admx6020m/index.html
- Evaluation board VADJ: 2.5V

## Supported parts

| Part name                                      | Description                                                       |
|------------------------------------------------|-------------------------------------------------------------------|
| [HMCAD1520](https://www.analog.com/hmcad1520)  | High Speed Multi-Mode 8/12/14-Bit 1000/640/105 MSPS A/D Converter |

## Building the project

```
cd projects/admx6020m
make
```

Corresponding device trees:

- [ADMX6020M device tree (14-bit)](https://github.com/analogdevicesinc/linux/blob/sharkbyte_pr/arch/arm/boot/dts/xilinx/zynq-admx6020m_14b.dts)
- [ADMX6020M device tree (12-bit)](https://github.com/analogdevicesinc/linux/blob/sharkbyte_pr/arch/arm/boot/dts/xilinx/zynq-admx6020m_12b.dts)
- [ADMX6020M device tree (8-bit)](https://github.com/analogdevicesinc/linux/blob/sharkbyte_pr/arch/arm/boot/dts/xilinx/zynq-admx6020m.dts)
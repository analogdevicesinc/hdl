# AD469X-FMC HDL Project

  * Evaluation board product page: [EVAL-AD4696](https://www.analog.com/eval-ad4696)
  * System documentation: https://wiki.analog.com/resources/eval/user-guides/ad469x
  * HDL project documentation: [source code](../../docs/projects/ad469x_fmc/index.rst)
    or [online](https://analogdevicesinc.github.io/hdl/projects/ad469x_fmc/index.html)

## Supported parts

| Part name                               | Description                                                 |
|-----------------------------------------|-------------------------------------------------------------|
| [AD4696](https://www.analog.com/ad4696) | 16-Bit, 16-Channel, 1 MSPS, Easy Drive Multiplexed SAR ADC  |
| [AD4695](https://www.analog.com/ad4695) | 16-Bit, 16-Channel, 500 kSPS, Easy Drive Multiplexed SAR ADC|
| [AD4697](https://www.analog.com/ad4697) | 16-Bit, 8-Channel, 500 kSPS, Easy Drive Multiplexed SAR ADC |
| [AD4698](https://www.analog.com/ad4698) | 16-Bit, 8-Channel, 1 MSPS, Easy Drive Multiplexed SAR ADC   |

## Building the project

This project is supported only on FPGA Avnet ZedBoard.

How to use overwritable parameter from the environment:

**SPI_4WIRE** - Defines if CNV signal is linked to PWM or to SPI_CS
* 0 - CNV signal is linked to PWM (default option)
* 1 - CNV signal is linked to SPI_CS

```
hdl/projects/ad469x_fmc/zed> make SPI_4WIRE=0
```

# AD719x-ASDZ HDL Project

  * Evaluation board product pages:
    * [EVAL-AD7190](https://www.analog.com/eval-ad7190)
    * [EVAL-AD7193](https://www.analog.com/eval-ad7193)
    * [EVAL-AD7195](https://www.analog.com/eval-ad7195)
  * System documentation: https://wiki.analog.com/resources/eval/adc/ad719x_asdz 
  * HDL project documentation: [source code](../../docs/projects/ad719x_asdz/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/ad719x_asdz/index.html)

## Supported parts

| Part name                               | Resolution | Description                                      |
|-----------------------------------------|:----------:|--------------------------------------------------|
| [AD7190](https://www.analog.com/ad7190) | 24-bit     | 4.8 kHz Ultralow Noise, Sigma-Delta ADC with PGA |
| [AD7193](https://www.analog.com/ad7193) | 24-bit     | 4-Channel, 4.8 kHz, Ultralow Noise, Sigma-Delta ADC with PGA |
| [AD7195](https://www.analog.com/ad7195) | 24-bit     | 4.8 kHz, Ultralow Noise, Sigma-Delta ADC with PGA and AC Excitation |

## Building the project

This project is supported only on FPGA Xilinx Cora Z7S.

```
hdl/projects/ad719x_asdz/cora> make
```
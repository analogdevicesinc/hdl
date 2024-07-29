# AD411x-AD717x HDL project

  * Evaluation board product pages:
    * [EVAL-AD4111-ARDZ](https://www.analog.com/eval-ad4111-ardz)
    * [EVAL-AD4112-ARDZ](https://www.analog.com/eval-ad4112-ardz)
    * [EVAL-AD4114-SDZ](https://www.analog.com/eval-ad4114-sdz)
    * [EVAL-AD4115-SDZ](https://www.analog.com/eval-ad4115-sdz)
    * [EVAL-AD4116-ASDZ](https://www.analog.com/eval-ad4116-asdz)
    * [EVAL-AD7173-8ARDZ](https://www.analog.com/eval-ad7173-8ardz)
    * [EVAL-AD7175-8ARDZ](https://www.analog.com/eval-ad7175-8ardz)
  * System documentation: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
  * HDL project documentation: [source code](../../docs/projects/ad411x_ad717x/index.rst)
    or [online](https://analogdevicesinc.github.io/hdl/projects/ad411x_ad717x/index.html)

## Supported parts

| Part name                                   | Resolution | Description                                                                             |
|---------------------------------------------|:----------:|-----------------------------------------------------------------------------------------|
| [AD4111](https://www.analog.com/ad4111)     | 24-bit     | Single Supply, Sigma-Delta ADC with ±10 V and 0 mA to 20 mA Inputs, Open Wire Detection |
| [AD4112](https://www.analog.com/ad4112)     | 24-bit     | Single Supply, Sigma-Delta ADC with ±10 V and 0 mA to 20 mA Inputs |
| [AD4113](https://www.analog.com/ad4113)     | ?          |  ? |
| [AD4114](https://www.analog.com/ad4114)     |            | Single Supply, Multichannel, 31.25 kSPS, Sigma-Delta ADC with ±10 V Inputs |
| [AD4115](https://www.analog.com/ad4115)     | 24-bit     | Single-Supply, Multichannel, 125 kSPS, Sigma-Delta ADC with ±10 V Inputs |
| [AD4116](https://www.analog.com/ad4116)     | 24-bit     | Single Supply, Sigma-Delta ADC with ±10 V, 10 MΩ Inputs and Buffered Low Level Inputs |
| [AD7172-2](https://www.analog.com/ad7172-2) | 24-bit     | Low Power, 31.25 kSPS, Sigma-Delta ADC with True Rail-to-Rail Buffers |
| [AD7172-4](https://www.analog.com/ad7172-4) | 24-bit     | Low Power,  with 4- or 8-channel, 31.25 kSPS, Sigma-Delta ADC with True Rail-to-Rail Buffers |
| [AD7173-8](https://www.analog.com/ad7173-8) | 24-bit     | Low Power, 8-/16-Channel, 31.25 kSPS, Highly Integrated Sigma-Delta ADC
| [AD7175-2](https://www.analog.com/ad7175-2) | 24-bit     | 250 kSPS, Sigma-Delta ADC with 20 µs Settling and True Rail-to-Rail Buffers |
| [AD7175-8](https://www.analog.com/ad7175-8) | 24-bit     | 8-/16-Channel, 250 kSPS, Sigma-Delta ADC with True Rail-to-Rail Buffers |
| [AD7176-2](https://www.analog.com/ad7176-2) | 24-bit     | 250 kSPS Sigma Delta ADC with 20 µs Settling |
| [AD7177-2](https://www.analog.com/ad7177-2) | 32-bit     | 10 kSPS, Sigma-Delta ADC with 100 µs Settling and True Rail-to-Rail Buffers |

## Building the project

This project is supported only on FPGA Intel DE10-Nano.

```
hdl/projects/ad411x_ad717x/de10nano> make
```
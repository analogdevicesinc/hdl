# PULSAR-ADC HDL Project

  * Evaluation board product page: [EVAL-AD400x-FMCZ](https://www.analog.com/eval-ad400x-fmcz)
  * System documentation: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
  * HDL project documentation: [source code](../../docs/projects/pulsar_adc/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/pulsar_adc/index.html)

## Supported parts

| Part name                                   | Resolution | On CoraZ7S | On Zed | Description                                                      |
|---------------------------------------------|:----------:|:----------:|:------:|------------------------------------------------------------------|
| [AD4000](https://www.analog.com/ad4000)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4001](https://www.analog.com/ad4001)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS, Precision, Differential SAR ADCs |
| [AD4002](https://www.analog.com/ad4002)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4003](https://www.analog.com/ad4003)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs |
| [AD4004](https://www.analog.com/ad4004)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4005](https://www.analog.com/ad4005)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS, Precision, Differential SAR ADCs |
| [AD4006](https://www.analog.com/ad4006)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4007](https://www.analog.com/ad4007)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs |
| [AD4008](https://www.analog.com/ad4008)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4010](https://www.analog.com/ad4010)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |
| [AD4011](https://www.analog.com/ad4011)     | 18-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs |
| [AD4020](https://www.analog.com/ad4020)     | 20-bit     |            | Yes    | 1.8 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs |
| [ADAQ4003](https://www.analog.com/adaq4003) | 18-bit     |            | Yes    | 2 MSPS, Precision DAQ, Differential SAR ADCs |
| [AD7685](https://www.analog.com/ad7685)     | 16-bit     | Yes        |        | 250 kSPS PulSAR ADC in MSOP/QFN |
| [AD7686](https://www.analog.com/ad7686)     | 16-bit     | Yes        |        | 500 kSPS PulSAR A/D Converter in MSOP/QFN |
| [AD7687](https://www.analog.com/ad7687)     | 16-bit     | Yes        |        | 1.5 LSB INL, 250 kSPS PulSAR Differential ADC in MSOP/QFN |
| [AD7688](https://www.analog.com/ad7688)     | 16-bit     | Yes        |        | 500 kSPS Differential PulSAR A/D Converter in µSOIC/QFN |
| [AD7689](https://www.analog.com/ad7689)     | 16-bit     | Yes        |        | 8-Channel, 250 kSPS PulSAR ADC |
| [AD7690](https://www.analog.com/ad7690)     | 18-bit     | Yes        |        | 1.5 LSB INL, 400 kSPS PulSAR Differential ADC in MSOP/QFN |
| [AD7691](https://www.analog.com/ad7691)     | 18-bit     | Yes        |        | 1.5 LSB INL, 250 kSPS PulSAR Differential ADC in MSOP/QFN |
| [AD7693](https://www.analog.com/ad7693)     | 16-bit     | Yes        |        | ±0.5 LSB, 500 kSPS PulSAR Differential A/D Converter in MSOP/QFN |
| [AD7942](https://www.analog.com/ad7942)     | 14-bit     | Yes        |        | 250 kSPS PulSAR, Pseudo Differential ADC in MSOP/LFCSP |
| [AD7946](https://www.analog.com/ad7946)     | 14-bit     | Yes        |        | 500 kSPS PulSAR ADC in MSOP |
| [AD7980](https://www.analog.com/ad7980)     | 16-bit     | Yes        |        | 1 MSPS, PulSAR ADC in MSOP/LFCSP |
| [AD7983](https://www.analog.com/ad7983)     | 16-bit     | Yes        |        | 1.33 MSPS PulSAR ADC in MSOP/LFCSP |
| [AD7988-1](https://www.analog.com/ad7988-1) | 16-bit     | Yes        |        | Lower Power PulSAR ADCs in MSOP/LFCSP |
| [AD7988-5](https://www.analog.com/ad7988-5) | 16-bit     | Yes        |        | Lower Power PulSAR ADCs in MSOP/LFCSP |

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

### CoraZ7S

```
hdl/projects/pulsar_adc/coraz7s> make
```

### Zed

How to use overwritable parameter from the environment:

**AD40XX_ADAQ400X_N** - selects the evaluation board to be used:
  * 1 - EVAL-AD40XX-FMCZ (default option)
  * 0 - EVAL-ADAQ400x

```
// default option (1), building project for EVAL-AD40XX-FMCZ
hdl/projects/pulsar_adc/zed> make AD40XX_ADAQ400X_N

// building project for EVAL-ADAQ400x
hdl/projects/pulsar_adc/zed> make AD40XX_ADAQ400X_N=0
```

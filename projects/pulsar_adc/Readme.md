# PULSAR_ADC HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/eval-ad400x-fmcz)
  * Parts : [AD7942:   14-Bit, 250 kSPS PulSAR, Pseudo Differential ADC in MSOP/LFCSP](https://www.analog.com/ad7942)
  * Parts : [AD7946:   14-Bit, 500 kSPS PulSAR ADC in MSOP](https://www.analog.com/ad7946)
  * Parts : [AD7988-1: 16-Bit Lower Power PulSAR ADCs in MSOP/LFCSP](https://www.analog.com/ad7988-1)
  * Parts : [AD7685:   16-Bit, 250 kSPS PulSAR ADC in MSOP/QFN](https://www.analog.com/ad7685)
  * Parts : [AD7687:   16-Bit, 1.5 LSB INL, 250 kSPS PulSAR Differential ADC in MSOP/QFN](https://www.analog.com/ad7687)
  * Parts : [AD7691:   18-Bit, 1.5 LSB INL, 250 kSPS PulSAR Differential ADC in MSOP/QFN](https://www.analog.com/ad7691)
  * Parts : [AD7686:   500 kSPS 16-BIT PulSAR A/D Converter in MSOP/QFN](https://www.analog.com/ad7686)
  * Parts : [AD7688:   500 kSPS 16- BIT Differential PulSAR A/D Converter in µSOIC/QFN](https://www.analog.com/ad7688)
  * Parts : [AD7693:   16-Bit, ±0.5 LSB, 500 kSPS PulSAR Differential A/D Converter in MSOP/QFN](https://www.analog.com/ad7693)
  * Parts : [AD7988-5: 16-Bit Lower Power PulSAR ADCs in MSOP/LFCSP](https://www.analog.com/ad7988-5)
  * Parts : [AD7980:   16-Bit, 1 MSPS, PulSAR ADC in MSOP/LFCSP](https://www.analog.com/ad7980)
  * Parts : [AD7983:   16-Bit, 1.33 MSPS PulSAR ADC in MSOP/LFCSP](https://www.analog.com/ad7983)
  * Parts : [AD7690:   18-Bit, 1.5 LSB INL, 400 kSPS PulSAR Differential ADC in MSOP/QFN](https://www.analog.com/ad7690)
  * Parts : [AD7689:   16-Bit, 8-Channel, 250 kSPS PulSAR ADC](https://www.analog.com/ad7689)
  * Parts : [AD4000:   16-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4000)
  * Parts : [AD4001:   16-Bit, 2 MSPS/1 MSPS, Precision, Differential SAR ADCs](https://www.analog.com/ad4001)
  * Parts : [AD4002:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4002)
  * Parts : [AD4003:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs](https://www.analog.com/ad4003)
  * Parts : [AD4004:   16-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4004)
  * Parts : [AD4005:   16-Bit, 2 MSPS/1 MSPS, Precision, Differential SAR ADCs](https://www.analog.com/ad4005)
  * Parts : [AD4006:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4006)
  * Parts : [AD4007:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs](https://www.analog.com/ad4007)
  * Parts : [AD4008:   16-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4008)
  * Parts : [AD4010:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs](https://www.analog.com/ad4010)
  * Parts : [AD4011:   18-Bit, 2 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs](https://www.analog.com/ad4011)
  * Parts : [ADAQ4003: 18-Bit, 2 MSPS, Precision DAQ, Differential SAR ADCs](https://www.analog.com/adaq4003)
  * Parts : [AD4020:   20-Bit, 1.8 MSPS/1 MSPS/500 kSPS, Easy Drive, Differential SAR ADCs](https://www.analog.com/ad4020)

  * Project Doc: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/pulsar_adc_pmods_hdl
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/ad7476a

## Supported parts

  * AD7942
  * AD7946
  * AD7988-1
  * AD7685
  * AD7687
  * AD7691
  * AD7686
  * AD7688
  * AD7693
  * AD7988-5
  * AD7980
  * AD7983
  * AD7690
  * AD7982
  * AD7984
  * AD7682
  * AD7689
  * AD4000
  * AD4001
  * AD4002
  * AD4003
  * AD4004
  * AD4005
  * AD4006
  * AD4007
  * AD4008
  * AD4010
  * AD4011
  * ADAQ4003
  * AD4020

build example:
make FMC_N_PMOD=0
make FMC_N_PMOD=1 SPI_OP_MODE=0
make FMC_N_PMOD=1 SPI_OP_MODE=1
make FMC_N_PMOD=1 SPI_OP_MODE=2


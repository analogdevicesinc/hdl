# PULSAR_LVDS_ADC HDL Project

Here are some pointers to help you:
  * [EVAL-AD7626 board Product Page ](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/EVAL-AD7626.html)
  * Parts: [AD7626: 16-Bit, 10 MSPS, PulSAR Differential ADC](https://www.analog.com/ad7626)
  * Parts: [AD7625: 16-Bit, 6  MSPS, PulSAR Differential ADC](https://www.analog.com/ad7625)
  * Parts: [AD7961: 16-Bit, 5  MSPS, PULSAR® Differential ADC](https://www.analog.com/ad7961)
  * Parts: [AD7960: 18-Bit, 5  MSPS, PULSAR® Differential ADC](https://www.analog.com/ad7960)
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/circuits-from-the-lab/cn0577/hdl
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/circuits-from-the-lab/cn0577
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/ltc2387

How to use over-writable parameters from the environment:
```
hdl/projects/pulsar_lvds_adc/zed> make RESOLUTION_16_18N=0
RESOLUTION_16_18N  - Defines the resolution of the ADC: 0 - 18 BITS, 1 - 16 BITS.
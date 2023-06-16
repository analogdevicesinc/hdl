# AD7606X-FMC HDL Project

Here are some pointers to help you:
  * [EVAL-AD7606B Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606b-fmcz.html)
  * [EVAL-AD7606C-16/18 Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606c-18.html)
  * Parts : AD7606B [8 Channels, 16-bit, 800 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606b.html)
  * Parts : AD7606C-16 [8 Channels, 16-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-16.html)
  * Parts : AD7606B [8 Channels, 18-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-18.html)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmcz
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmc/hdl
  * NO-OS Drivers: [AD7606 - No-OS Driver](https://wiki.analog.com/resources/tools-software/uc-drivers/ad7606)
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/axi-adc-hdl
## Building, Generating Bit Files 

IMPORTANT: Set AD7606X device model, ADC Read Mode option and external clock option

How to use over-writable parameters from the environment:
```
hdl/projects/ad7606x_fmc/zed> make DEV_CONFIG=0 SIMPLE_STATUS_CRC=0
DEV_CONFIG  - Defines the device which will be used: 0 - AD7606B, 1 - AD7606C-16, 2 - AD7606C-18.
SIMPLE_STATUS_CRC - Defines the ADC Read Mode option: 0 - Simple, 1 - STATUS, 2 - CRC, 3 - CRC_STATUS.
EXT_CLK - Defines the external clock option for the ADC clock: 0 - No, 1 - Yes.

# AD469X-FMC HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/eval-ad4696)
  * Parts : [AD4696, 16-Bit, 16-Channel, 1 MSPS, Easy Drive Multiplexed SAR ADC](https://www.analog.com/ad4696)
  * Parts : [AD4695, 16-Bit, 16-Channel, 500 kSPS, Easy Drive Multiplexed SAR ADC](https://www.analog.com/ad4695)
  * Parts : [AD4697, 16-Bit, 8-Channel, 500 kSPS, Easy Drive Multiplexed SAR ADC](https://www.analog.com/ad4697)
  * Parts : [AD4698, 16-Bit, 8-Channel, 1 MSPS, Easy Drive Multiplexed SAR ADC](https://www.analog.com/ad4698)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/ad469x
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/ad469x
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers-all
# Building, Generating Bit Files

How to use over-writable parameter from the environment:
```
hdl/projects/ad469x_fmc/zed> make SPI_4WIRE=0
```
SPI_4WIRE - Defines if CNV signal is linked to PWM or to SPI_CS
* 0 - CNV signal is linked to PWM
* 1 - CNV signal is linked to SPI_CS
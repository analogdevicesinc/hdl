# AD738X-FMC HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/eval-ad738xfmcz)
  * Parts : [AD7380, 4MSPS Dual Simultaneous Sampling, 16-BIT SAR ADC, Differential Input](https://www.analog.com/ad7380)
  * Parts : [AD7380-4, 4MSPS Quad, External Reference Simultaneous Sampling, 16-Bit, SAR ADC, Differential Input](https://www.analog.com/ad7380-4)
  * Parts : [AD7381, 4MSPS Dual Simultaneous Sampling, 14-BIT SAR ADC, Differential Input](https://www.analog.com/ad7381)
  * Parts : [AD7381-4, 4MSPS Quad, 14-Bit, Simultaneous Sampling, SAR ADC, Differential Input](https://www.analog.com/ad7381-4)
  * Parts : [AD7383-4, 4MSPS Quad, Simultaneous Sampling, 16-Bit, SAR ADC, Pseudo Differential Input](https://www.analog.com/ad7383-4)
  * Parts : [AD7384-4, 4MSPS Quad, Simultaneous Sampling, 14-Bit, SAR ADC, Pseudo Differential Input](https://www.analog.com/ad7384-4)
  * Parts : [AD7386, 4-Channel, 4 MSPS, 16-Bit Dual Simultaneous Sampling SAR ADC](https://www.analog.com/ad7386)
  * Parts : [AD7387, 4-Channel, 4 MSPS, 14-Bit, Dual, Simultaneous Sampling SAR ADC](https://www.analog.com/ad7387)
  * Parts : [AD7388, 4-Channel, 4 MSPS, 12-Bit, Dual, Simultaneous Sampling SAR ADCs](https://www.analog.com/ad7388)
  * Parts : [AD7389-4, 4MSPS Quad, Internal Reference Simultaneous Sampling, 16-Bit SAR ADC, Differential Input](https://www.analog.com/ad7389-4)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/ad738x
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/ad738x
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/ad738x
# Building, Generating Bit Files

How to use over-writable parameters from the environment:
```
hdl/projects/ad738x_fmc/zed> make ALERT_SPI_N=0 NUM_OF_SDI=4
```

SDOB-SDOD/ALERT pin can operate as a serial data output pin or alert indication output depending on its value:
* 0 - SDOB-SDOD
* 1 - ALERT

NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4

For the ALERT functionality, the following parameters will be used in make command: ALERT_SPI_N
For the serial data output functionality, the following parameters will be used in make command: ALERT_SPI_N, NUM_OF_SDI

**Example:**
```
make ALERT_SPI_N=0 NUM_OF_SDI=1
make ALERT_SPI_N=0 NUM_OF_SDI=2
make ALERT_SPI_N=0 NUM_OF_SDI=4
make ALERT_SPI_N=1
```

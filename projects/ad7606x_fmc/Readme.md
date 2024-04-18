# AD7606X-FMC HDL Project

Here are some pointers to help you:
  * [EVAL-AD7606B Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606b-fmcz.html)
  * [EVAL-AD7606C-16/18 Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606c-18.html)
  * Parts : [AD7606B, 8 Channels, 16-bit, 800 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606b.html)
  * Parts : [AD7606B, 8 Channels, 18-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-18.html)
  * Parts : [AD7606C-16, 8 Channels, 16-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-16.html)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmcz
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmc/hdl
  * NO-OS Drivers: [AD7606 - No-OS Driver](https://wiki.analog.com/resources/tools-software/uc-drivers/ad7606)
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/axi-adc-hdl
## Building, Generating Bit Files 

IMPORTANT: Set AD7606X device model, ADC Read Mode option and external clock option

How to use over-writable parameters from the environment:
```
hdl/projects/ad7606x_fmc/zed> make DEV_CONFIG=2 INTF=1 NUM_OF_SDI=4
DEV_CONFIG  - Defines the device which will be used: 0 - AD7606B, 1 - AD7606C-16, 2 - AD7606C-18.
INTF - Defines the operation interface: 0 - Parallel, 1 - Serial
NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4, 8
EXT_CLK - Defines the external clock option for the ADC clock: 0 - No, 1 - Yes.

For the serial interface, the following parameters will be used in make command: DEV_CONFIG, INTF, NUM_OF_SDI.
For the parallel interface, the following parameters will be used in make command: DEV_CONFIG, INTF,EXT_CLK.

**Example:**

make DEV_CONFIG=0 INTF=1 NUM_OF_SDI=1
make DEV_CONFIG=1 INTF=1 NUM_OF_SDI=2
make DEV_CONFIG=2 INTF=1 NUM_OF_SDI=1
make DEV_CONFIG=2 INTF=1 NUM_OF_SDI=2
make DEV_CONFIG=2 INTF=1 NUM_OF_SDI=4
make DEV_CONFIG=2 INTF=1 NUM_OF_SDI=8
make DEV_CONFIG=0 INTF=0 EXT_CLK=0
make DEV_CONFIG=1 INTF=0 EXT_CLK=0
make DEV_CONFIG=2 INTF=0 EXT_CLK=0
...
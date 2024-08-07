# AD7606X-FMC HDL Project

Here are some pointers to help you:
  * [EVAL-AD7606B Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606b-fmcz.html)
  * [EVAL-AD7606C-16/18 Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606c-18.html)
  * [EVAL-AD7605-4 Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7605-4.html)
  * [EVAL-AD7606-8/6/4 Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7606.html)
  * [EVAL-AD7607 Product Page](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7607.html)
  * [EVAL-AD7608 Product Page](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7608.html)
  * [EVAL-AD7609 Product Page](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/eval-ad7609.html)
  * Parts : [AD7606B, 8 Channels, 16-bit, 800 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606b.html)
  * Parts : [AD7606C-16, 8 Channels, 16-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-16.html)
  * Parts : [AD7606C-18, 8 Channels, 18-bit, 1 MSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606c-18.html)
  * Parts : [AD7605-4, 4 Channels, 16-bit, 300 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7605-4.html)
  * Parts : [AD7606, 8 Channels, 16-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606.html)
  * Parts : [AD7606-6, 6 Channels, 16-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606-6.html)
  * Parts : [AD7606-4, 4 Channels, 16-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7606-4.html)
  * Parts : [AD7607, 8 Channels, 14-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7607.html)
  * Parts : [AD7608, 8 Channels, 18-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7608.html)
  * Parts : [AD7609, 8 Channels, 18-bit, 200 kSPS Bipolar Input, Simultaneous sampling ADC](https://www.analog.com/en/products/ad7609.html)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmcz
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/ad7606x-fmc/hdl
  * NO-OS Drivers: [AD7606 - No-OS Driver](https://wiki.analog.com/resources/tools-software/uc-drivers/ad7606)
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/axi-adc-hdl
## Building, Generating Bit Files

IMPORTANT: Set AD7606X device model, ADC Read Mode option and external clock option

How to use over-writable parameters from the environment:
```
hdl/projects/ad7606x_fmc/zed> make INTF=1 NUM_OF_SDI=4
INTF - Defines the operation interface: 0 - Parallel, 1 - Serial
NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4, 8
ADC_N_BITS - Specifies the ADC resolution: 16 or 18 bits; only for the Parallel Interface

For the serial interface, the following parameters will be used in make command: INTF, NUM_OF_SDI.
For the parallel interface, the following parameters will be used in make command: INTF, ADC_N_BITS.

**Example:**

make INTF=0 ADC_N_BITS=16
make INTF=0 ADC_N_BITS=18
make INTF=1 NUM_OF_SDI=1
make INTF=1 NUM_OF_SDI=2
make INTF=1 NUM_OF_SDI=4
make INTF=1 NUM_OF_SDI=8

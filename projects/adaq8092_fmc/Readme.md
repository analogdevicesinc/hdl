# ADAQ8092_FMC HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/adaq8092)
  * Parts : [2 Channels, 14-Bit, 105 MSPS, Analog-to-Digital Converter](https://www.analog.com/adaq8092)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/adaq8092/quickstart/zedboard
  * HDL Doc: https://wiki.analog.com/resources/fpga/docs/adaq8092
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-adc/axi-adc-hdl

## Building, Generating Bit Files 

IMPORTANT: Set ADAQ8092 output mode 

How to use over-writable parameters from the environment:
```
hdl/projects/adaq8092_fmc/zed> make OUTPUT_MODE=LVDS
```
OUTPUT_MODE  - Defines the output mode LVDS or CMOS.

NOTE : This switch is a 'hardware' switch. Please reimplenent the design if the variable has been changed.
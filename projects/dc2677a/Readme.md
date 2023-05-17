# DC2677A HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/dc2677a.html)
  * Parts : [Buffered Octal, 18-Bit, 200ksps/Ch Differential ±10.24V ADC with 30VP-P Common Mode Range](https://www.analog.com/en/products/ltc2358-18.html)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/dc2677a
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/dc2677a
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers-all

## Supported parts
  * LTC2358-18
  * LTC2358-16
  * LTC2357-18
  * LTC2357-16
  * LTC2353-18
  * LTC2353-16

## Project Parameters

LVDS_CMOS_N:
  * 0 - CMOS (default)
  * 1 - LVDS

LTC235X_FAMILY:
  * 0 = 2358-18 (default)
  * 1 = 2358-16
  * 2 = 2357-18
  * 3 = 2357-16
  * 4 = 2353-18
  * 5 = 2353-16

### How to build
e.g, to build the project for **LTC2358-18** using the **CMOS Interface**
```
make LVDS_CMOS_N=0 LTC235X_FAMILY=0
```

# AD57XX-ARDZ HDL Project

Here are some pointers to help you:
  * [EVAL-AD5780ARDZ Board Product Page](https://www.analog.com/EVAL-AD5780ARDZ)
  * [EVAL-AD5781ARDZ Board Product Page](https://www.analog.com/EVAL-AD5781ARDZ)
  * [EVAL-AD5791ARDZ Board Product Page](https://www.analog.com/EVAL-AD5791ARDZ)
  * Parts : [AD5760, Ultra Stable 16-Bit ±0.5 LSB INL, Voltage Output DAC ](https://www.analog.com/ad5760)
  * Parts : [AD5780, System Ready, 18-Bit ±1 LSB INL, Voltage Output DAC C](https://www.analog.com/ad5780)
  * Parts : [AD5781, True 18-Bit, Voltage Output DAC ±0.5 LSB INL, ±0.5 LSB DNL ](https://www.analog.com/ad5781)
  * Parts : [AD5790, System Ready 20-Bit, ±2 LSB INL, Voltage Output DAC ](https://www.analog.com/ad5790)
  * Parts : [AD5791, 1 ppm, 20-Bit, ±1 LSB INL, Voltage Output DAC](https://www.analog.com/ad5791)
  * Project Doc: https://analogdevicesinc.github.io/hdl/projects/ad57xx_ardz/index.html
  * HDL Doc: https://analogdevicesinc.github.io/hdl/projects/ad57xx_ardz/index.html
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers-all

  ## Building, Generating Bit Files

**Example: generating projects for all carriers**
```
hdl/projects/ad57xx_ardz> make
```

**Example: generating project for coraz7s**
```
hdl/projects/ad57xx_ardz> cd coraz7s
hdl/projects/ad57xx_ardz/coraz7s> make
```

**Example: generating project for de10nano**
```
hdl/projects/ad57xx_ardz> cd de10nano
hdl/projects/ad57xx_ardz/de10nano> make
```

# AD738x-FMC HDL Project

  * Evaluation board product page: [EVAL-AD738x-FMCZ](https://www.analog.com/eval-ad738xfmcz)
  * System documentation: https://wiki.analog.com/resources/eval/user-guides/ad738x
  * HDL project documentation: [source code](../../docs/projects/ad738x_fmc/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/ad738x_fmc/index.html)

## Supported parts

| Part name                                   | Resolution | Description                                                      |
|---------------------------------------------|:----------:|------------------------------------------------------------------|
| [AD7380](https://www.analog.com/ad7380)     | 16-bit     | 4MSPS Dual Simultaneous Sampling, SAR ADC, Differential Input |
| [AD7380-4](https://www.analog.com/ad7380-4) | 16-bit     | 4MSPS Quad, External Reference Simultaneous Sampling, SAR ADC, Differential Input |
| [AD7381](https://www.analog.com/ad7381)     | 14-bit     | 4MSPS Dual Simultaneous Sampling, SAR ADC, Differential Input |
| [AD7381-4](https://www.analog.com/ad7381-4) | 14-bit     | 4MSPS Quad, Simultaneous Sampling, SAR ADC, Differential Input |
| [AD7383-4](https://www.analog.com/ad7383-4) | 16-bit     | 4MSPS Quad, Simultaneous Sampling, SAR ADC, Pseudo Differential Input |
| [AD7384-4](https://www.analog.com/ad7384-4) | 14-bit     | 4MSPS Quad, Simultaneous Sampling, SAR ADC, Pseudo Differential Input |
| [AD7386](https://www.analog.com/ad7386)     | 16-bit     | 4-Channel, 4 MSPS, Dual Simultaneous Sampling SAR ADC |
| [AD7387](https://www.analog.com/ad7387)     | 14-bit     | 4-Channel, 4 MSPS, Dual, Simultaneous Sampling SAR ADC |
| [AD7388](https://www.analog.com/ad7388)     | 12-bit     | 4-Channel, 4 MSPS, Dual, Simultaneous Sampling SAR ADCs |
| [AD7389-4](https://www.analog.com/ad7389-4) | 16-bit     | 4MSPS Quad, Internal Reference Simultaneous Sampling, SAR ADC, Differential Input |

## Building the project

This project is supported only on FPGA Avnet ZedBoard.

How to use overwritable parameters from the environment:

**ALERT_SPI_N** - SDOB-SDOD/ALERT pin can operate as a serial data output pin or alert indication output depending on its value:
  * 0 - SDOB-SDOD (default option)
  * 1 - ALERT

**NUM_OF_SDI** - defines the number of SDI lines used:
  * 1 (default option)
  * 2
  * 4

> [!NOTE]
> * For the ALERT functionality, the following parameters will be used in make command: ALERT_SPI_N
> * For the serial data output functionality, the following parameters will be used in make command: ALERT_SPI_N, NUM_OF_SDI

```
// default configuration
hdl/projects/ad738x_fmc/zed> make

// pin is in SDOB-SDOD and 4 lines of SDI are used
hdl/projects/ad738x_fmc/zed> make ALERT_SPI_N=0 NUM_OF_SDI=4
```

### Example configurations

```
make ALERT_SPI_N=0 NUM_OF_SDI=1
make ALERT_SPI_N=0 NUM_OF_SDI=2
make ALERT_SPI_N=0 NUM_OF_SDI=4
make ALERT_SPI_N=1
```


# EVAL-AD463x_FMCZ HDL reference design

## Building the design

The design supports almost all the digital interface modes of AD4630-24, a new
bit stream should be generated each time when the targeted configuration changes.
**NOTE:** Interleaved mode (SPI hase one MISO lines) is supported only in SPI clock mode.

Default configuration: generic SPI mode for clocking, 2 lanes per channel, SDR 
data capture and second capture zone is used to pull out data from the converter. 

### Building attributes

|  Attribute name |                Valid values                       |
| --------------- | ------------------------------------------------- |
|  CLK_MODE       |  0 - SPI / 1 - Echo-clock or Master clock         |
|  NUM_OF_SDI     |  1 - Interleaved / 2 - 1LPC / 4 - 2LPC / 8 - 4LPC |
|  CAPTURE_ZONE   |  1 - negedge of BUSY / 2 - next posedge of CNV    |
|  DDR_EN         |  0 - MISO runs on SDR / 1 - MISO runs on DDR      |

**Example:** make NUM_OF_SDI=2 CAPTURE_ZONE=2

## Documantation

https://wiki.analog.com/resources/eval/user-guides/ad436x/hdl


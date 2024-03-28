
# EVAL-AD463X_FMCZ HDL reference design

## Building the design

The design supports almost all the digital interface modes of AD463x, AD403x 
and adaq42xx a new bit stream should be generated each time when the targeted 
configuration changes.

Default configuration: generic SPI mode for clocking, 2 lanes per channel, SDR 
data capture and capture zone 2. 

### Building attributes

|  Attribute name |                Valid values                       |
| --------------- | ------------------------------------------------- |
|  CLK_MODE       |  0 - SPI / 1 - Echo-clock or Master clock         |
|  NUM_OF_SDI     |  1 - Interleaved / 2 - 1LPC / 4 - 2LPC / 8 - 4LPC |
|  CAPTURE_ZONE   |  1 - negedge of BUSY / 2 - next posedge of CNV    |
|  DDR_EN         |  0 - MISO runs on SDR / 1 - MISO runs on DDR      |

**Example:** 
  make CLK_MODE=0 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=0 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=0 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=0
  make CLK_MODE=1 NUM_OF_SDI=2 CAPTURE_ZONE=2 DDR_EN=1
  make CLK_MODE=1 NUM_OF_SDI=4 CAPTURE_ZONE=2 DDR_EN=1
  make CLK_MODE=1 NUM_OF_SDI=8 CAPTURE_ZONE=2 DDR_EN=1

## Documentation

https://wiki.analog.com/resources/eval/user-guides/ad463x/hdl


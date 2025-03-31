# AD485x HDL Project

  * Evaluation board product page: [EVAL-AD4858](https://www.analog.com/eval-ad4858)
  * System documentation: https://wiki.analog.com/resources/eval/user-guides/ad4858_fmcz/ad4858_fmcz_hdl
  * HDL project documentation: [source code](../../docs/projects/ad485x_fmcz/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/ad485x_fmcz/index.html)

## Supported parts

| Part name                               | No. of lanes | Resolution | Description                                           |
|-----------------------------------------|:------------:|:----------:|-------------------------------------------------------|
| [AD4858](https://www.analog.com/ad4858) | 8            | 20-bit     | Buffered, 8-Channel Simultaneous Sampling, 1 MSPS DAS |
| [AD4857](https://www.analog.com/ad4857) | 8            | 16-bit     | Buffered, 8-Channel Simultaneous Sampling, 1 MSPS DAS |
| AD4856                                  | 8            | 20-bit     | Buffered, 8-Channel Simultaneous Sampling, 250 kSPS DAS |
| AD4855                                  | 8            | 16-bit     | Buffered, 8-Channel Simultaneous Sampling, 250 kSPS DAS |
| AD4854                                  | 4            | 20-bit     | Buffered, 4-Channel Simultaneous Sampling, 1 MSPS DAS |
| AD4853                                  | 4            | 16-bit     | Buffered, 4-Channel Simultaneous Sampling, 1 MSPS DAS |
| AD4852                                  | 4            | 20-bit     | Buffered, 4-Channel Simultaneous Sampling, 250 kSPS DAS |
| AD4851                                  | 4            | 16-bit     | Buffered, 4-Channel Simultaneous Sampling, 250 kSPS DAS |

## Building the project

This project is supported only on FPGA Avnet ZedBoard.

How to use overwritable parameters from the environment:

**LVDS_CMOS_N**:
  * 0 - CMOS (default option)
  * 1 - LVDS

**DEVICE**:
  * AD4858 (default option)
  * AD4857
  * AD4856
  * AD4855
  * AD4854
  * AD4853
  * AD4852
  * AD4851

```
// default option is AD4858 and CMOS
hdl/projects/ad485x_fmcz/zed> make

// selected device is AD4857 and CMOS
hdl/projects/ad485x_fmcz/zed> make DEVICE=AD4857

// selected device is AD4858 and LVDS
hdl/projects/ad485x_fmcz/zed> make DEVICE=AD4858 LVDS_CMOS_N=1
```
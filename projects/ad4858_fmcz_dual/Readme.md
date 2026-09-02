# AD4858-FMCZ-DUAL HDL Project

- Evaluation boards product pages:
  - [EVAL-AD4858](https://www.analog.com/eval-ad4858)

- System documentation: https://wiki.analog.com/resources/eval/user-guides/ad4858_fmcz/ad4858_fmcz_hdl
- HDL project documentation: http://analogdevicesinc.github.io/hdl/projects/ad4858_fmcz_dual/index.html
- Evaluation board VADJ range: 1.8V - 3.3V

:warning: Make sure the power supplies on the evaluation board are configured as expected, from jumper selection. In particular, pay attention to JVIO to be equal to VADJ, otherwise you risk damaging the FPGA and EVAL-AD4858 board.

## Supported parts

| Part name                               | Resolution | Description                                      |
|-----------------------------------------|:----------:|--------------------------------------------------|
| [AD4858](https://www.analog.com/ad4858) | 20-bit     | Buffered, 8-Channel Simultaneous Sampling, 1 MSPS DAS |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

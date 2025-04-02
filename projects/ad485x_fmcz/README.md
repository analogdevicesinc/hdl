# AD485X-FMCZ HDL Project

- Evaluation boards product pages:
  - [EVAL-AD4857](https://www.analog.com/eval-ad4857)
  - [EVAL-AD4858](https://www.analog.com/eval-ad4858)

- System documentation: https://wiki.analog.com/resources/eval/user-guides/ad4858_fmcz/ad4858_fmcz_hdl
- HDL project documentation: http://analogdevicesinc.github.io/hdl/projects/ad585x_fmcz/index.html
- Evaluation board VADJ range: 1.8V - 3.3V

:warning: Make sure the power supplies on the evaluation board are configured as expected, from jumper selection. In particular, pay attention to JVIO to be equal to VADJ, otherwise you risk damaging the FPGA and EVAL-AD485x board.

## Supported parts

| Part name                               | Resolution | Description                                      |
|-----------------------------------------|:----------:|--------------------------------------------------|
| [AD4851](https://www.analog.com/ad4851) | 16-bit     | Buffered, 4-Channel Simultaneous Sampling, 250kSPS DAS |
| [AD4852](https://www.analog.com/ad4852) | 20-bit     | Buffered, 4-Channel Simultaneous Sampling, 250kSPS DAS |
| [AD4853](https://www.analog.com/ad4853) | 16-bit     | Buffered, 4-Channel Simultaneous Sampling, 1MSPS DAS |
| [AD4854](https://www.analog.com/ad4854) | 20-bit     | Buffered, 4-Channel Simultaneous Sampling, 1MSPS DAS|
| [AD4855](https://www.analog.com/ad4855) | 16-bit     | Buffered, 8-Channel Simultaneous Sampling, 250 kSPS DAS |
| [AD4856](https://www.analog.com/ad4856) | 20-bit     | Buffered, 8-Channel Simultaneous Sampling, 250 kSPS DAS|
| [AD4857](https://www.analog.com/ad4857) | 16-bit     | Buffered, 8-Channel Simultaneous Sampling, 1 MSPS DAS |
| [AD4858](https://www.analog.com/ad4858) | 20-bit     | Buffered, 8-Channel Simultaneous Sampling, 1 MSPS DAS |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

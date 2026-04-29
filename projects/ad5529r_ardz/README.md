# AD5529R-ARDZ HDL Project

## Supported parts

| Part name                                 | Description                                                  |
|-------------------------------------------|--------------------------------------------------------------|
| [AD5529R](https://www.analog.com/ad5529r) | 16-Channel, 16-Bit Voltage Output DAC, ±1 LSB INL, ±25 mA    |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

## Documentation

- [AD5529R Product Page](https://www.analog.com/ad5529r)
- Evaluation boards product pages:
    - [EVAL-AD5529 Product Page](https://www.analog.com/eval-ad5529r) - evaluation board VIO: 3.3V
- [HDL project documentation](https://analogdevicesinc.github.io/hdl/projects/ad5529r)
- [Build environment setup](https://analogdevicesinc.github.io/hdl/user_guide/build_hdl.html)

## Architecture

This project uses the ADI SPI Engine for high-throughput DAC streaming:

- **SPI Engine**: 16-bit data width, offload with streaming enabled
- **DMA**: Memory-to-stream for waveform playback
- **PWM Generators**: Trigger (SPI) + Toggle pins (TG0-TG3)
- **Clock Generator**: 140 MHz reference for 35 MHz SCLK

# AD9213/VCU118 HDL Project

## Building the project

```
cd projects/ad9213_evb/vcu118
make
```

The RX link mode can be found in the [AD9213 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9213.pdf).

This project is not parameterizable, it has a fixed configuration.

The parameters from the environment:

- RX_NUM_OF_CONVERTERS: **1**; RX number of converters per link
- RX_NUM_OF_LANES: **16**; RX number of lanes per link
- RX_SAMPLES_PER_FRAME: **16**; RX number of samples per converter per frame
- RX_JESD_NP: **16**; RX number of bits per sample
- RX_SAMPLE_WIDTH: **16**; RX data width
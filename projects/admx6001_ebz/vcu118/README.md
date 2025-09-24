<!-- no_build_example, no_no_os -->

# ADMX6001-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/admx6001_ebz/vcu118
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

Corresponding device tree: [vcu118-admx6001-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_admx6001_ebz.dts)

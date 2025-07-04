<!-- no_build_example, no_dts -->

# AD9656-FMC/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/ad9656_fmc/zcu102
make
```

All of the RX link modes can be found in the [AD9656 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9656.pdf). We offer support for one of them.

This project is not parameterizable, it has a fixed configuration:

- JESD_MODE - link layer encoder mode used; 
  - **8B10B** - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
- RX_JESD_M - **4**; RX number of converters per link
- RX_JESD_L - **4**; RX number of lanes per link
- RX_JESD_S - **1**; RX number of samples per converter per frame
- RX_JESD_NP - **16**; RX number of bits per sample
- RX_SAMPLES_PER_CHANNEL - **2**; RX number of samples per channel (Computed as: L * 32 / (M * N))

Corresponding No-OS project: [ad9656_fmc](https://github.com/analogdevicesinc/no-OS/tree/main/projects/ad9656_fmc)

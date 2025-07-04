<!-- no_build_example, no_no_os, no_dts -->

# AD9213-DUAL-EBZ/S10SOC HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/ad9213_dual_ebz/s10soc
make
```

All of the RX/TX link modes can be found in the [AD9213 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9213.pdf), Table 25. We offer support for only one of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The available configuration:

- JESD_MODE: link layer encoder mode used; 
  - 8B10B - 8b10b link layer defined in JESD204B
- RX_JESD_M: **1**; RX number of converters per link
- RX_JESD_L: **16**; RX number of lanes per link
- RX_JESD_S: **16**; RX number of samples per converter per frame
- RX_JESD_NP: **16**; RX number of bits per sample, only 16 is supported

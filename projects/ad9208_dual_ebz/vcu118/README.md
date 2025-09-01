<!-- no_build_example, no_no_os -->

# AD9208-DUAL-EBZ/VCU118 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/ad9208_dual_ebz/vcu118
make
```

All of the RX link modes can be found in the [AD9208 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9208.pdf), Table 33. We offer support for only one of them.

If other configurations are desired, then the parameters from the HDL project (found in *common/ad9208_dual_ebz_bd.tcl*) need to be changed, as well as the Linux/no-OS project configurations.

The fixed configuration:

- JESD_MODE: link layer encoder mode used;
  - 8B10B - 8b10b link layer defined in JESD204B
- RX_JESD_M: **2**; RX number of converters per link
- RX_JESD_L: **8**; RX number of lanes per link
- RX_JESD_S: **2**; RX number of samples per converter per frame
- RX_JESD_NP: **16**; RX number of bits per sample
- RX_KS_PER_CHANNEL: **8**; RX number of samples stored in internal buffers in kilosamples per converter (M), for each channel in a block RAM, for a contiguous capture

Corresponding device tree: [vcu118_dual_ad9208.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_dual_ad9208.dts)

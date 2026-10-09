<!-- no_build_example, no_dts, no_no_os -->

# AD9084-EBZ/NIOS_A5E HDL Project

- VADJ with which it was tested in hardware: 1.2V

This is the NIOS-V/g variant of the Agilex 5 E-series project. The
[a5e](../a5e/README.md) project runs the same design on the HPS; here the
control plane is a soft NIOS-V/g core, which has no MMU, so the design is
bare-metal and takes its software over JTAG (`niosv-download`) instead of from
the bitstream. Application `stdout` comes back over the JTAG UART
(`juart-terminal`).

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

:warning: **When changing the default configuration, the system_constr.sdc constraints should be updated as well!**

```
cd projects/ad9084_ebz/nios_a5e
make
```

All of the RX/TX link modes can be found in the [AD9084 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/eval-ad9084-ug-2326.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE : Used link layer encoder mode
  - 64B66B - 64b66b link layer defined in JESD 204C
  - 8B10B  - 8b10b link layer defined in JESD 204B
- REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
- DEVICE_CLK_RATE : Device clock frequency in MHz, usually the same as REF_CLK_RATE but it can vary based on the JESD configuration
- RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
- TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
- [RX/TX]_JESD_M : Number of converters per link
- [RX/TX]_JESD_L : Number of lanes per link
- [RX/TX]_JESD_S : Number of samples per frame
- [RX/TX]_JESD_NP : Number of bits per sample
- [RX/TX]_NUM_LINKS : Number of links
- [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)

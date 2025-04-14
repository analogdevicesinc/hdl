# DAQ3/VCU118 HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/daq3/vcu118
make
```

This device operates in single link JESD204B mode, meaning 8b10b link layer encoding, using the ADI IP as Physical layer.

All of the RX link modes can be found in the [AD9680 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9680.pdf), Tables 26. We offer support for only a few of them.

All of the TX link modes can be found in the [AD9152 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD9152.pdf), Table 33 and 43. We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment are:

- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame

### Example configurations

#### TX mode 04, RX mode 0x88 (default)

This specific command is equivalent to running `make` only:

```
make RX_JESD_M=2 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=2 \
TX_JESD_L=4 \
TX_JESD_S=1
```

Corresponding device tree: [vcu118_fmcdaq3.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_fmcdaq3.dts)

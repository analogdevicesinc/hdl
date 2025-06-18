# AD6676-EVB/VC707 HDL Project

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad6676evb/vc707
make
```

All of the RX link modes can be found in the [AD6676 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/AD6676.pdf). We offer support for only one of them.

If other configurations are desired, then the parameter from the HDL project (see below) needs to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameter from the environment:

- [RX/TX]_JESD_L: [RX/TX] number of lanes per link

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make RX_JESD_L=2
```

Corresponding device tree: [vc707_ad6676evb.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vc707_ad6676evb.dts)

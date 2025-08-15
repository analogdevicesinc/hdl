<!-- no_no_os -->

# AD9695-FMC/ZCU102 HDL Project

:warning: For the 625MSPS variant, additional changes need to be done, which currently are not supported by our reference design!

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9695_fmc/zcu102
make
```

All of the RX/TX link modes can be found in the [AD9695 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9695.pdf), Table 35. We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

:warning: To have multichip synchronization, we will be treating the two links as one, thus L and M parameters are doubled!

The overwritable parameters from the environment:

- JESD_MODE: link layer encoder mode used; 
  - 8B10B - 8b10b link layer defined in JESD204B
- RX_JESD_M: RX number of converters
- RX_JESD_L: RX number of lanes
- RX_JESD_S: RX number of samples per converter per frame

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make RX_JESD_M=2 \
RX_JESD_L=4 \
RX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9695.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9695.dts)

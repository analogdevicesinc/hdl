<!-- no_no_os -->

# AD9083-EVB/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/ad9083_evb/zcu102
make
```

All of the RX link modes can be found in the [AD9083 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9083.pdf). We offer support for only a few of them.

The overwritable parameters from the environment:

- RX_JESD_L - RX number of lanes per link
- RX_JESD_M - RX number of converters per link
- RX_JESD_S - RX number of samples per converter per frame

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make RX_JESD_L=4 \
RX_JESD_M=16 \
RX_JESD_S=1
```

Corresponding device tree: [zynqmp-zcu102-rev10-ad9083-fmc-ebz.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9083-fmc-ebz.dts)

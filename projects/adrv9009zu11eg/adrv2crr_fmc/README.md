<!-- no_no_os -->

# ADRV9009ZU11EG/ADRV2CRR-FMC HDL Project

Attach the [ADRV9009ZU11EG](https://www.analog.com/adrv9009-zu11eg) SoM to the mother board [ADRV2CRR-FMC](https://www.analog.com/adrv2crr-fmc).

- VADJ with which it was tested in hardware: 1.8V

## Building the project

```
cd projects/adrv9009zu11eg/adrv2crr_fmc
make
```

All of the RX/TX link modes can be found in the [ADRV9009 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADRV9009.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (found in *adrv2crr_fmc/system_project.tcl*) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment are:

- [RX/TX/RX_OS]_JESD_M: [RX/TX/RX_OS] number of converters per link
- [RX/TX/RX_OS]_JESD_L: [RX/TX/RX_OS] number of lanes per link
- [RX/TX/RX_OS]_JESD_S: [RX/TX/RX_OS] number of samples per converter per frame

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make RX_JESD_M=8 \
RX_JESD_L=4 \
RX_JESD_S=1 \
TX_JESD_M=8 \
TX_JESD_L=8 \
TX_JESD_S=1 \
RX_OS_JESD_M=4 \
RX_OS_JESD_L=4 \
RX_OS_JESD_S=1
```

Corresponding device tree: [zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-adrv9009-zu11eg-revb-adrv2crr-fmc-revb-jesd204-fsm.dts)

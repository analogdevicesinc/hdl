# ADRV9371X/KCU105 HDL Project

## Building the project

```
cd projects/adrv9371x/kcu105
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- [TX/RX/RX_OS]_JESD_M: [RX/TX] number of converters per link
- [TX/RX/RX_OS]_JESD_L: [RX/TX] number of lanes per link
- [TX/RX/RX_OS]_JESD_S: [RX/TX] number of samples per converter per frame

RX_OS means RX Observation path.

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
make TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
RX_JESD_M=4 \
RX_JESD_L=2 \
RX_JESD_S=1 \
RX_OS_JESD_M=2 \
RX_OS_JESD_L=2 \
RX_OS_JESD_S=1
```

Corresponding device tree: [kcu105_adrv9371x.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/kcu105_adrv9371x.dts)

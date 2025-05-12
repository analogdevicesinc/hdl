# AD738X-FMC/ZED HDL Project

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad738x_fmc/zed
make
```

The overwritable parameters from the environment:

- ALERT_SPI_N pin can operate as a serial data output pin or alert indication output depending on its value:
   - 0 - SDOB-SDOD
   - 1 - ALERT

- NUM_OF_SDI - Defines the number of SDI lines used: 1, 2, 4

For the ALERT functionality, the following parameter will be used in `make` command: ALERT_SPI_N.
For the serial data output functionality, the following parameters will be used in `make` command: ALERT_SPI_N, NUM_OF_SDI.

### Example configurations

#### Default mode

This specific command is equivalent to running `make` only:

```
cd projects/ad738x_fmc/zed
make ALERT_SPI_N=0 NUM_OF_SDI=1
```

Corresponding device tree: [zynq-zed-adv7511-ad7380.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad7380.dts)
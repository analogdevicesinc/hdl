<!-- no_no_os -->

# AD4080-FMC-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad4080_fmc_evb/zed
make
```

The overwritable parameters from the environment:

- ADC_N_BITS - Optimizes for the maximum available ADC sample data width.
values:
   - 20 (default required for AD4080) -> 32bit data bus
   - 16 -> 16bit data bus
   - 14 -> 16bit data bus

- SPI_SLAVE - adds the SPI slave interface on the PMOD JB connector (pmod_spi_cs, pmod_spi_sclk, pmod_spi_miso, pmod_data_ready) and its constraints;
  - 0 - SPI slave interface not included (default)
  - 1 - SPI slave interface included

### Example configurations

#### Default configuration

This specific command is equivalent to running `make` only:

```
cd projects/ad4080_fmc_evb/zed
make ADC_N_BITS=20 SPI_SLAVE=0
```

Corresponding device tree: [zynq-zed-ad4080.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-ad4080.dts)

#### SPI slave interface enabled

```
make ADC_N_BITS=20 SPI_SLAVE=1
```

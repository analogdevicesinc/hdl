<!-- no_no_os -->

# AD469X-EVB/ZED HDL Project

- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameter configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad469x_evb/zed
make
```

The overwritable parameter from the environment:

- SPI_4WIRE - Defines if CNV signal is linked to PWM or to SPI_CS
   - 0 - CNV signal is linked to PWM
   - 1 - CNV signal is linked to SPI_CS
- PWM_OFFLOAD - Defines the SPI Engine offload trigger and CNV gating
   - 0 - BUSY edge trigger, DMA+PWM+BUSY gated CNV (ad469x)
   - 1 - BUSY edge trigger, PWM+BUSY gated CNV (ad4692 register)
   - 2 - PWM+DMA gated trigger, no CNV gating (ad4692 manual)

### Example configurations

#### Default configuration: ad469x, BUSY edge trigger, DMA+PWM+BUSY gated CNV

This specific command is equivalent to running `make` only:

```
cd projects/ad469x_evb/zed
make SPI_4WIRE=0 PWM_OFFLOAD=0
```

Corresponding device tree: [zynq-zed-adv7511-ad4696.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zed-adv7511-ad4696.dts)

#### ad4692 register mode: BUSY edge trigger, PWM+BUSY gated CNV

```
make SPI_4WIRE=0 PWM_OFFLOAD=1
```

#### ad4692 manual mode: PWM+DMA gated trigger, no CNV gating

```
make SPI_4WIRE=0 PWM_OFFLOAD=2
```

#### 4-wire SPI mode: CNV driven by SPI_CS

```
make SPI_4WIRE=1 PWM_OFFLOAD=0
```
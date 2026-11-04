# QUAD-ADA4356 HDL Project

- System documentation: to be added
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/quad_ada4356/index.html
- Evaluation board VADJ: 2.5V

## Supported parts

| Part name                                       | Description                                                                   |
|-------------------------------------------------|-------------------------------------------------------------------------------|
| [ADA4356](https://www.analog.com/ada4356)       | 14-Bit, 125MSPS, Programmable Transimpedance, Current to Bits Receiver μModule |
| [AD9517-4](https://www.analog.com/ad9517-4)     | 12-Output Clock Generator with Integrated 1.6 GHz VCO                         |

## Description

This project implements a quad-channel (4-instance) ADA4356 design on the ADA4356 Quad FMC board.
Each ADA4356 instance provides a 2-lane LVDS data interface (D0A, D1A), a frame clock (FCO), and
a data clock output (DCO, 500 MHz DDR), all captured using 8:1 DDR SERDES (via the `axi_ada4355`
IP core). An AD9517-4 supplies a separate sample clock to each ADA4356, so each instance runs in
its own DCO clock domain.

Each instance has a dedicated `axi_dmac` for independent data capture (16-bit source, 64-bit destination,
FIFO-write mode). All four DMAs share the HP1 AXI memory port. In the default build an `axi_tdd`
controller drives the trigger output and starts the four DMAs together; see the carrier README for
the `TDD_SUPPORT` build parameter.

The ADA4356 Quad FMC board also includes:
- Shared SPI bus (PS SPI0) for configuring all four DUTs and the AD9517-4
- Individual chip selects per DUT (CSB_DUTA..D) and for the AD9517-4 (CSB_AD9510 on the schematic)
- Trigger input/output signals, connected to the `axi_tdd` controller (not to GPIO)
- APD bias digital potentiometer on PS SPI1, and an APD supply enable on GPIO
- Three MAX7320 I2C output expanders on the FMC I2C bus for the per-channel gain, filter and
  current-divider controls (software only, no HDL involvement)

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

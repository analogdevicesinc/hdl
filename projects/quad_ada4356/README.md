# Quad ADA4356 HDL Project

- System documentation: TO BE ADDED
- HDL project documentation: TO BE ADDED

## Supported parts

| Part name                                       | Description                                              |
|-------------------------------------------------|----------------------------------------------------------|
| [ADA4356](https://www.analog.com/ada4356)       | Current-Input Analog-to-Digital Converter Module          |

## Description

This project implements a quad-channel (4-instance) ADA4356 design on the ADA4356 Quad FMC board.
Each ADA4356 instance provides a 2-lane LVDS data interface (D0A, D1A), a frame clock (FCO), and
a data clock output (DCO), all captured using 8:1 DDR SERDES (via the `axi_ada4355` IP core).

Each instance has a dedicated `axi_dmac` for independent data capture (16-bit source, 64-bit destination,
FIFO-write mode). All four DMAs share the HP1 AXI memory port.

The ADA4356 Quad FMC board also includes:
- Shared SPI bus for configuring all four DUTs and an AD9510 clock distribution IC
- Individual chip selects per DUT (CSB_DUTA..D) and for the AD9510
- Trigger input/output signals
- MAX7329 I2C IO expander (active-low interrupt output)

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

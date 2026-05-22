# COTS HDL Project

This project provides minimal FPGA reference designs that allow the processor 
system on various FPGA carriers to boot Linux. These are "bare" carrier designs 
without any specific ADI product interfaces.

## Purpose

The COTS project is intended for:
- Testing basic carrier board functionality
- Linux kernel and driver development
- Starting point for custom designs
- Validating carrier board hardware

## Supported Carriers

| Carrier Board | FPGA Device | Description |
|---------------|-------------|-------------|
| ZCU102 | Zynq UltraScale+ MPSoC XCZU9EG | Xilinx evaluation board with Zynq US+ (**requires premium license**) |
| Microzed | Zynq-7000 XC7Z010 or XC7Z020 | Low-cost Zynq-7000 development board |
| Zed | Zynq-7000 XC7Z020 | Popular Zynq-7000 evaluation board with HDMI/Audio |

## Features

Each design includes:
- Processor system configured for Linux boot
- DDR memory controller
- Basic peripherals (UART, Ethernet, USB, SD card)
- GPIO for general-purpose I/O
- System ID for design identification
- SPI interfaces

## Supported parts

No ADI parts are required. This is a bare carrier design for booting Linux.

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

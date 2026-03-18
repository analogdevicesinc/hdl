# LSCC-ARW-MCB Base Design

Base SoC block design for the
[ADI-Lattice Motion Control Board (LSCC-ARW-MCB)](https://www.arrow.com/en/products/lscc-arw-mcb/einfochips-limited.html),
built around the Lattice CertusPro-NX FPGA (`LFCPNX-100-9LFG672`).

Board sources (schematic, Gerber, BOM, firmware, manuals):
[ArrowElectronics/ADI-Lattice-MotionControlBoard](https://github.com/ArrowElectronics/ADI-Lattice-MotionControlBoard)

## Requirements

Download the necessary Lattice Propel Builder IPs by running the following
commands in the Lattice Propel Builder TCL Console:

```
ip_catalog_install -vlnv latticesemi.com:ip:axi_interconnect:2.2.1
ip_catalog_install -vlnv latticesemi.com:ip:memory_controller:2.6.4
ip_catalog_install -vlnv latticesemi.com:ip:uart:1.5.0
ip_catalog_install -vlnv latticesemi.com:ip:axi2apb_bridge:1.4.0
ip_catalog_install -vlnv latticesemi.com:module:apb_interconnect:1.4.0
ip_catalog_install -vlnv latticesemi.com:module:pll:1.9.1
```

## Design summary

| Block | IP | Notes |
|---|---|---|
| RISC-V CPU | `riscv_rtos` 2.8.0 | Balanced mode, 16 IRQs, boots at `0x80000000` |
| AXI Interconnect | `axi_interconnect` 2.2.1 | 2 masters (CPU instr + data), 3 slaves |
| System Memory | `system_memory` 2.5.1 | 128 KB LRAM at `0x80000000` |
| LPDDR4 Controller | `memory_controller` 2.6.4 | 32-bit, 8 Gbit, 533 MHz cmd freq at `0x00000000` |
| UART | `uart` 1.5.0 | 100 MHz, at `0xC0000000` |
| AXI-to-APB Bridge | `axi2apb_bridge` 1.4.0 | |
| APB Interconnect | `apb_interconnect` 1.4.0 | 2 slaves (LPDDR4 config + UART) |
| PLL | `pll` 1.9.1 | 125 MHz in, 100 MHz sys clock + 10 MHz RTC |

## Clocking

- **`clk_125`** (125 MHz) drives the PLL
- **PLL CLKOP** (100 MHz) is the system clock for CPU, memories, interconnects, UART
- **PLL CLKOS** (10 MHz) is the CPU real-time clock
- **`clk_100`** (100 MHz) is the LPDDR4 reference clock

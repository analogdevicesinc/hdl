###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# FMC HPC0
set_property -dict {PACKAGE_PIN Y2  IOSTANDARD LVCMOS18} [get_ports FPGA_TRIG]
set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS18} [get_ports UDC_PG]
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18} [get_ports TR_PULSE]
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18} [get_ports TX_LOAD]
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS18} [get_ports RX_LOAD]
set_property -dict {PACKAGE_PIN T7  IOSTANDARD LVCMOS18} [get_ports FPGA_BOOT_GOOD]

set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_SCLK]
set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_CSB]
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_MOSI]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS18          } [get_ports CMD_SPI_MISO]

set_property -dict {PACKAGE_PIN G8} [get_ports aurora_refclk_p]
set_property -dict {PACKAGE_PIN G7} [get_ports aurora_refclk_n]
# set_property -dict {PACKAGE_PIN H2} [get_ports aurora_txp[0]]
# set_property -dict {PACKAGE_PIN H1} [get_ports aurora_txn[0]]
# set_property -dict {PACKAGE_PIN J4} [get_ports aurora_txp[1]]
# set_property -dict {PACKAGE_PIN J3} [get_ports aurora_txn[1]]
# set_property -dict {PACKAGE_PIN G4} [get_ports aurora_rxp[0]]
# set_property -dict {PACKAGE_PIN G3} [get_ports aurora_rxn[0]]
# set_property -dict {PACKAGE_PIN H6} [get_ports aurora_rxp[1]]
# set_property -dict {PACKAGE_PIN H5} [get_ports aurora_rxn[1]]

create_clock -period 8.000 -name aurora_refclk [get_ports aurora_refclk_p]

# set false path to output ports which connect to devices without any clocks
set_false_path -to   [get_ports FPGA_TRIG]
set_false_path -to   [get_ports TR_PULSE]
set_false_path -to   [get_ports TX_LOAD]
set_false_path -to   [get_ports RX_LOAD]
set_false_path -to   [get_ports FPGA_BOOT_GOOD]
set_false_path -from [get_ports FPGA_BOOT_GOOD]
set_false_path -from [get_ports UDC_PG]

# CMD SPI

set trce_dly_max   0.900; # maximum board trace delay
set trce_dly_min   0.800; # minimum board trace delay

create_generated_clock -name CMD_SPI_SCLK -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports CMD_SPI_SCLK]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list CMD_SPI_CSB CMD_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports CMD_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

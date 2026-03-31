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

# Note: both clocks are connected and driven, choose one
# set_property -dict {PACKAGE_PIN L8} [get_ports aurora_refclk_p]; # MGTREFCLK0P_228
# set_property -dict {PACKAGE_PIN L7} [get_ports aurora_refclk_n]; # MGTREFCLK0N_228
set_property -dict {PACKAGE_PIN G8} [get_ports aurora_refclk_p]; # MGTREFCLK0P_229
set_property -dict {PACKAGE_PIN G7} [get_ports aurora_refclk_n]; # MGTREFCLK0N_229

set_property -dict {PACKAGE_PIN M6} [get_ports aurora_txp[0]]; # MGTHTXP3_228
set_property -dict {PACKAGE_PIN M5} [get_ports aurora_txn[0]]; # MGTHTXN3_228
set_property -dict {PACKAGE_PIN P6} [get_ports aurora_txp[1]]; # MGTHTXP1_228
set_property -dict {PACKAGE_PIN P5} [get_ports aurora_txn[1]]; # MGTHTXN1_228
set_property -dict {PACKAGE_PIN L4} [get_ports aurora_rxp[0]]; # MGTHRXP3_228
set_property -dict {PACKAGE_PIN L3} [get_ports aurora_rxn[0]]; # MGTHRXN3_228
set_property -dict {PACKAGE_PIN P2} [get_ports aurora_rxp[1]]; # MGTHRXP1_228
set_property -dict {PACKAGE_PIN P1} [get_ports aurora_rxn[1]]; # MGTHRXN1_228

# FMC HPC1

# set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVCMOS18} [get_ports FPGA_TRIG]
# set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports UDC_PG]
# set_property -dict {PACKAGE_PIN AD2 IOSTANDARD LVCMOS18} [get_ports TR_PULSE]
# set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVCMOS18} [get_ports TX_LOAD]
# set_property -dict {PACKAGE_PIN AE8 IOSTANDARD LVCMOS18} [get_ports RX_LOAD]
# set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS18} [get_ports FPGA_BOOT_GOOD]

# set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_SCLK]
# set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_CSB]
# set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_MOSI]
# set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18          } [get_ports CMD_SPI_MISO]

# Note: both clocks are connected and driven, choose one
# # set_property -dict {PACKAGE_PIN G27} [get_ports aurora_refclk_p]; # MGTREFCLK0P_130
# # set_property -dict {PACKAGE_PIN G28} [get_ports aurora_refclk_n]; # MGTREFCLK0N_130
# set_property -dict {PACKAGE_PIN E27} [get_ports aurora_refclk_p]; # MGTREFCLK1P_130
# set_property -dict {PACKAGE_PIN E28} [get_ports aurora_refclk_n]; # MGTREFCLK1N_130

# set_property -dict {PACKAGE_PIN K29} [get_ports aurora_txp[0]]; # MGTHTXP0_129
# set_property -dict {PACKAGE_PIN K30} [get_ports aurora_txn[0]]; # MGTHTXN0_129
# set_property -dict {PACKAGE_PIN J31} [get_ports aurora_txp[1]]; # MGTHTXP1_129
# set_property -dict {PACKAGE_PIN J32} [get_ports aurora_txn[1]]; # MGTHTXN1_129
# set_property -dict {PACKAGE_PIN L31} [get_ports aurora_rxp[0]]; # MGTHRXP0_129
# set_property -dict {PACKAGE_PIN L32} [get_ports aurora_rxn[0]]; # MGTHRXN0_129
# set_property -dict {PACKAGE_PIN K33} [get_ports aurora_rxp[1]]; # MGTHRXP1_129
# set_property -dict {PACKAGE_PIN K34} [get_ports aurora_rxn[1]]; # MGTHRXN1_129

create_clock -period 6.400 -name aurora_refclk [get_ports aurora_refclk_p]

# set false path to output ports which connect to devices without any clocks
set_false_path -to   [get_ports FPGA_TRIG]
set_false_path -to   [get_ports TR_PULSE]
set_false_path -to   [get_ports TX_LOAD]
set_false_path -to   [get_ports RX_LOAD]
set_false_path -from [get_ports FPGA_BOOT_GOOD]
set_false_path -from [get_ports UDC_PG]

# CMD SPI

# set trce_dly_max   0.900; # maximum board trace delay
# set trce_dly_min   0.800; # minimum board trace delay

# create_generated_clock -name CMD_SPI_SCLK -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports CMD_SPI_SCLK]
# set tsu          5.000;      # destination device setup time requirement
# set thd          5.000;      # destination device hold time requirement
# set output_ports [get_ports [list CMD_SPI_CSB CMD_SPI_MOSI]]; # list of output ports
# set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
# set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
# set tco_max     5.000;     # Maximum clock to out delay
# set tco_min     5.000;     # Minimum clock to out delay
# set input_ports [get_ports CMD_SPI_MISO]; # list of input ports
# set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
# set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

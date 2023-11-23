###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN Y32  IOSTANDARD LVCMOS18} [get_ports ad463x_spi_sdi[0]]       ; ## D23  FMC_LA23_P           IO_L1P_T0L_N0_DBC_45
set_property -dict {PACKAGE_PIN W32  IOSTANDARD LVCMOS18} [get_ports ad463x_spi_sdi[1]]       ; ## D24  FMC_LA23_N           IO_L1N_T0L_N1_DBC_45
set_property -dict {PACKAGE_PIN V32  IOSTANDARD LVCMOS18} [get_ports ad463x_spi_sdi[2]]       ; ## D26  FMC_LA26_P           IO_L2P_T0L_N2_45
set_property -dict {PACKAGE_PIN U33  IOSTANDARD LVCMOS18} [get_ports ad463x_spi_sdi[3]]       ; ## D27  FMC_LA26_N           IO_L2N_T0L_N3_45

# input delays for MISO lines (SDO for the device)
# data is latched on negative edge

set tsetup 5.6
set thold 1.4

set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max $tsetup [get_ports {ad463x_spi_sdi[0]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min $thold [get_ports {ad463x_spi_sdi[0]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max $tsetup [get_ports {ad463x_spi_sdi[1]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min $thold [get_ports {ad463x_spi_sdi[1]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max $tsetup [get_ports {ad463x_spi_sdi[2]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min $thold [get_ports {ad463x_spi_sdi[2]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max $tsetup [get_ports {ad463x_spi_sdi[3]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min $thold [get_ports {ad463x_spi_sdi[3]}]

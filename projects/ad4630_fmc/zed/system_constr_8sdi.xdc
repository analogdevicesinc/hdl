###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[0]]       ; ## H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[1]]       ; ## H08  FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[2]]       ; ## G09  FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[3]]       ; ## G10  FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[4]]       ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[5]]       ; ## H11  FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[6]]       ; ## D11  FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdi[7]]       ; ## D12  FMC_LPC_LA05_N

set tsetup 5.6
set thold 1.6

# input delays for MISO lines (SDO for the device)
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[0]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[0]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[1]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[1]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[2]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[2]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[3]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[3]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[4]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[4]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[5]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[5]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[6]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[6]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports ad463x_spi_sdi[7]]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold [get_ports ad463x_spi_sdi[7]]

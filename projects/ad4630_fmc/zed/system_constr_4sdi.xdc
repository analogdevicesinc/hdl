###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {ad463x_spi_sdi[0]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {ad463x_spi_sdi[1]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports {ad463x_spi_sdi[2]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports {ad463x_spi_sdi[3]}]

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

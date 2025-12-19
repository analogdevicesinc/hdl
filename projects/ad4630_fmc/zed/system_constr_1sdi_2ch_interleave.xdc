###############################################################################
## Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Constraints for 1 SDI, 2 Channels configuration without reorder (NO_REORDER=1)
# This results in only 1 SDI line total
# input delays for MISO lines (SDO for the device)
# data is latched on negative edge

set tsetup 5.6
set thold 1.4

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {ad463x_spi_sdi[0]}]       ; ## H07  FMC_LPC_LA02_P

set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max  $tsetup [get_ports {ad463x_spi_sdi[0]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min  $thold  [get_ports {ad463x_spi_sdi[0]}]

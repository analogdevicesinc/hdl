###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# pmod jb - spi slave interface and data ready

set_property -dict {PACKAGE_PIN W12  IOSTANDARD LVCMOS33} [get_ports pmod_spi_cs];     ## JB1
set_property -dict {PACKAGE_PIN W11  IOSTANDARD LVCMOS33} [get_ports pmod_spi_sclk];   ## JB2
set_property -dict {PACKAGE_PIN V10  IOSTANDARD LVCMOS33} [get_ports pmod_spi_miso];   ## JB3
set_property -dict {PACKAGE_PIN W8   IOSTANDARD LVCMOS33} [get_ports pmod_data_ready]; ## JB4

# spi pins are synchronized in fabric, not timed against the fabric clock

set_false_path -from [get_ports {pmod_spi_cs pmod_spi_sclk}]
set_false_path -to   [get_ports pmod_data_ready]

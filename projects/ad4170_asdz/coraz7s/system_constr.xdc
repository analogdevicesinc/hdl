###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN  G15 IOSTANDARD LVCMOS33 IOB TRUE}                  [get_ports ad4170_spi_sclk]        ; ## CK_IO13
set_property -dict {PACKAGE_PIN  J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports ad4170_spi_miso]        ; ## CK_IO12
set_property -dict {PACKAGE_PIN  K18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP}  [get_ports ad4170_spi_mosi]        ; ## CK_IO11
set_property -dict {PACKAGE_PIN  U15 IOSTANDARD LVCMOS33}                           [get_ports ad4170_spi_csn]         ; ## CK_IO10

# synchronization and timing

set_property -dict {PACKAGE_PIN  R14 IOSTANDARD LVCMOS33}                           [get_ports ad4170_dig_aux[1]]      ; ## CK_IO7
set_property -dict {PACKAGE_PIN  T14 IOSTANDARD LVCMOS33}                           [get_ports ad4170_dig_aux[0]]      ; ## CK_IO2

# rename auto-generated clock for SPI Engine to spi_clk - 40MHz
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# create a generated clock for SCLK - fSCLK=spi_clk/2 - 20MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*sclk_reg/C] -edges {1 3 5} [get_ports ad4170_spi_sclk]

# input delays for MISO lines (SDO for the device)
set_input_delay -clock [get_clocks spi_clk] [get_property PERIOD [get_clocks spi_clk]] \
		[get_ports -filter {NAME =~ "ad4170_spi_miso"}]

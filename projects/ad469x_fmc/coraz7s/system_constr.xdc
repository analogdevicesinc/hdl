###############################################################################
## Copyright (C) 2020-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4696_ardz SPI interface

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 IOB TRUE}                 [get_ports ad469x_spi_sclk];     ## CK_IO13
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP} [get_ports ad469x_spi_sdo];      ## CK_IO12
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE PULLTYPE PULLUP} [get_ports ad469x_spi_sdi];      ## CK_IO11
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 IOB TRUE}                 [get_ports ad469x_spi_cs];       ## CK_IO10

set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33}                          [get_ports ad469x_busy_alt_gp0]; ## CK_IO09
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33}                          [get_ports ad469x_spi_cnv];      ## CK_IO06
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33}                          [get_ports ad469x_resetn];       ## CK_IO04

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33}                          [get_ports iic_eeprom_scl];      ## CK_SCL
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33}                          [get_ports iic_eeprom_sda];      ## CK_SDA

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

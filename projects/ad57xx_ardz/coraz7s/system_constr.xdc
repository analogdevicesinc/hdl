###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad57xx interface

set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad57xx_ardz_spi_mosi]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad57xx_ardz_spi_miso]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad57xx_ardz_spi_sclk]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad57xx_ardz_syncb]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports ad57xx_ardz_resetb]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports ad57xx_ardz_ldacb]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports ad57xx_ardz_clrb]

# rename auto-generated clock for SPI Engine to spi_clk - 140MHz
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*axi_ad57xx_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*axi_ad57xx_clkgen*i_mmcm]]

# create a generated clock for SCLK - fSCLK=spi_clk/4 - 35MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*sclk_reg/C] -divide_by 4 [get_ports ad57xx_ardz_spi_sclk]

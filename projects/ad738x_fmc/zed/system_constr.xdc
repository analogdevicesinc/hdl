###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports spi_sclk]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports spi_sdo]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports spi_cs]

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 8
set_multicycle_path -hold -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 7
set_multicycle_path -setup -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter NAME=~*/spi_ad738x_adc_execution/inst/left_aligned_reg*] 8
set_multicycle_path -hold -from [get_clocks spi_clk] -to [get_cells -hierarchical -filter NAME=~*/spi_ad738x_adc_execution/inst/left_aligned_reg*] 7


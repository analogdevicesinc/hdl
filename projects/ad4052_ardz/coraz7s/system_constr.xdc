###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ADC SPI interface
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports adc_spi_sclk]   ; ## Arduino_IO13
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports adc_spi_sdi]    ; ## Arduino_IO12
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports adc_spi_sdo]    ; ## Arduino_IO11
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports adc_spi_cs]     ; ## Arduino_IO10
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33}          [get_ports adc_cnv]        ; ## Arduino_IO06
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33}          [get_ports adc_gp0]        ; ## Arduino_IO09
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33}          [get_ports adc_gp1]        ; ## Arduino_IO08

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

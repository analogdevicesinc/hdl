###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad40xx_fmc SPI interface
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_adc_spi_sdo]       ; ##  PMOD JA1_N
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_adc_spi_sdi]       ; ##  PMOD JA2_P
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_adc_spi_sclk]      ; ##  PMOD JA2_N
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports pulsar_adc_spi_cs]        ; ##  PMOD JA1_P

set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports pulsar_adc_spi_pd]                 ; ##  PMOD JA3_P

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

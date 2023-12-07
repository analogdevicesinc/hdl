###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad40xx_fmc SPI interface
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports pulsar_adc_spi_sdo]       ; ##  PMOD JA1_N
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports pulsar_adc_spi_sdi]       ; ##  PMOD JA2_P
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports pulsar_adc_spi_sclk]      ; ##  PMOD JA2_N
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports pulsar_adc_spi_cs]        ; ##  PMOD JA1_P

set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports pulsar_adc_spi_pd]         ; ##  PMOD JA3_P



# pulsar JB_CONNECTION SPI interface

set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports pulsar2_adc_spi_sdo]       ; ##  PMOD JB1_N
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports pulsar2_adc_spi_sdi]       ; ##  PMOD JB2_P
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports pulsar2_adc_spi_sclk]      ; ##  PMOD JB2_N
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports pulsar2_adc_spi_cs]        ; ##  PMOD JB1_P

set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports pulsar2_adc_spi_pd]         ; ##  PMOD JB3_P

# pulsar DEBUG SPI interface

set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports debug_pulsar2_adc_spi_cs]       ; ##  CK_IO0
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports debug_pulsar2_adc_spi_sclk]     ; ##  CK_IO1
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports debug_pulsar2_adc_spi_sdi]      ; ##  CK_IO2
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports debug_pulsar2_adc_spi_sdo]      ; ##  CK_IO3



# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_pulsar_adc_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

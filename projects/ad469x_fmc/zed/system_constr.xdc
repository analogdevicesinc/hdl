###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4696_fmc SPI interface
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sdi]       ; ## D08  FMC_LA01_CC_P  IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sdo]       ; ## H07  FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_sclk]      ; ## D09  FMC_LA01_CC_N  IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_cs]        ; ## G06  FMC_LA00_CC_P  IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad469x_spi_cnv]       ; ## G07  FMC_LA00_CC_N  IO_L13N_T2_MRCC_34

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad469x_resetn]        ; ## H10  FMC_LA04_P     IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad469x_busy_alt_gp0]  ; ## H08  FMC_LA02_N     IO_L20N_T3_34

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

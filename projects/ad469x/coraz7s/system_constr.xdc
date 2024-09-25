###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4696_fmc SPI interface

set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {ad469x_spi_cs}];       #IO_L11N_T1_SRCC_34 Sch=ck_io[10]
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports {ad469x_spi_sclk}];     #IO_L19N_T3_VREF_35 Sch=ck_io[13]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports {ad469x_spi_miso}];     #IO_L14P_T2_AD4P_SRCC_35 Sch=ck_io[12]
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports {ad469x_spi_mosi}];     #IO_L12N_T1_MRCC_35 Sch=ck_io[11]

set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {ad469x_busy_alt_gp0}]; #IO_L8N_T1_AD10N_35 Sch=ck_io[9]
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports {ad469x_spi_cnv}];      #IO_L19N_T3_VREF_34 Sch=ck_io[6]

set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {ad469x_resetn}];       #IO_L21P_T3_DQS_34 Sch=ck_io[4]

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
create_generated_clock -name spi_clk -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]] -master_clock clk_fpga_0 [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm]]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks spi_clk]
set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/spi_ad469x_execution/inst/left_aligned_reg*}] -from [get_clocks spi_clk]

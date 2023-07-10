###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# adaq400x PMOD SPI interface - the PMOD JA1 is used

set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports adaq400x_spi_sdo]       ; ## JA2
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports adaq400x_spi_sdi]       ; ## JA3
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports adaq400x_spi_sclk]      ; ## JA4
set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports adaq400x_spi_cs]        ; ## JA1

## There is a multi-cycle path between the axi_spi_engine's SDO_FIFO and the
# execution's shift register, because we load new data into the shift register
# in every DATA_WIDTH's x 8 cycle. (worst case scenario)
# Set a multi-cycle delay of 8 spi_clk cycle, slightly over constraining the path.

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks clk_fpga_2]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] -from [get_clocks clk_fpga_2]

set_multicycle_path -setup 8 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks clk_fpga_2]
set_multicycle_path -hold  7 -to [get_cells -hierarchical -filter {NAME=~*/execution/inst/left_aligned_reg*}] -from [get_clocks clk_fpga_2]


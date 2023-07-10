###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "4.06504065 ns"  -name ref_clk_c      [get_ports {ref_clk_c}]
create_clock -period  "4.06504065 ns"  -name ref_clk_d      [get_ports {ref_clk_d}]
create_clock -period  "4.06504065 ns"  -name core_clk_c     [get_ports {core_clk_c}]
create_clock -period  "4.06504065 ns"  -name core_clk_d     [get_ports {core_clk_d}]
create_clock -period  "100 ns"    -name spi_clk             [get_nets {i_system_bd|sys_spi|sys_spi|SCLK_reg}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -to [get_registers *sys_gpio_bd|readdata[12]*]
set_false_path -to [get_registers *sys_gpio_bd|readdata[13]*]

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

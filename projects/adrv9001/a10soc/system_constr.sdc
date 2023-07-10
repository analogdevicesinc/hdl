###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]

# In CMOS mode interface max frequency is 80MHz
create_clock -period "12.500 ns"  -name rx1_clk             [get_ports {rx1_dclk_out_p}]
create_clock -period "12.500 ns"  -name rx2_clk             [get_ports {rx2_dclk_out_p}]
create_clock -period "12.500 ns"  -name tx1_clk             [get_ports {tx1_dclk_out_p}]
create_clock -period "12.500 ns"  -name tx2_clk             [get_ports {tx2_dclk_out_p}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

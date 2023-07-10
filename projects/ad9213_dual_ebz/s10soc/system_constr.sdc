###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period  "10.000 ns"     -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "3.2 ns"        -name ref_a_clk0          [get_ports {rx_ref_a_clk0}]
create_clock -period  "3.2 ns"        -name ref_a_clk1          [get_ports {rx_ref_a_clk1}]
create_clock -period  "3.2 ns"        -name ref_b_clk0          [get_ports {rx_ref_b_clk0}]
create_clock -period  "3.2 ns"        -name ref_b_clk1          [get_ports {rx_ref_b_clk1}]
create_clock -period  "3.2 ns"        -name device_clk          [get_ports {rx_device_clk_0}]

set_input_delay -clock {device_clk} 0.2 [get_ports {rx_sysref_a}]

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
set_false_path -from [get_keepers -no_duplicates {i_system_bd|sys_gpio_out|sys_gpio_out|data_out[2]}] -to [get_keepers -no_duplicates {adc_swap_d1}]

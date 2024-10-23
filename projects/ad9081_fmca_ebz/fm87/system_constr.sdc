###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.0000 ns"   -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "2.66667 ns"   -name ref_clk             [get_ports {fpga_refclk_in}]
create_clock -period "2.66667 ns"   -name tx_device_clk       [get_ports {clkin6}]
create_clock -period "2.66667 ns"   -name rx_device_clk       [get_ports {clkin10}]

derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

set_input_delay -clock {tx_device_clk} 0.2 [get_ports {sysref2}]

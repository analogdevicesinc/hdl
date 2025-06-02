###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "6.0000 ns"  -name sys_ddr_ref_clk     [get_ports {sys_ddr_ref_clk_clk}]
create_clock -period "6.0000 ns"  -name emif_ref_clk        [get_ports {emif_hps_pll_ref_clk}]

create_clock -period "3.2000 ns"  -name ref_clk             [get_ports {fpga_refclk_in}]
create_clock -period "3.2000 ns"  -name device_clk          [get_ports {device_clk}]

derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

set_false_path -to [get_registers {*|i_sync_input_ctrl|cdc_sync_stage*[0]}]
set_false_path -to [get_registers {*|i_sync_reset_ack|cdc_sync_stage*[0]}]
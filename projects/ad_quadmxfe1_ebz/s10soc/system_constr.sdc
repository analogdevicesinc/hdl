
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "4.000 ns"  -name ref_clk             [get_ports {fpga_clk_m2c[0]}]
create_clock -period  "4.000 ns"  -name rx_device_clk       [get_ports {fpga_clk_m2c[1]}]
create_clock -period  "4.000 ns"  -name tx_device_clk       [get_ports {fpga_clk_m2c[2]}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

## The following signals are not changed that often so they can remain static
set_false_path -from [get_registers *i_system_bd|mxfe_rx_cpack|mxfe_rx_cpack|i_pack_shell|enable_int[*]]
set_false_path -from [get_registers *i_system_bd|mxfe_tx_upack|mxfe_tx_upack|i_pack_shell|enable_int[*]]

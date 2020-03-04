
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "3.000 ns"  -name rx_ref_clk          [get_ports {rx_ref_clk}]
create_clock -period  "3.000 ns"  -name tx_ref_clk          [get_ports {tx_ref_clk}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

set_false_path    -from * -to [get_ports {flash_resetn}]


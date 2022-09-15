create_clock -period "20.000 ns" -name sys_clk  [get_ports {sys_clk}]

derive_pll_clocks
derive_clock_uncertainty

# frame reader seems to use the wrong reset!

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
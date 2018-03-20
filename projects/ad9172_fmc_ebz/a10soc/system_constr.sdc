
create_clock -period "10.0000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "2.8169 ns"  -name tx_ref_clk0         [get_ports {tx_ref_clk0}]

# Asynchronous GPIOs

foreach async_input {gpio_bd_i[*]} {
   set_false_path -from [get_ports $async_input]
}

foreach async_output {gpio_bd_o[*] txen_0 txen_1 spi_en_n} {
   set_false_path -to [get_ports $async_output]
}
derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

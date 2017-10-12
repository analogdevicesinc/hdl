
create_clock -period "10.000 ns"  -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "3.000 ns"  -name rx_ref_clk          [get_ports {rx_ref_clk}]
create_clock -period  "3.000 ns"  -name tx_ref_clk          [get_ports {tx_ref_clk}]

# Asynchronous GPIOs

foreach async_input {adc_fda adc_fdb clkd_status[*] dac_irq gpio_bd_i[*] trig} {
   set_false_path -from [get_ports $async_input]
}

foreach async_output {adc_pd clkd_sync dac_reset dac_txen gpio_bd_o[*]} {
   set_false_path -to [get_ports $async_output]
}
derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

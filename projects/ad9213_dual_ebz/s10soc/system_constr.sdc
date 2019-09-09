
create_clock -period  "10.000 ns"       -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period  "3.121 ns"        -name ref_a_clk0          [get_ports {rx_ref_a_clk0}]
create_clock -period  "3.121 ns"        -name ref_a_clk1          [get_ports {rx_ref_a_clk1}]
create_clock -period  "3.121 ns"        -name ref_b_clk0          [get_ports {rx_ref_b_clk0}]
create_clock -period  "3.121 ns"        -name ref_b_clk1          [get_ports {rx_ref_b_clk1}]

# Asynchronous GPIOs

foreach async_input {ad9213_a_gpio[*] ad9213_b_gpio[*]} {
  set_false_path -to [get_ports $async_input]
}

foreach async_output {ad9213_a_rst ad9213_b_rst ad9213_a_gpio[*] ad9213_b_gpio[*]} {
  set_false_path -to [get_ports $async_output]
}

derive_pll_clocks
derive_clock_uncertainty

# set_false_path -to [get_registers *sys_gpio_bd|readdata[12]*]
# set_false_path -to [get_registers *sys_gpio_bd|readdata[13]*]
#
set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

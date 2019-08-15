
create_clock -period "10.000 ns" -name sys_clk_100mhz    [get_ports {sys_clk}]
create_clock -period "4.000 ns"  -name rx_device_clk     [get_ports {rx_device_clk}]
create_clock -period "4.000 ns"  -name rx_ref_clk        [get_ports {rx_ref_clk}]

# Asynchronous GPIOs

foreach async_input {adc_fda adc_fdb gpio_bd_i[*]} {
   set_false_path -from [get_ports $async_input]
}

foreach async_output {laser_gpio[*] afe_adc_convst afe_dac_load afe_dac_clr_n adc_pdwn gpio_bd_o[*]} {
   set_false_path -to [get_ports $async_output]
}

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]
set_false_path -to [get_registers *i_util_axis_syncgen*i_axis_ext_sync|cdc_sync_stage1*]


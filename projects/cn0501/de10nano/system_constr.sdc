
create_clock -period "20.000 ns"  -name sys_clk     [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb1_clk    [get_ports {usb1_clk}]

create_clock -period "31.250 ns"  -name clk_in      [get_ports {clk_in}]

derive_pll_clocks
derive_clock_uncertainty

set_false_path -from {system_bd:i_system_bd|system_bd_sys_gpio_bd:sys_gpio_bd|data_out[*]} -to *
set_false_path -from {system_bd:i_system_bd|system_bd_sys_gpio_out:sys_gpio_out|data_out[*]} -to *
set_false_path -from * -to {system_bd:i_system_bd|system_bd_sys_gpio_bd:sys_gpio_bd|readdata[*]}

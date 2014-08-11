
set ip_dac_clk  [get_clocks -of_objects [get_ports dac_clk]]
set ip_cpu_clk  [get_clocks -of_objects [get_ports s_axi_aclk]]

set_false_path -from $ip_dac_clk  -to $ip_cpu_clk
set_false_path -from $ip_cpu_clk  -to $ip_dac_clk



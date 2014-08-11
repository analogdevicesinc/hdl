
set ip_adc_clk  [get_clocks -of_objects [get_ports adc_clk]]
set ip_cpu_clk  [get_clocks -of_objects [get_ports s_axi_aclk]]

set_false_path -from $ip_adc_clk  -to $ip_cpu_clk
set_false_path -from $ip_cpu_clk  -to $ip_adc_clk



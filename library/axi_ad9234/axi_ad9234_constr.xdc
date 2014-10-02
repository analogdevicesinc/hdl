
create_clock -period [expr 1000/250] -name rx_clk [get_ports rx_clk]
create_clock -period [expr 1000/100] -name s_axi_aclk [get_ports s_axi_aclk]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports rx_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]




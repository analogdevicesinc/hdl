
create_clock -period [expr 1000/250] -name tx_clk [get_ports tx_clk]
create_clock -period [expr 1000/100] -name s_axi_aclk [get_ports s_axi_aclk]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports tx_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]




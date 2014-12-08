
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports tx_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]




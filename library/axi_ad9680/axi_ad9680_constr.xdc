
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports rx_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]




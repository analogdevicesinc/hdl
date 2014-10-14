
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports axi_clk]]




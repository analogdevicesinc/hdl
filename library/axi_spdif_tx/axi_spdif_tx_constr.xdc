
set_clock_groups -asynchronous -group  [get_clocks -of_objects [get_ports spdif_data_clk]]
set_clock_groups -asynchronous -group  [get_clocks -of_objects [get_ports S_AXIS_ACLK]]
set_clock_groups -asynchronous -group  [get_clocks -of_objects [get_ports DMA_REQ_ACLK]]
set_clock_groups -asynchronous -group  [get_clocks -of_objects [get_ports S_AXI_ACLK]]




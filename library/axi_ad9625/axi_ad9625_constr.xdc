
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {*/rx_clk}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {*/s_axi_aclk}]]


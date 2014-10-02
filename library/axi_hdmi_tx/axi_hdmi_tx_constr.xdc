
create_clock -period [expr 1000/150] -name hdmi_clk [get_ports hdmi_clk]
create_clock -period [expr 1000/100] -name s_axi_aclk [get_ports s_axi_aclk]
create_clock -period [expr 1000/200] -name m_axis_mm2s_clk [get_ports m_axis_mm2s_clk]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports hdmi_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_axis_mm2s_clk]]



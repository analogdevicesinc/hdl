
if { [get_clocks -quiet -of_objects [get_ports s_axi_aclk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]
}

if { [get_clocks -quiet -of_objects [get_ports m_dest_axi_aclk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_dest_axi_aclk]]
}

if { [get_clocks -quiet -of_objects [get_ports m_src_axi_aclk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_src_axi_aclk]]
}

if { [get_clocks -quiet -of_objects [get_ports s_axis_aclk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axis_aclk]]
}

if { [get_clocks -quiet -of_objects [get_ports m_axis_aclk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_axis_aclk]]
}

if { [get_clocks -quiet -of_objects [get_ports fifo_rd_clk]] != ""}  {
  set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports fifo_rd_clk]]
}

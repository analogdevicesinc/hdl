
create_clock -period [expr 1000/100] -name s_axi_aclk [get_ports s_axi_aclk]
create_clock -period [expr 1000/200] -name fifo_wr_clk [get_ports fifo_wr_clk]
create_clock -period [expr 1000/200] -name fifo_rd_clk [get_ports fifo_rd_clk]
create_clock -period [expr 1000/200] -name m_src_axi_aclk [get_ports m_src_axi_aclk]
create_clock -period [expr 1000/200] -name m_dest_axi_aclk [get_ports m_dest_axi_aclk]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports fifo_wr_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports fifo_rd_clk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_src_axi_aclk]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_ports m_dest_axi_aclk]]




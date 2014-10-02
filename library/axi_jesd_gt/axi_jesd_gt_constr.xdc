
create_clock -period [expr 1000/250] -name rx_clk [get_ports rx_clk]
create_clock -period [expr 1000/250] -name tx_clk [get_ports tx_clk]
create_clock -period [expr 1000/100] -name drp_clk [get_ports drp_clk]
create_clock -period [expr 1000/500] -name ref_clk_c [get_ports ref_clk_c]
create_clock -period [expr 1000/500] -name ref_clk_q [get_ports ref_clk_q]
create_clock -period [expr 1000/100] -name s_axi_aclk [get_ports s_axi_aclk]
create_clock -period [expr 1000/100] -name m_axi_aclk [get_ports m_axi_aclk]

set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports rx_clk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports tx_clk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports drp_clk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports ref_clk_c]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports ref_clk_q]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports m_axi_aclk]]

set_false_path -through [get_nets rx_rst]
set_false_path -through [get_nets tx_rst]
set_false_path -through [get_nets */drp_rst]
set_false_path -through [get_nets */gt_rx_rst]
set_false_path -through [get_nets */gt_tx_rst]
set_false_path -through [get_nets */gt_pll_rst]




set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports rx_clk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports tx_clk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports s_axi_aclk]]
set_clock_group -asynchronous -group [get_clocks -of_objects [get_ports m_axi_aclk]]

set_false_path -through [get_pins */i_up_gt/i_drp_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins */i_up_gt/i_gt_pll_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins */i_up_gt/i_gt_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins */i_up_gt/i_gt_tx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins */i_up_gt/i_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins */i_up_gt/i_tx_rst_reg/i_rst_reg/PRE]



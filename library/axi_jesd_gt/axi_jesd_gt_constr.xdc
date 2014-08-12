
set ip_rx_clk   [get_clocks -of_objects [get_ports rx_clk]]
set ip_tx_clk   [get_clocks -of_objects [get_ports tx_clk]]
set ip_cpu_clk  [get_clocks -of_objects [get_ports s_axi_aclk]]

set_false_path -from $ip_cpu_clk  -to $ip_rx_clk
set_false_path -from $ip_cpu_clk  -to $ip_tx_clk
set_false_path -from $ip_rx_clk   -to $ip_cpu_clk
set_false_path -from $ip_rx_clk   -to $ip_cpu_clk
set_false_path -from $ip_tx_clk   -to $ip_cpu_clk
set_false_path -from $ip_tx_clk   -to $ip_cpu_clk

set_false_path -through [get_pins i_up_gt/i_drp_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_up_gt/i_gt_pll_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_up_gt/i_gt_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_up_gt/i_gt_tx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_up_gt/i_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_up_gt/i_tx_rst_reg/i_rst_reg/PRE]



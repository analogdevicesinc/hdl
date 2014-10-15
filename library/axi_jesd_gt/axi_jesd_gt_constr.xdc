
set_false_path -through [get_nets rx_rst]
set_false_path -through [get_nets tx_rst]
set_false_path -through [get_nets */drp_rst]
set_false_path -through [get_nets */gt_rx_rst]
set_false_path -through [get_nets */gt_tx_rst]
set_false_path -through [get_nets */gt_pll_rst]




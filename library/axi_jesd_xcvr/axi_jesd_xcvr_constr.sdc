
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_rx_sysref_sel*]        -to [get_registers *up_xcvr:i_up_xcvr|rx_sysref_sel_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_rx_sysref*]            -to [get_registers *up_xcvr:i_up_xcvr|rx_up_sysref_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_rx_sync*]              -to [get_registers *up_xcvr:i_up_xcvr|rx_up_sync_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_tx_sysref_sel*]        -to [get_registers *up_xcvr:i_up_xcvr|tx_sysref_sel_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_tx_sysref*]            -to [get_registers *up_xcvr:i_up_xcvr|tx_up_sysref_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_tx_sync*]              -to [get_registers *up_xcvr:i_up_xcvr|tx_up_sync_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|rx_sync*]                 -to [get_registers *up_xcvr:i_up_xcvr|up_rx_status_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|tx_ip_sync*]              -to [get_registers *up_xcvr:i_up_xcvr|up_tx_status_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_rx_reset*]             -to [get_registers *up_xcvr:i_up_xcvr|ad_rst:i_rx_rst_reg|ad_rst_sync_m1*]
set_false_path  -from [get_registers *up_xcvr:i_up_xcvr|up_tx_reset*]             -to [get_registers *up_xcvr:i_up_xcvr|ad_rst:i_tx_rst_reg|ad_rst_sync_m1*]


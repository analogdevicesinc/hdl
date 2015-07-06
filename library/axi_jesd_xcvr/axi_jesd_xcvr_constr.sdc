
set_false_path -from [get_registers *preset*]       -to [get_registers *rst*]
set_false_path -from [get_registers *up_rx_sysref*] -to [get_registers *rx_sysref_m1*]
set_false_path -from [get_registers *up_rx_sync*]   -to [get_registers *rx_sync_m1*]
set_false_path -from [get_registers *rx_sync*]      -to [get_registers *up_rx_status_m1*]
set_false_path -from [get_registers *rx_status*]    -to [get_registers *up_rx_status_m1*]
set_false_path -from [get_registers *up_tx_sysref*] -to [get_registers *tx_sysref_m1*]
set_false_path -from [get_registers *up_tx_sync*]   -to [get_registers *tx_ip_sync_m1*]
set_false_path -from [get_registers *tx_ip_sync*]   -to [get_registers *up_tx_status_m1*]
set_false_path -from [get_registers *tx_status*]    -to [get_registers *up_tx_status_m1*]


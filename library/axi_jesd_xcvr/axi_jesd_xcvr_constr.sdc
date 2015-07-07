
set_false_path -from [get_registers *preset*]       -to [get_registers *rst*]
set_false_path -from [get_registers *up_rx_*]       -to [get_registers *rx_*]
set_false_path -from [get_registers *up_tx_*]       -to [get_registers *tx_*]
set_false_path -from [get_registers *rx_sync*]      -to [get_registers *up_rx_status_m1*]
set_false_path -from [get_registers *rx_status*]    -to [get_registers *up_rx_status_m1*]
set_false_path -from [get_registers *tx_ip_sync*]   -to [get_registers *up_tx_status_m1*]
set_false_path -from [get_registers *tx_status*]    -to [get_registers *up_tx_status_m1*]


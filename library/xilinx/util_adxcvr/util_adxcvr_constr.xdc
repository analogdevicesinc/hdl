
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_rx_rst_done*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_tx_rst_done*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rx_rate*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *tx_rate*}]

set_false_path -to [get_cells -hier -filter {name =~ *up_rx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_tx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *rx_rate_m1_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *tx_rate_m1_reg* && IS_SEQUENTIAL}]



set_false_path -from [get_cells -hier *rx_sync* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *tx_sync_m1* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *rx_sync* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *up_rx_sync_m1* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *rx_pn_err* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *up_rx_pn_err_m1* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *rx_pn_oos* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *up_rx_pn_oos_m1* -filter {primitive_subgroup == flop}]



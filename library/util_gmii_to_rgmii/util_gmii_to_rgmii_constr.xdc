
set_property ASYNC_REG TRUE \
  [get_cells -hier *tx_reset_d1_reg*] \
  [get_cells -hier *tx_reset_sync*]

set_false_path \
  -to [get_cells -hier tx_reset_d1_reg* -filter {primitive_subgroup == flop}]


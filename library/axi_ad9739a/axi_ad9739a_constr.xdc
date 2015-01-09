
set_false_path -from [get_cells *d_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *up_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]
set_false_path -from [get_cells *up_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}] \
  -to [get_cells *d_xfer_* -hierarchical -filter {PRIMITIVE_SUBGROUP == flop}]


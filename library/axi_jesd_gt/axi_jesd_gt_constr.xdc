
set_false_path -from [get_cells -hier *up_*_preset* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *_rst* -filter {primitive_subgroup == flop}]

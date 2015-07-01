
set_false_path -from [get_cells -hier *preset* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *rst* -filter {primitive_subgroup == flop}]

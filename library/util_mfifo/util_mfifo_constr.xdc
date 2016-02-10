
set_property SHREG_EXTRACT NO [get_cells -hier *din_dout_toggle_m*]
set_property SHREG_EXTRACT NO [get_cells -hier *dout_din_toggle_m*]

set_false_path -from [get_cells -hier *dout_toggle* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *din_dout_toggle_m* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *din_toggle* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *dout_din_toggle_m* -filter {primitive_subgroup == flop}]



set_property SHREG_EXTRACT NO [get_cells -hier *din_ovf_m*]
set_property SHREG_EXTRACT NO [get_cells -hier *dout_waddr_rel_t_m*]
set_property SHREG_EXTRACT NO [get_cells -hier *dout_enable_m*]

set_false_path -from [get_cells -hier *dout_ovf_int* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *din_ovf_m* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *din_waddr_rel_t* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *dout_waddr_rel_t_m* -filter {primitive_subgroup == flop}]
set_false_path -from [get_cells -hier *din_enable* -filter {primitive_subgroup == flop}] \
  -to [get_cells -hier *dout_enable_m* -filter {primitive_subgroup == flop}]

set_max_delay -datapath_only -from [get_cells -hier *din_waddr_rel* -filter {primitive_subgroup == flop}] \
	-to [get_cells -hier *dout_waddr_rel* -filter {primitive_subgroup == flop}]  8


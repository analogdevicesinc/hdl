
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rst_sync*}]

set_false_path -to [get_cells -hier -filter {name =~ *rst_sync_d_reg && IS_SEQUENTIAL}]

set_false_path -to [get_pins *rst_sync_reg/PRE]
set_false_path -to [get_pins *rst_async_d1_reg/PRE]
set_false_path -to [get_pins *rst_async_d2_reg/PRE]


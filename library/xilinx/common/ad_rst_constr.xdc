
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rst_async_d*_reg}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *rst_sync_reg}]

set_false_path -to [get_pins *rst_sync_reg/PRE]
set_false_path -to [get_pins *rst_async_d1_reg/PRE]
set_false_path -to [get_pins *rst_async_d2_reg/PRE]


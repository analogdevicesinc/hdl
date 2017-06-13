
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *ad_rst_sync*}]

set_false_path -from [get_cells -hier -filter {name =~ *up_d_preset_reg     && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg     && IS_SEQUENTIAL}]


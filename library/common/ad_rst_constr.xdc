
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *ad_rst_sync*}]


set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *ad_rst_sync*}]

set_false_path -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg     && IS_SEQUENTIAL}]

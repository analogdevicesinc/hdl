# TDD sync false paths
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *tdd_sync_d && IS_SEQUENTIAL}]
set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *tdd_sync_d1_reg && IS_SEQUENTIAL}]

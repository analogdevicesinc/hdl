# constraints

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ */cdc_sync_active/inst/cdc_sync_stage1_reg*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ */cdc_sync_active/inst/cdc_sync_stage2_reg*}]

set_false_path  -to [get_cells -hierarchical -filter {name =~ */cdc_sync_active/inst/cdc_sync_stage1_reg** && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hierarchical -filter {name =~ */cdc_sync_active/inst/cdc_sync_stage2_reg** && IS_SEQUENTIAL}]

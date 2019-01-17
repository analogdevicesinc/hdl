
set_property ASYNC_REG TRUE \
  [get_cells -quiet -hierarchical *cdc_sync_stage1_reg*] \
  [get_cells -quiet -hierarchical *cdc_sync_stage2_reg*]

set_false_path -quiet \
  -from [get_cells -quiet -hierarchical -filter {NAME =~ *cdc_sync_stage0_reg* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hierarchical -filter {NAME =~ *cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -from [get_cells -quiet -hierarchical -filter {NAME =~ *offload0_enable_reg* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hierarchical -filter {NAME =~ *cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -to [get_cells -quiet -hierarchical -filter {NAME =~ *i_offload_enabled_sync/cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -from [get_cells -quiet -hierarchical -filter {NAME =~ *offload0_mem_reset_reg* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hierarchical -filter {NAME =~ *cdc_sync_stage1_reg* && IS_SEQUENTIAL}]


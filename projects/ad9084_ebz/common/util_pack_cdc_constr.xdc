###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE [get_cells -quiet -hier \
  -filter {NAME =~ *_pack_cdc/*cdc_sync_stage*_reg* && IS_SEQUENTIAL}]

set_false_path -quiet -to [get_cells -quiet -hier \
  -filter {NAME =~ *_pack_cdc/*cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path -quiet \
  -from [get_cells -quiet -hier \
    -filter {NAME =~ *_pack_cdc/*i_enable_sync/cdc_hold_reg* && IS_SEQUENTIAL}] \
  -to [get_cells -quiet -hier \
    -filter {NAME =~ *_pack_cdc/*i_enable_sync/out_data_reg* && IS_SEQUENTIAL}]

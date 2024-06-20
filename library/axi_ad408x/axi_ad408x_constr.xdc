###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


set_property ASYNC_REG TRUE \
  [get_cells -quiet -hierarchical *cdc_sync_stage1_reg*] \
  [get_cells -quiet -hierarchical *cdc_sync_stage2_reg*]

set_false_path -quiet \
 -from [get_cells -quiet -hierarchical -filter {NAME =~ *i_address_gray/*cdc_sync_stage0_reg* && IS_SEQUENTIAL}] \
 -to [get_cells -quiet -hierarchical -filter {NAME =~ *i_address_gray/*cdc_sync_stage1_reg* && IS_SEQUENTIAL}]

set_false_path  -from [get_cells -hier -filter {name =~ *up_adc_num_lanes_reg* }]
set_false_path  -from [get_cells -hier -filter {name =~ */i_up_adc_common/i_xfer_cntrl/d_data_cntrl_int_reg[*]* }]

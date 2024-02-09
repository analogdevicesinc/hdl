###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path \
  -from [get_cells -hierarchical * -filter {NAME=~*valid_cdc_sync/out_toggle_d1_reg}] \
  -to [get_cells -hierarchical * -filter {NAME=~*ad408x_interface/valid_cdc_sync/i_sync_in/cdc_sync_stage1_reg[0]}]


set_false_path  -from [get_cells -hier -filter {name =~ *up_adc_num_lanes_reg* }]

set_false_path \
  -from [get_cells -hierarchical * -filter {NAME=~*valid_cdc_sync/in_toggle_d1_reg}] \
  -to [get_cells -hierarchical * -filter {NAME=~*ad408x_interface/valid_cdc_sync/i_sync_out/cdc_sync_stage1_reg[0]}]

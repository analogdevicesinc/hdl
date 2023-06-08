###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE \
  [get_cells -hier {*cdc_sync_stage1_reg*}] \
  [get_cells -hier {*cdc_sync_stage2_reg*}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_driver_otw_sync/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_pulse_sync/cdc_sync_stage1_reg[0]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_sequencer_sync/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_sequence_offset_sync/cdc_sync_stage1_reg[*]/D}]

set_false_path \
  -to [get_pins -hierarchical * -filter {NAME=~*i_sequence_control_sync/cdc_sync_stage1_reg[*]/D}]


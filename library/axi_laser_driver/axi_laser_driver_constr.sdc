###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path \
  -to [get_registers *i_driver_otw_sync|cdc_sync_stage1*]

set_false_path \
  -to [get_registers *i_pulse_sync|cdc_sync_stage1*]

set_false_path \
  -to [get_registers *i_sequencer_sync|cdc_sync_stage1[*]]

set_false_path \
  -to [get_registers *i_sequence_offset_sync|cdc_sync_stage1[*]]

set_false_path \
  -to [get_registers *i_sequence_control_sync|cdc_sync_stage1[*]]


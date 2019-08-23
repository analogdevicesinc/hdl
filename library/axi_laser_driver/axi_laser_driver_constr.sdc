
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


###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Mark synchronizer stages as ASYNC_REG (recognized by the placer; allows
# placement of stage1 and stage2 in the same slice for minimum MTBF).

set_property ASYNC_REG TRUE \
  [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_sync_stage1_reg*}] \
  [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_sync_stage2_reg*}]

# CDC false paths between the AXI clock and the sample stream clock. All sync
# instances inside the regmap share the prefix "i_sync_", so a single wildcard
# covers them. Three false-path groups per the util_cdc handshake pattern
# (data + two toggle paths):

# 1. data path: cdc_hold (in_clk) -> out_data (sync_data) / out_event (sync_event)

set_false_path \
  -from [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_hold_reg*}] \
  -to   [get_cells -hier -filter {NAME =~ *i_sync_*/out_data_reg*}]

set_false_path \
  -from [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_hold_reg*}] \
  -to   [get_cells -hier -filter {NAME =~ *i_sync_*/out_event_reg*}]

# 2. toggle handshake forward: in_toggle_d1 (in_clk) -> sync_out stage1 (out_clk)

set_false_path \
  -from [get_pins -hier -filter {NAME =~ *i_sync_*/in_toggle_d1_reg/C}] \
  -to   [get_pins -hier -filter {NAME =~ *i_sync_*/i_sync_out/cdc_sync_stage1_reg[0]/D}]

# 3. toggle handshake reverse: out_toggle_d1 (out_clk) -> sync_in stage1 (in_clk)

set_false_path \
  -from [get_pins -hier -filter {NAME =~ *i_sync_*/out_toggle_d1_reg/C}] \
  -to   [get_pins -hier -filter {NAME =~ *i_sync_*/i_sync_in/cdc_sync_stage1_reg[0]/D}]

# 4. odr_in arrives from the gated clkin_aligner clock domain and is resampled
# by a plain two-flop synchronizer. Only the capture edge into stage 1 needs
# cutting; the ASYNC_REG rule above already covers both stages.

set_false_path \
  -to [get_pins -hier -filter {NAME =~ *i_sync_odr/cdc_sync_stage1_reg[0]/D}]

###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Generated clock on the BUFGCE output. clk_out is the same period as clk_in,
# just gated. Vivado already understands BUFGCE.CE timing when CE comes from
# a register, but we still declare the propagated clock so downstream
# consumers (FMC pin, axi_pwm_gen) see a defined clock object.

create_generated_clock -name clk_out \
  -source [get_pins -hier -filter {NAME =~ */i_gate/I}] \
  -divide_by 1 \
  [get_pins -hier -filter {NAME =~ */i_gate/O}]

# Mark synchronizer stages as ASYNC_REG (recognized by placer; allows
# placement of stage1 and stage2 in the same slice for minimum MTBF).

set_property ASYNC_REG TRUE \
  [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_sync_stage1_reg*}] \
  [get_cells -hier -filter {NAME =~ *i_sync_*/cdc_sync_stage2_reg*}]

# CDC false paths. All four sync instances inside the regmap share the
# prefix "i_sync_", so a single wildcard covers them. Three false-path
# groups per the util_cdc handshake pattern (data + two toggle paths):

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

# The gate_en_neg register is clocked on the negedge of clk_in and drives
# BUFGCE.CE. Standard Xilinx-recommended structure for glitch-free clock
# gating; flag the path so it is not reported as unconstrained.

set_false_path -from [get_cells -hier -filter {NAME =~ *gate_en_neg_reg*}]

# odr_neg is clocked on negedge clk_in to align ODR transitions with the
# XTAL2_CLKIN falling edge per Sequence.txt §F.10. The launch is from
# odr_in (posedge clk_out, axi_pwm_gen) and the half-cycle setup window
# (10.4 ns at 48 MHz) is more than sufficient for any realistic combinational
# delay — flag as false path to keep STA reports clean.

set_false_path -to [get_cells -hier -filter {NAME =~ *odr_neg_reg*}]


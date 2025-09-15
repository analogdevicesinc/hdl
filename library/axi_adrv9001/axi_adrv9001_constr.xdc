###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property ASYNC_REG TRUE \
  [get_cells -hier {*cdc_sync_stage1_reg*}] \
  [get_cells -hier {*cdc_sync_stage2_reg*}]

set_false_path -quiet -from [get_cells -quiet -hier *in_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]
set_false_path -quiet -from [get_cells -quiet -hier *out_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]

set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEOUT]
set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEIN]


# async reset assertion with synchronous bringup
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_*x_*_phy/bufdiv_clr_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_*x_*_phy/reset_*reg/PRE}]

# sync bits i_rx1_ctrl_sync
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_rx1_ctrl_sync* && IS_SEQUENTIAL}]

# sync bits i_tx1_ctrl_sync
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_tx1_ctrl_sync* && IS_SEQUENTIAL}]

# sync bits i_txn/i_rate_sync_in
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_rate_sync_in* && IS_SEQUENTIAL}]

# mssi_sync is used as an asynchronous reset signal with synchronous reset deasertion
# the serial interface clock is derived from ref_clk
set_max_delay -datapath_only \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/mssi_sync_reg*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_*_phy/mssi_sync_d1*}] 6.0

set_min_delay \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/mssi_sync_reg*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_*_phy/mssi_sync_d1*}] 4.0

## transfer sync event i_rx1/2_external_sync
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/transfer_busy*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_core/adc_*_transfer_sync_d1_reg/D}]

# transfer sync event i_tx_1/2_external_sync
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/transfer_busy*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_core/dac_*_transfer_sync_d*/D}]

# workaround
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*_common/up_*c_r1_mode_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_core/*_r1_mode_d_reg*/D}]

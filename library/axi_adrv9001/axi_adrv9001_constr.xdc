set_property ASYNC_REG TRUE \
  [get_cells -hier {*cdc_sync_stage1_reg*}] \
  [get_cells -hier {*cdc_sync_stage2_reg*}]

set_false_path -quiet -from [get_cells -quiet -hier *in_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]
set_false_path -quiet -from [get_cells -quiet -hier *out_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]

set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEOUT]
set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEIN]

# sync bits i_rx1_ctrl_sync
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_rx1_ctrl_sync* && IS_SEQUENTIAL}]

# sync bits i_tx1_ctrl_sync
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_tx1_ctrl_sync* && IS_SEQUENTIAL}]

# transfer sync event i_rx/tx_1/2_external_sync
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_*_external_sync/out_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_*_external_sync/i_sync_in/cdc_sync_stage1_reg[0]/D}]
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_*_external_sync/in_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_*_external_sync/i_sync_out/cdc_sync_stage1_reg[0]/D}]

# sync bits i_txn/i_rate_sync_in
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_rate_sync_in* && IS_SEQUENTIAL}]

# sync bits mcs_to_strobe - i_if/i_rx*_phy/i_mcs_sync_in
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_if/i_rx*_phy/i_mcs_sync_in* && IS_SEQUENTIAL}]

# sync bits strobe event
set_false_path \
  -to [get_cells -quiet -hier *cdc_sync_stage1_reg* \
    -filter {NAME =~ *i_if/i_rx*_phy/i_strobe_event* && IS_SEQUENTIAL}]

# mssi_sync is used as an asynchronous reset signal, when it will de-assert(mcs 5'th pulse stage),
# all if clocks should be off, so false path it is considered safe as synchronous reset deasertion
# phy layer
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/if_sync*}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_*_phy/*}]

# link layer
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/if_sync*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_rx_*_link/*/R}]
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_sync/if_sync*/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_if/i_rx_*_link/*/CE}]

# debug false path
set_false_path -from [get_pins -hierarchical * -filter {NAME=~*/i_sync/mcs_out_reg/C}]\
  -to [get_pins -hierarchical * -filter {NAME=~*/inst/*_clk*_cnt_reg*/R}]


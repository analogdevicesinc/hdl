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

# sync event i_rx_external_sync
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_rx_external_sync/out_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_rx_external_sync/i_sync_in/cdc_sync_stage1_reg[0]/D}]
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_rx_external_sync/in_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_rx_external_sync/i_sync_out/cdc_sync_stage1_reg[0]/D}]

# sync event i_tx_external_sync
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_tx_external_sync/out_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_tx_external_sync/i_sync_in/cdc_sync_stage1_reg[0]/D}]
set_false_path \
  -from [get_pins -hierarchical * -filter {NAME=~*i_tx_external_sync/in_toggle_d1_reg/C}] \
  -to [get_pins -hierarchical * -filter {NAME=~*i_tx_external_sync/i_sync_out/cdc_sync_stage1_reg[0]/D}]

# mssi_sync
set_false_path \
  -to [get_cells -quiet -hier *mssi_sync_d_reg* \
    -filter {NAME =~ *i_*_phy* && IS_SEQUENTIAL}]

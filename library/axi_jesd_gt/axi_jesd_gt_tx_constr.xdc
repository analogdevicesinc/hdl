
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_rst_done*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_pll_locked*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_status*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/tx_sysref_sel*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/tx_up_sysref*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/tx_up_sync*}]

set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_rst_done_m_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_pll_locked_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_pll_locked_m_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_tx_status_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/tx_sysref_sel_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/tx_up_sysref_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/tx_up_sync_m1_reg && IS_SEQUENTIAL}]

set_false_path -from [get_cells -hier -filter {name =~ *up_tx_preset_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg && IS_SEQUENTIAL}]


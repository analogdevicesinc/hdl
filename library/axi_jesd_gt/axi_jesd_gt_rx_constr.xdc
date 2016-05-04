
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_rst_done*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_pll_locked*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_status*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/rx_sysref_sel*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/rx_up_sysref*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *i_channel/i_up/rx_up_sync*}]

set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_rst_done_m_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_pll_locked_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_pll_locked_m_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/up_rx_status_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/rx_sysref_sel_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/rx_up_sysref_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *i_channel/i_up/rx_up_sync_m1_reg && IS_SEQUENTIAL}]

set_false_path -from [get_cells -hier -filter {name =~ *up_rx_preset_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg && IS_SEQUENTIAL}]


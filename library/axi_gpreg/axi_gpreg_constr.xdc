
set_property shreg_extract no [get_cells -hier -filter {name =~ *ad_rst_sync*}]

set_false_path -from [get_cells -hier -filter {name =~ *d_count_toggle_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_count_toggle_m1_reg && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *d_count_hold*       && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_d_count*            && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_count_toggle_reg && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_count_toggle_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_d_preset_reg     && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg     && IS_SEQUENTIAL}]


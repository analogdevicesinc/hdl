
set_property ASYNC_REG TRUE \
  [get_cells -hier *xfer_toggle_*] \
  [get_cells -hier *xfer_state_*] \
  [get_cells -hier *count_toggle_m*] \
  [get_cells -hier *ad_rst_sync_*]

set_false_path -from [get_cells -hier -filter {name =~ *d_xfer_toggle_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_xfer_state_m1_reg   && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_xfer_toggle_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_xfer_toggle_m1_reg   && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_xfer_data*       && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_data_cntrl*          && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_xfer_toggle_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_xfer_state_m1_reg    && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *d_xfer_toggle_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_xfer_toggle_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *d_xfer_data*        && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_data_status*        && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *d_count_toggle_reg  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_count_toggle_m1_reg && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *d_count_hold*       && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *up_d_count*            && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_count_toggle_reg && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *d_count_toggle_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_*preset_reg      && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *ad_rst_sync_m1_reg     && IS_SEQUENTIAL}]


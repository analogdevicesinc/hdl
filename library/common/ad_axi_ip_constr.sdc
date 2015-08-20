
set_false_path  -from [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|d_xfer_toggle*]      -to [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|up_xfer_state_m1*]
set_false_path  -from [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|up_xfer_toggle*]     -to [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|d_xfer_toggle_m1*]
set_false_path  -from [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|up_xfer_data*]       -to [get_registers *up_xfer_cntrl:i_*_xfer_cntrl|d_data_cntrl*]
set_false_path  -from [get_registers *up_xfer_status:i_*_xfer_status|up_xfer_toggle*]   -to [get_registers *up_xfer_status:i_*_xfer_status|d_xfer_state_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_*_xfer_status|d_xfer_toggle*]    -to [get_registers *up_xfer_status:i_*_xfer_status|up_xfer_toggle_m1*]
set_false_path  -from [get_registers *up_xfer_status:i_*_xfer_status|d_xfer_data*]      -to [get_registers *up_xfer_status:i_*_xfer_status|up_data_status*] 
set_false_path  -from [get_registers *up_clock_mon:i_*_clock_mon|d_count_toggle*]       -to [get_registers *up_clock_mon:i_*_clock_mon|up_count_toggle_m1*]
set_false_path  -from [get_registers *up_clock_mon:i_*_clock_mon|d_count_hold*]         -to [get_registers *up_clock_mon:i_*_clock_mon|up_d_count*]
set_false_path  -from [get_registers *up_clock_mon:i_*_clock_mon|up_count_toggle*]      -to [get_registers *up_clock_mon:i_*_clock_mon|d_count_toggle_m1*]
set_false_path  -from [get_registers *up_*_common:i_up_*_common|up_core_preset*]        -to [get_registers *up_*_common:i_up_*_common|ad_rst:i_core_rst_reg|ad_rst_sync_m1*]


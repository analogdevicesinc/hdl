
set_false_path  -from [get_registers *up_clock_mon:i_clock_mon|d_count_toggle*]       -to [get_registers *up_clock_mon:i_clock_mon|up_count_toggle_m1*]
set_false_path  -from [get_registers *up_clock_mon:i_clock_mon|d_count_hold*]         -to [get_registers *up_clock_mon:i_clock_mon|up_d_count*]
set_false_path  -from [get_registers *up_clock_mon:i_clock_mon|up_count_toggle*]      -to [get_registers *up_clock_mon:i_clock_mon|d_count_toggle_m1*]

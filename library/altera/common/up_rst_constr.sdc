
set_false_path  -from [get_registers *up_*rst_async*] -to [get_registers *ad_rst:i_core_rst_reg|rst_sync_d]
set_false_path  -from [get_registers *up_*rst_async*] -to [get_registers *ad_rst:i_core_rst_reg|rstn]


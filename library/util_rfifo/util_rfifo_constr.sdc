
set_false_path -from [get_registers *dout_enable*]  -to [get_registers *din_enable_m1*]
set_false_path -from [get_registers *dout_req_t*]   -to [get_registers *din_req_t_m1*]
set_false_path -from [get_registers *din_unf*]      -to [get_registers *dout_unf_m1*]


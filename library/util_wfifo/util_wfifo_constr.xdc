
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dout_enable_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *dout_req_t_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *din_ovf_m*}]

set_false_path -from [get_cells -hier -filter {name =~ *din_enable* && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dout_enable_m1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *din_req_t*  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dout_req_t_m1*  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *din_rinit*  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dout_rinit*     && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dout_ovf*   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *din_ovf_m1*     && IS_SEQUENTIAL}]


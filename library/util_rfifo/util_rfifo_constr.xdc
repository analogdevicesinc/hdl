
set_property shreg_extract no [get_cells -hier -filter {name =~ *din_enable_m*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *din_req_t_m*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *dout_unf_m*}]

set_false_path -from [get_cells -hier -filter {name =~ *dout_enable*  && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *din_enable_m1*  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dout_req_t*   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *din_req_t_m1*   && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *dout_rinit*   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *din_rinit*      && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *din_unf*      && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *dout_unf_m1*    && IS_SEQUENTIAL}]


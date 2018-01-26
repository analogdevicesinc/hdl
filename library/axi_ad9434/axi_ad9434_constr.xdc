set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *adc_drp_locked_m1*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *adc_delay_locked_m1*}]

set_false_path  -from [get_cells -hier -filter {name =~ *up_drp_locked_reg && IS_SEQUENTIAL}] -to \
[get_cells -hier -filter {name =~ *adc_drp_locked_m1_reg && IS_SEQUENTIAL}]
set_false_path  -from [get_cells -hier -filter {name =~ *delay_locked_reg && IS_SEQUENTIAL}] -to \
[get_cells -hier -filter {name =~ *adc_delay_locked_m1_reg && IS_SEQUENTIAL}]

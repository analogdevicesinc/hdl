set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *trigger_i_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *trigger_adc_m*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *trigger_la_m*}]

set_false_path  -to [get_cells -hier -filter {name =~ *trigger_i_m1_reg* && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *trigger_adc_m1_reg* && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *trigger_la_m1_reg* && IS_SEQUENTIAL}]


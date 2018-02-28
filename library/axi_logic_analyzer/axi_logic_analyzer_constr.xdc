set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_triggered_d*}]
set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *up_triggered_reset_d*}]

set_false_path  -to [get_pins BUFGMUX_CTRL_inst/S*]

set_false_path  -to [get_cells -hier -filter {name =~ *up_triggered_d1*       && IS_SEQUENTIAL}]
set_false_path  -to [get_cells -hier -filter {name =~ *up_triggered_reset_d1* && IS_SEQUENTIAL}]

set_false_path -from [get_cells -hier -filter {name =~ *up_*ce_reg*      && IS_SEQUENTIAL}] -to [get_pins -hier -filter {name =~ *bufgctrl*/S0}]

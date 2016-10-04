set_false_path  -from [get_cells -hier -filter {name =~ *up_drp_locked_reg && IS_SEQUENTIAL}] -to \
[get_cells -hier -filter {name =~ *adc_status_m1_reg && IS_SEQUENTIAL}]

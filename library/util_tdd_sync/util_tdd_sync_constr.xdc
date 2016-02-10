
set_false_path -to [get_cells -hier -filter {NAME =~ *sync_mode_d1* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {NAME =~ *sync_out_reg* && IS_SEQUENTIAL}]


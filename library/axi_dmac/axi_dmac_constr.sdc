
set_false_path -to [get_registers *cdc_sync_stage1*]
set_false_path -from [get_registers *cdc_sync_fifo_ram*]
set_false_path -from [get_registers *eot_mem*]
set_false_path -to [get_registers *reset_shift*]
set_false_path -to [get_registers *ram*]
set_false_path -from [get_registers *cdc_sync_stage2*] -to [get_registers *up_rdata*]
set_false_path -from [get_registers *id*] -to [get_registers *up_rdata*]
set_false_path -from [get_registers *address*] -to [get_registers *up_rdata*]









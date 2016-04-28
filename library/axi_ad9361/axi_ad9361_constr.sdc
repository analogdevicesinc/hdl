
set_false_path -from [get_registers *i_dev_if|up_enable_int*] -to [get_registers *i_dev_if|enable_up_m1*]
set_false_path -from [get_registers *i_dev_if|up_txnrx_int*]  -to [get_registers *i_dev_if|txnrx_up_m1*]


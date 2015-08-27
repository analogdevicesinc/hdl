
set_property shreg_extract no [get_cells -hier -filter {name =~ *enable_up*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *txnrx_up*}]

set_false_path -from [get_cells -hier -filter {name =~ *up_enable_int_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *enable_up_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_txnrx_int_reg    && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *txnrx_up_m1_reg   && IS_SEQUENTIAL}]


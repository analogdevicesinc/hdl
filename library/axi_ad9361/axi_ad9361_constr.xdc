
set_property ASYNC_REG TRUE \
  [get_cells -hier *enable_up_*] \
  [get_cells -hier *txnrx_up_*] \
  [get_cells -hier *tdd_sync_d*]

set_false_path -from [get_cells -hier -filter {name =~ *up_enable_int_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *enable_up_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_txnrx_int_reg    && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *txnrx_up_m1_reg   && IS_SEQUENTIAL}]
set_false_path -quiet -to [get_cells -quiet -hier -filter {name =~ *tdd_sync_d1_reg   && IS_SEQUENTIAL}]


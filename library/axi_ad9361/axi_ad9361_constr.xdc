
set_property ASYNC_REG TRUE \
  [get_cells -hier *enable_up_*] \
  [get_cells -hier *txnrx_up_*] \
  [get_cells -hier *tdd_sync_d*]

set_false_path -from [get_cells -hier -filter {name =~ *up_enable_int_reg   && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *enable_up_m1_reg  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *up_txnrx_int_reg    && IS_SEQUENTIAL}] -to [get_cells -hier -filter {name =~ *txnrx_up_m1_reg   && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *tdd_sync_d1_reg   && IS_SEQUENTIAL}]

set_property ASYNC_REG TRUE \
  [get_cells -hier *_pps_m*] \
  [get_cells -hier *_pps_status_m*]

set_false_path -to [get_cells -hier -filter {name =~ *_pps_m_reg[0]  && IS_SEQUENTIAL}]
set_false_path -from [get_cells -hier -filter {name =~ *pps_status_reg  && IS_SEQUENTIAL}] \
               -to   [get_cells -hier -filter {name =~ *up_pps_status_m_reg  && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_pps_rcounter_reg*  && IS_SEQUENTIAL}]


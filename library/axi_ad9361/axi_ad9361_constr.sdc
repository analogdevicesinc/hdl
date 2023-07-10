###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_false_path -from [get_registers *i_dev_if|up_enable_int*] -to [get_registers *i_dev_if|enable_up_m1*]
set_false_path -from [get_registers *i_dev_if|up_txnrx_int*]  -to [get_registers *i_dev_if|txnrx_up_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_xfer_toggle*]   -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_state_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_toggle*]  -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_xfer_toggle_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_data*]    -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_data_cntrl*]


###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

set_false_path -from [get_registers *i_dev_if|up_enable_int*] -to [get_registers *i_dev_if|enable_up_m1*]
set_false_path -from [get_registers *i_dev_if|up_txnrx_int*]  -to [get_registers *i_dev_if|txnrx_up_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_xfer_toggle*]   -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_state_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_toggle*]  -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_xfer_toggle_m1*]
set_false_path -from [get_registers *up_xfer_cntrl:i_xfer_tdd_control|up_xfer_data*]    -to [get_registers *up_xfer_cntrl:i_xfer_tdd_control|d_data_cntrl*]

util_cdc_sync_bits_constr {*|sync_bits:i_rx1_ctrl_sync}
util_cdc_sync_bits_constr {*|sync_bits:i_tx1_ctrl_sync}


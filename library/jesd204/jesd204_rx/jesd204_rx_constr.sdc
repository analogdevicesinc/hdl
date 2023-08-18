###############################################################################
## Copyright (C) 2017, 2020, 2021 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

# SYNC~ is a asynchronous interface
set_false_path \
  -from [get_registers *|jesd204_rx_ctrl:i_rx_ctrl|sync_n[0]]

util_cdc_sync_bits_constr {*|sync_bits:i_all_buffer_ready_cdc}
util_cdc_sync_event_constr {*|sync_event:i_sync_lmfc}

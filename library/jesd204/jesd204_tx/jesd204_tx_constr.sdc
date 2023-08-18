###############################################################################
## Copyright (C) 2017, 2021 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

# SYNC~ is a asynchronous interface
util_cdc_sync_bits_constr {*|jesd204_tx_ctrl:i_tx_ctrl|sync_bits:i_cdc_sync}

util_cdc_sync_event_constr {*|sync_event:dual_lmfc_mode.i_sync_lmfc}
util_cdc_sync_bits_constr {*|sync_bits:dual_lmfc_mode.i_next_mf_ready_cdc}
util_cdc_sync_bits_constr {*|sync_bits:dual_lmfc_mode.i_link_reset_done_cdc}
util_cdc_sync_bits_constr {*|sync_bits:i_sync_ready}

set_false_path -to *|dual_lmfc_mode.i_link_reset_done_cdc|cdc_sync_stage1[0]~RTM

## gearbox on distributed RAM
#set_false_path -from *|dual_lmfc_mode.i_tx_gearbox|mem* -to *|dual_lmfc_mode.i_tx_gearbox|mem_rd_data*

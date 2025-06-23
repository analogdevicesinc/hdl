###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

util_cdc_sync_bits_constr {*|sync_bits:i_pll_locked_cdc}
util_cdc_sync_bits_constr {*|sync_bits:i_rx_lockedtodata_cdc}
util_cdc_sync_bits_constr {*|sync_bits:i_ready_cdc}
util_cdc_sync_bits_constr {*|sync_bits:i_reset_ack_cdc}
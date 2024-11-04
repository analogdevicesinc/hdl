###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

util_cdc_sync_bits_constr {*|data_offload_fsm:i_data_offload_fsm|sync_bits:i_rd_init_req_sync}
util_cdc_sync_bits_constr {*|data_offload_fsm:i_data_offload_fsm|sync_bits:i_wr_init_req_sync}
util_cdc_sync_bits_constr {*|data_offload_fsm:i_data_offload_fsm|sync_bits:i_sync_wr_sync}
util_cdc_sync_bits_constr {*|data_offload_fsm:i_data_offload_fsm|sync_bits:i_sync_rd_sync}
util_cdc_sync_bits_constr {*|data_offload_regmap:i_regmap|sync_bits:i_src_xfer_control}
util_cdc_sync_bits_constr {*|data_offload_regmap:i_regmap|sync_bits:i_dst_xfer_control}
util_cdc_sync_bits_constr {*|data_offload_regmap:i_regmap|sync_bits:i_ddr_calib_done_sync}
util_cdc_sync_bits_constr {*|data_offload_regmap:i_regmap|sync_bits:i_dst_oneshot_sync}

util_cdc_sync_data_constr {*|data_offload_regmap:i_regmap|sync_data:i_dst_fsm_status}
util_cdc_sync_data_constr {*|data_offload_regmap:i_regmap|sync_data:i_src_fsm_status}
util_cdc_sync_data_constr {*|data_offload_regmap:i_regmap|sync_data:sync_*_path.i_sync_xfer_control}
util_cdc_sync_data_constr {*|data_offload_regmap:i_regmap|sync_data:i_sync_src_transfer_length}
util_cdc_sync_data_constr {*|data_offload_regmap:i_regmap|sync_data:i_sync_dst_transfer_length}

util_cdc_sync_event_constr {*|data_offload_fsm:i_data_offload_fsm|sync_event:i_wr_empty_sync}

set_false_path -from [get_registers *data_offload*cdc_sync_fifo_ram*]
set_false_path -to [get_registers *i_waddr_sync|cdc_sync_stage1[*]]
set_false_path -to [get_registers *i_raddr_sync|cdc_sync_stage1[*]]
set_false_path -to [get_registers *i_waddr_sync_gray|cdc_sync_stage1[*]]
set_false_path -to [get_registers *i_raddr_sync_gray|cdc_sync_stage1[*]]

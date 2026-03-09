###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|sync_bits:i_sync_status_dest}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|sync_bits:i_sync_control_dest}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|sync_bits:i_sync_req_response_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|axi_dmac_response_manager:i_response_manager|util_axis_fifo:i_dest_response_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|axi_dmac_response_manager:i_response_manager|util_axis_fifo:i_dest_response_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|axi_dmac_burst_memory:i_store_and_forward|sync_bits:i_dest_sync_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|axi_dmac_burst_memory:i_store_and_forward|sync_bits:i_src_sync_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|util_axis_fifo:i_dest_req_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|util_axis_fifo:i_dest_req_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_dest_bl_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_wr_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_dest_bl_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|sync_bits:i_sync_status_src}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|sync_bits:i_sync_control_src}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|sync_bits:i_sync_src_request_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_req_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_req_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_rewind_req_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_rewind_req_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|axi_dmac_burst_memory:i_store_and_forward|sync_bits:i_dest_sync_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|axi_dmac_burst_memory:i_store_and_forward|sync_bits:i_src_sync_id}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_dest_req_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_dest_req_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_dest_bl_fifo|sync_bits:zerodeep.i_waddr_sync}
util_cdc_sync_bits_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|util_axis_fifo:i_src_dest_bl_fifo|sync_bits:zerodeep.i_raddr_sync}
util_cdc_sync_event_constr {*|axi_dmac_transfer:[*].i_rd_transfer|request_arb:i_request_arb|sync_event:sync_rewind}

set_false_path -from [get_registers *i_wr_transfer*i_dest_response_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_wr_transfer*i_dest_req_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_wr_transfer*i_src_dest_bl_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_wr_transfer*i_request_arb*i_store_and_forward*burst_len_mem*]
set_false_path -from [get_registers *i_wr_transfer*i_request_arb*i_store_and_forward*i_mem*m_ram*]
set_false_path -from [get_registers *i_wr_transfer*i_request_arb*eot_mem_dest*]
set_false_path -from [get_registers *i_rd_transfer*i_dest_req_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_rd_transfer*i_src_dest_bl_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_rd_transfer*i_request_arb*eot_mem_src*]
set_false_path -from [get_registers *i_rd_transfer*i_src_req_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_rd_transfer*i_rewind_req_fifo*cdc_sync_fifo_ram*]
set_false_path -from [get_registers *i_rd_transfer*i_request_arb*i_store_and_forward*burst_len_mem*]
set_false_path -from [get_registers *i_rd_transfer*i_request_arb*i_store_and_forward*i_mem*m_ram*]
set_false_path -from [get_registers *i_rd_transfer*i_request_arb*eot_mem_dest*]

set_false_path -to    [get_registers *axi_dmac*cdc_sync_stage1*]
set_false_path -from  [get_registers *axi_dmac*cdc_sync_fifo_ram*]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|do_reset}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[*]|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to   [get_registers {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[3]}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_wr_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|do_reset}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[*]|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to   [get_registers {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[3]}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_async[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

set_false_path \
  -from [get_registers {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync[0]}] \
  -to [get_pins -compatibility_mode {*|axi_dmac_transfer:[*].i_rd_transfer|axi_dmac_reset_manager:i_reset_manager|reset_gen[*].reset_sync_in|clrn}]

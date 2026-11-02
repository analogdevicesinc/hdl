###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the axi_dmac HDL sources for later HDL+ core packaging.
# Sourced within an open Libero project before the helper creates the wrapper.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set src_file [file join $script_dir axi_dmac.v]

import_files \
  -library work \
  -hdl_source $src_file \
  -hdl_source [file join $ad_hdl_dir library common ad_mem_asym.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_mem.v] \
  -hdl_source [file join $ad_hdl_dir library common up_apb.v] \
  -hdl_source [file join $ad_hdl_dir library common up_axi.v] \
  -hdl_source [file join $ad_hdl_dir library util_axis_fifo util_axis_fifo.v] \
  -hdl_source [file join $ad_hdl_dir library util_axis_fifo util_axis_fifo_address_generator.v] \
  -hdl_source [file join $ad_hdl_dir library util_cdc sync_bits.v] \
  -hdl_source [file join $ad_hdl_dir library util_cdc sync_event.v] \
  -hdl_source [file join $ad_hdl_dir library util_cdc sync_gray.v] \
  -hdl_source [file join $script_dir inc_id.vh] \
  -hdl_source [file join $script_dir resp.vh] \
  -hdl_source [file join $script_dir address_generator.v] \
  -hdl_source [file join $script_dir axi_dmac_burst_memory.v] \
  -hdl_source [file join $script_dir axi_dmac_ext_sync.v] \
  -hdl_source [file join $script_dir axi_dmac_framelock.v] \
  -hdl_source [file join $script_dir axi_dmac_regmap.v] \
  -hdl_source [file join $script_dir axi_dmac_regmap_request.v] \
  -hdl_source [file join $script_dir axi_dmac_reset_manager.v] \
  -hdl_source [file join $script_dir axi_dmac_resize_dest.v] \
  -hdl_source [file join $script_dir axi_dmac_resize_src.v] \
  -hdl_source [file join $script_dir axi_dmac_response_manager.v] \
  -hdl_source [file join $script_dir axi_dmac_transfer.v] \
  -hdl_source [file join $script_dir axi_register_slice.v] \
  -hdl_source [file join $script_dir data_mover.v] \
  -hdl_source [file join $script_dir dest_axi_mm.v] \
  -hdl_source [file join $script_dir dest_axi_stream.v] \
  -hdl_source [file join $script_dir dest_fifo_inf.v] \
  -hdl_source [file join $script_dir dmac_2d_transfer.v] \
  -hdl_source [file join $script_dir dmac_sg.v] \
  -hdl_source [file join $script_dir request_arb.v] \
  -hdl_source [file join $script_dir request_generator.v] \
  -hdl_source [file join $script_dir response_generator.v] \
  -hdl_source [file join $script_dir response_handler.v] \
  -hdl_source [file join $script_dir splitter.v] \
  -hdl_source [file join $script_dir src_axi_mm.v] \
  -hdl_source [file join $script_dir src_axi_stream.v] \
  -hdl_source [file join $script_dir src_fifo_inf.v]
build_design_hierarchy

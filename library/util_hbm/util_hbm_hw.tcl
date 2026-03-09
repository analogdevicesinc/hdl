###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME util_hbm
set_module_property DISPLAY_NAME "ADI AXIS to HBM/DDR AXI bridge"
set_module_property DESCRIPTION "Bridge between a AXI Stream master/slave interface and an AXI Memory Mapped interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"

# files

ad_ip_files util_hbm [list \
  $ad_hdl_dir/library/axi_dmac/inc_id.vh \
  $ad_hdl_dir/library/axi_dmac/resp.vh \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_burst_memory.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_ext_sync.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_reset_manager.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_resize_dest.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_resize_src.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_response_manager.v \
  $ad_hdl_dir/library/axi_dmac/axi_dmac_transfer.v \
  $ad_hdl_dir/library/axi_dmac/axi_register_slice.v \
  $ad_hdl_dir/library/axi_dmac/address_generator.v \
  $ad_hdl_dir/library/axi_dmac/data_mover.v \
  $ad_hdl_dir/library/axi_dmac/dest_axi_mm.v \
  $ad_hdl_dir/library/axi_dmac/dest_axi_stream.v \
  $ad_hdl_dir/library/axi_dmac/request_arb.v \
  $ad_hdl_dir/library/axi_dmac/request_generator.v \
  $ad_hdl_dir/library/axi_dmac/response_generator.v \
  $ad_hdl_dir/library/axi_dmac/response_handler.v \
  $ad_hdl_dir/library/axi_dmac/splitter.v \
  $ad_hdl_dir/library/axi_dmac/src_axi_mm.v \
  $ad_hdl_dir/library/axi_dmac/src_axi_stream.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/common/ad_mem_asym.v \
  util_hbm.v \
  util_hbm_constr.sdc \
]

# parameters

ad_ip_parameter TX_RX_N                 INTEGER 1
ad_ip_parameter SRC_DATA_WIDTH          INTEGER 512
ad_ip_parameter DST_DATA_WIDTH          INTEGER 512
ad_ip_parameter LENGTH_WIDTH            INTEGER 32
ad_ip_parameter AXI_PROTOCOL            INTEGER 0
ad_ip_parameter AXI_DATA_WIDTH          INTEGER 256
ad_ip_parameter AXI_ADDR_WIDTH          INTEGER 32
ad_ip_parameter MEM_TYPE                INTEGER 2
ad_ip_parameter HBM_SEGMENTS_PER_MASTER INTEGER 4
ad_ip_parameter HBM_SEGMENT_INDEX       INTEGER 0
ad_ip_parameter DDR_BASE_ADDDRESS       INTEGER 0
ad_ip_parameter NUM_M                   INTEGER 2
ad_ip_parameter SRC_FIFO_SIZE           INTEGER 8
ad_ip_parameter DST_FIFO_SIZE           INTEGER 8

# axis destination/source

ad_interface clock m_axis_aclk input 1
ad_interface reset-n m_axis_aresetn input 1 if_m_axis_aclk

add_interface m_axis axi4stream start
set_interface_property m_axis associatedClock if_m_axis_aclk
set_interface_property m_axis associatedReset if_m_axis_aresetn
add_interface_port m_axis  m_axis_valid tvalid Output 1
add_interface_port m_axis  m_axis_last  tlast  Output 1
add_interface_port m_axis  m_axis_ready tready Input  1
add_interface_port m_axis  m_axis_data  tdata  Output DST_DATA_WIDTH
add_interface_port m_axis  m_axis_keep  tkeep  Output DST_DATA_WIDTH/8

ad_interface clock s_axis_aclk input 1
ad_interface reset-n s_axis_aresetn input 1 if_s_axis_aclk

add_interface s_axis axi4stream end
set_interface_property s_axis associatedClock if_s_axis_aclk
set_interface_property s_axis associatedReset if_s_axis_aresetn
add_interface_port s_axis  s_axis_valid tvalid Input  1
add_interface_port s_axis  s_axis_last  tlast  Input  1
add_interface_port s_axis  s_axis_ready tready Output 1
add_interface_port s_axis  s_axis_data  tdata  Input  SRC_DATA_WIDTH
add_interface_port s_axis  s_axis_keep  tkeep  Input  SRC_DATA_WIDTH/8

# write/read storage control

ad_interface signal wr_request_enable           Input  1
ad_interface signal wr_request_valid            Input  1
ad_interface signal wr_request_ready            Output 1
ad_interface signal wr_request_length           Input  LENGTH_WIDTH
ad_interface signal wr_response_measured_length Output LENGTH_WIDTH
ad_interface signal wr_response_eot             Output 1

ad_interface signal rd_request_enable           Input  1
ad_interface signal rd_request_valid            Input  1
ad_interface signal rd_request_ready            Output 1
ad_interface signal rd_request_length           Input  LENGTH_WIDTH
ad_interface signal rd_response_eot             Output 1

# manager axi4 interface

add_interface m_axi_clock clock end
add_interface_port m_axi_clock m_axi_aclk clk Input 1

add_interface m_axi_resetn reset end
set_interface_property m_axi_resetn associatedClock m_axi_clock
add_interface_port m_axi_resetn m_axi_aresetn reset_n Input 1

add_interface m_axi axi4 start
set_interface_property m_axi associatedClock m_axi_clock
set_interface_property m_axi associatedReset m_axi_resetn
set_interface_property m_axi readIssuingCapability 8
set_interface_property m_axi writeIssuingCapability 8
add_interface_port m_axi m_axi_awvalid awvalid Output 1
add_interface_port m_axi m_axi_awaddr awaddr Output AXI_ADDR_WIDTH
add_interface_port m_axi m_axi_awready awready Input 1
add_interface_port m_axi m_axi_wvalid wvalid Output 1
add_interface_port m_axi m_axi_wdata wdata Output AXI_DATA_WIDTH
add_interface_port m_axi m_axi_wstrb wstrb Output AXI_DATA_WIDTH/8
add_interface_port m_axi m_axi_wlast wlast Output 1
add_interface_port m_axi m_axi_wready wready Input 1
add_interface_port m_axi m_axi_bvalid bvalid Input 1
add_interface_port m_axi m_axi_bresp bresp Input 2
add_interface_port m_axi m_axi_bready bready Output 1
add_interface_port m_axi m_axi_arvalid arvalid Output 1
add_interface_port m_axi m_axi_araddr araddr Output 32
add_interface_port m_axi m_axi_arready arready Input 1
add_interface_port m_axi m_axi_rvalid rvalid Input 1
add_interface_port m_axi m_axi_rresp rresp Input 2
add_interface_port m_axi m_axi_rdata rdata Input AXI_DATA_WIDTH
add_interface_port m_axi m_axi_rlast rlast Input 1
add_interface_port m_axi m_axi_rready rready Output 1
add_interface_port m_axi m_axi_awlen awlen Output "8-(4*AXI_PROTOCOL)"
add_interface_port m_axi m_axi_awsize awsize Output 3
add_interface_port m_axi m_axi_awburst awburst Output 2
add_interface_port m_axi m_axi_awcache awcache Output 4
add_interface_port m_axi m_axi_awprot awprot Output 3
add_interface_port m_axi m_axi_arlen arlen Output "8-(4*AXI_PROTOCOL)"
add_interface_port m_axi m_axi_arsize arsize Output 3
add_interface_port m_axi m_axi_arburst arburst Output 2
add_interface_port m_axi m_axi_arcache arcache Output 4
add_interface_port m_axi m_axi_arprot arprot Output 3


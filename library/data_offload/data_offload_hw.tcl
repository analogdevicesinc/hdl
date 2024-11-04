###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME data_offload
set_module_property DISPLAY_NAME "ADI Data Offload Controller"
set_module_property DESCRIPTION "ADI Data Offload Controller"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property ELABORATION_CALLBACK data_offload_elaborate
set_module_property VALIDATION_CALLBACK data_offload_validate

# files

ad_ip_files data_offload [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/sync_gray.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/util_axis_fifo_asym/util_axis_fifo_asym.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo_address_generator.v \
  $ad_hdl_dir/library/common/ad_mem_asym.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  data_offload_regmap.v \
  data_offload_fsm.v \
  data_offload.v \
  data_offload_constr.sdc \
]

# parameters

set group "General Configuration"

add_parameter ID INTEGER 0
set_parameter_property ID DISPLAY_NAME "Core ID"
set_parameter_property ID HDL_PARAMETER true
set_parameter_property ID GROUP $group

add_parameter TX_OR_RXN_PATH INTEGER 0
set_parameter_property TX_OR_RXN_PATH DISPLAY_NAME "Data Path Type"
set_parameter_property TX_OR_RXN_PATH HDL_PARAMETER true
set_parameter_property TX_OR_RXN_PATH ALLOWED_RANGES { "0:RX Path" "1:TX Path" }
set_parameter_property TX_OR_RXN_PATH GROUP $group

add_parameter MEM_TYPE INTEGER 0
set_parameter_property MEM_TYPE DISPLAY_NAME "Storage Type"
set_parameter_property MEM_TYPE HDL_PARAMETER true
set_parameter_property MEM_TYPE ALLOWED_RANGES { "0:Internal Memory" "1:External Memory" }
set_parameter_property MEM_TYPE GROUP $group

add_parameter MEM_SIZE_LOG2 INTEGER 10
set_parameter_property MEM_SIZE_LOG2 DISPLAY_NAME "Storage Size"
set_parameter_property MEM_SIZE_LOG2 HDL_PARAMETER true
set_parameter_property MEM_SIZE_LOG2 ALLOWED_RANGES \
  { "1kB" "10" \
    "2kB" "11" \
    "4kB" "12" \
    "8kB" "13" \
    "16kB" "14" \
    "32kB" "15" \
    "64kB" "16" \
    "128kB" "17" \
    "256kB" "18" \
    "512kB" "19" \
    "1MB" "20" \
    "2MB" "21" \
    "4MB" "22" \
    "8MB" "23" \
    "16MB" "24" \
    "32MB" "25" \
    "64MB" "26" \
    "128MB" "27" \
    "256MB" "28" \
    "512MB" "29" \
    "1GB" "30" \
    "2GB" "31" \
    "4GB" "32" \
    "8GB" "33" \
    "16GB" "34" }
set_parameter_property MEM_SIZE_LOG2 GROUP $group

set group "Source Endpoint Configuration"

add_parameter SRC_DATA_WIDTH INTEGER 64
set_parameter_property SRC_DATA_WIDTH DISPLAY_NAME "Source Interface Data Width"
set_parameter_property SRC_DATA_WIDTH UNITS Bits
set_parameter_property SRC_DATA_WIDTH HDL_PARAMETER true 
set_parameter_property SRC_DATA_WIDTH GROUP $group

set group "Destination Endpoint Configuration"

add_parameter DST_DATA_WIDTH INTEGER 128
set_parameter_property DST_DATA_WIDTH DISPLAY_NAME "Destination Interface Data Width"
set_parameter_property DST_DATA_WIDTH UNITS Bits
set_parameter_property DST_DATA_WIDTH HDL_PARAMETER true 
set_parameter_property DST_DATA_WIDTH GROUP $group

set group "Features"

add_parameter HAS_BYPASS INTEGER 1
set_parameter_property HAS_BYPASS DISPLAY_NAME "Internal Bypass Data Path Enabled"
set_parameter_property HAS_BYPASS DISPLAY_HINT boolean
set_parameter_property HAS_BYPASS HDL_PARAMETER true
set_parameter_property HAS_BYPASS GROUP $group

add_parameter AUTO_BRINGUP INTEGER 1
set_parameter_property AUTO_BRINGUP DISPLAY_NAME "Run Automatically after Bootup"
set_parameter_property AUTO_BRINGUP DISPLAY_HINT boolean
set_parameter_property AUTO_BRINGUP HDL_PARAMETER true
set_parameter_property AUTO_BRINGUP GROUP $group

add_parameter DST_CYCLIC_EN INTEGER 1
set_parameter_property DST_CYCLIC_EN DISPLAY_NAME "Destination Cyclic Mode Enabled"
set_parameter_property DST_CYCLIC_EN DISPLAY_HINT boolean
set_parameter_property DST_CYCLIC_EN HDL_PARAMETER true
set_parameter_property DST_CYCLIC_EN GROUP $group

add_parameter SYNC_EXT_ADD_INTERNAL_CDC INTEGER 1
set_parameter_property SYNC_EXT_ADD_INTERNAL_CDC DISPLAY_NAME "Generate CDC Circuit for sync_ext"
set_parameter_property SYNC_EXT_ADD_INTERNAL_CDC DISPLAY_HINT boolean
set_parameter_property SYNC_EXT_ADD_INTERNAL_CDC HDL_PARAMETER true
set_parameter_property SYNC_EXT_ADD_INTERNAL_CDC GROUP $group

set group "AXI Stream Configuration"

add_parameter HAS_AXIS_TKEEP INTEGER 0                                                                   
set_parameter_property HAS_AXIS_TKEEP DISPLAY_NAME "Manager AXI Stream interface has TKEEP"                      
set_parameter_property HAS_AXIS_TKEEP DISPLAY_HINT boolean                                               
set_parameter_property HAS_AXIS_TKEEP HDL_PARAMETER false                                                
set_parameter_property HAS_AXIS_TKEEP GROUP $group                                                       
  
add_parameter HAS_AXIS_TLAST INTEGER 0                                                                   
set_parameter_property HAS_AXIS_TLAST DISPLAY_NAME "Manager AXI Stream interface has TLAST"                      
set_parameter_property HAS_AXIS_TLAST DISPLAY_HINT boolean                                               
set_parameter_property HAS_AXIS_TLAST HDL_PARAMETER false                                                
set_parameter_property HAS_AXIS_TLAST GROUP $group

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 16

ad_interface signal init_req input 1 xfer_req
ad_interface signal sync_ext input 1
ad_interface signal ddr_calib_done input 1

proc data_offload_validate {} {
  set tx_rxn_path [get_parameter_value TX_OR_RXN_PATH]
  set_parameter_property DST_CYCLIC_EN ENABLED [expr {$tx_rxn_path == 1} ? true : false]
}

# axis destination/source

ad_interface clock m_axis_aclk input 1 clk
ad_interface reset-n m_axis_aresetn input 1 if_m_axis_aclk

add_interface m_axis axi4stream start
set_interface_property m_axis associatedClock if_m_axis_aclk
set_interface_property m_axis associatedReset if_m_axis_aresetn
add_interface_port m_axis  m_axis_valid tvalid Output 1
add_interface_port m_axis  m_axis_last  tlast  Output 1
add_interface_port m_axis  m_axis_ready tready Input  1
add_interface_port m_axis  m_axis_data  tdata  Output DST_DATA_WIDTH
add_interface_port m_axis  m_axis_keep  tkeep  Output DST_DATA_WIDTH/8

add_interface s_storage_axis axi4stream end
set_interface_property s_storage_axis associatedClock if_m_axis_aclk
set_interface_property s_storage_axis associatedReset if_m_axis_aresetn
add_interface_port s_storage_axis  s_storage_axis_valid tvalid Input  1
add_interface_port s_storage_axis  s_storage_axis_last  tlast  Input  1
add_interface_port s_storage_axis  s_storage_axis_ready tready Output 1
add_interface_port s_storage_axis  s_storage_axis_data  tdata  Input  DST_DATA_WIDTH
add_interface_port s_storage_axis  s_storage_axis_keep  tkeep  Input  DST_DATA_WIDTH/8

ad_interface clock s_axis_aclk input 1 clk
ad_interface reset-n s_axis_aresetn input 1 if_s_axis_aclk

add_interface s_axis axi4stream end
set_interface_property s_axis associatedClock if_s_axis_aclk
set_interface_property s_axis associatedReset if_s_axis_aresetn
add_interface_port s_axis  s_axis_valid tvalid Input  1
add_interface_port s_axis  s_axis_last  tlast  Input  1
add_interface_port s_axis  s_axis_ready tready Output 1
add_interface_port s_axis  s_axis_data  tdata  Input  SRC_DATA_WIDTH
add_interface_port s_axis  s_axis_keep  tkeep  Input  SRC_DATA_WIDTH/8

add_interface m_storage_axis axi4stream start
set_interface_property m_storage_axis associatedClock if_s_axis_aclk
set_interface_property m_storage_axis associatedReset if_s_axis_aresetn
add_interface_port m_storage_axis  m_storage_axis_valid tvalid Output 1
add_interface_port m_storage_axis  m_storage_axis_last  tlast  Output 1
add_interface_port m_storage_axis  m_storage_axis_ready tready Input  1
add_interface_port m_storage_axis  m_storage_axis_data  tdata  Output SRC_DATA_WIDTH
add_interface_port m_storage_axis  m_storage_axis_keep  tkeep  Output SRC_DATA_WIDTH/8

# write/read storage control

ad_interface signal wr_request_enable           Output 1
ad_interface signal wr_request_valid            Output 1
ad_interface signal wr_request_ready            Input  1
ad_interface signal wr_request_length           Output MEM_SIZE_LOG2
ad_interface signal wr_response_measured_length Input  MEM_SIZE_LOG2
ad_interface signal wr_response_eot             Input  1
ad_interface signal wr_overflow                 Input  1

ad_interface signal rd_request_enable           Output 1
ad_interface signal rd_request_valid            Output 1
ad_interface signal rd_request_ready            Input  1
ad_interface signal rd_request_length           Output MEM_SIZE_LOG2
ad_interface signal rd_response_eot             Input  1
ad_interface signal rd_underflow                Input  1

proc data_offload_elaborate {} {
  if {[get_parameter_value HAS_AXIS_TKEEP] == 0} {
    set_port_property m_axis_keep termination true
  }
  if {[get_parameter_value HAS_AXIS_TLAST] == 0} {
    set_port_property m_axis_last termination true
  }
}

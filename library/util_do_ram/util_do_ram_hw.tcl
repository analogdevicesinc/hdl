###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME util_do_ram
set_module_property DISPLAY_NAME "ADI Data Offload RAM Storage"
set_module_property DESCRIPTION "Serves as storage for the Data Offload core, using Block RAM or URAM"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"

# files

ad_ip_files util_do_ram [list \
  $ad_hdl_dir/library/util_axis_fifo/util_axis_fifo.v \
  $ad_hdl_dir/library/common/ad_mem_asym.v \
  util_do_ram.v \
  util_do_ram_constr.sdc \
]

# parameters

ad_ip_parameter SRC_DATA_WIDTH        INTEGER 512
ad_ip_parameter DST_DATA_WIDTH        INTEGER 128
ad_ip_parameter LENGTH_WIDTH          INTEGER 16
ad_ip_parameter RD_DATA_REGISTERED    INTEGER 0
ad_ip_parameter RD_FIFO_ADDRESS_WIDTH INTEGER 2

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

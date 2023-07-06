###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create data_offload
adi_ip_files data_offload [list \
  "data_offload_sv.ttcl" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_mem_asym.v" \
  "$ad_hdl_dir/library/common/ad_axis_inf_rx.v" \
  "data_offload_regmap.v" \
  "data_offload_fsm.v" \
  "data_offload.v" ]

## NOTE: To solve the issue AR# 70646 we need to call the following command
##set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties data_offload
adi_ip_ttcl data_offload "data_offload_constr.ttcl"
adi_ip_sim_ttcl data_offload "data_offload_sv.ttcl"

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo_asym:1.0 \
]

set_property display_name "ADI Data Offload Controller" [ipx::current_core]
set_property description "ADI Data Offload Controller" [ipx::current_core]

## Interface definitions

## destination interfaces (e.g. RX_DMA or DAC core)

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"} \
    {"m_axis_last" "TLAST"} \
    {"m_axis_tkeep" "TKEEP"} ]

## source interface (e.g. TX_DMA or ADC core)

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [ list \
    {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"} \
    {"s_axis_last" "TLAST"} \
    {"s_axis_tkeep" "TKEEP"} ]

adi_add_bus "wr_ctrl" "master" \
  "analog.com:interface:if_do_ctrl_rtl:1.0" \
  "analog.com:interface:if_do_ctrl:1.0" \
  [list {"wr_request_enable" "request_enable"} \
        {"wr_request_valid" "request_valid"} \
        {"wr_request_ready" "request_ready"} \
        {"wr_request_length" "request_length"} \
        {"wr_response_measured_length" "response_measured_length"} \
        {"wr_response_eot" "response_eot"} \
        {"wr_overflow" "status_overflow"} \
    ]

adi_add_bus "rd_ctrl" "master" \
  "analog.com:interface:if_do_ctrl_rtl:1.0" \
  "analog.com:interface:if_do_ctrl:1.0" \
  [list {"rd_request_enable" "request_enable"} \
        {"rd_request_valid" "request_valid"} \
        {"rd_request_ready" "request_ready"} \
        {"rd_request_length" "request_length"} \
        {"rd_response_eot" "response_eot"} \
        {"rd_underflow" "status_underflow"} \
    ]

adi_add_bus "s_storage_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_storage_axis_ready" "TREADY"} \
    {"s_storage_axis_valid" "TVALID"} \
    {"s_storage_axis_data" "TDATA"} \
    {"s_storage_axis_tkeep" "TKEEP"} \
    {"s_storage_axis_last" "TLAST"}]

adi_add_bus "m_storage_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"m_storage_axis_ready" "TREADY"} \
    {"m_storage_axis_valid" "TVALID"} \
    {"m_storage_axis_data" "TDATA"} \
    {"m_storage_axis_tkeep" "TKEEP"} \
    {"m_storage_axis_last" "TLAST"}]

adi_add_bus_clock "m_axis_aclk" "s_storage_axis:m_axis" "m_axis_aresetn"
adi_add_bus_clock "s_axis_aclk" "m_storage_axis:s_axis" "s_axis_aresetn"

set cc [ipx::current_core]

set_property -dict [list \
  enablement_resolve_type dependent \
  driver_value 0 \
  enablement_dependency {MEM_TYPE == 1} \
  ] \
[ipx::get_ports ddr_calib_done -of_objects $cc]

set_property -dict [list \
  driver_value 0 \
  ] \
[ipx::get_ports wr_overflow -of_objects $cc]

set_property -dict [list \
  driver_value 0 \
  ] \
[ipx::get_ports rd_underflow -of_objects $cc]

## Parameter validations

## MEM_TPYE
set_property -dict [list \
  "value_format" "long" \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "Internal memory" "0" \
      "External memory" "1" \
    } \
 ] \
 [ipx::get_user_parameters MEM_TYPE -of_objects $cc]

set_property -dict [list \
  "value_format" "long" \
  ] \
  [ipx::get_hdl_parameters MEM_TYPE -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "RX path" "0" \
      "TX path" "1" \
    } \
 ] \
 [ipx::get_user_parameters TX_OR_RXN_PATH -of_objects $cc]

set_property -dict [list \
    "value_validation_type" "pairs" \
    "value" "10" \
    "value_validation_pairs" {\
      "1kB" "10" \
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
      "16GB" "34" \
    } \
 ] \
 [ipx::get_user_parameters MEM_SIZE_LOG2 -of_objects $cc]

## Boolean parameters
foreach {k v} { \
    "HAS_BYPASS" "true" \
    "DST_CYCLIC_EN" "true" \
    "SYNC_EXT_ADD_INTERNAL_CDC" "true" \
  } { \
  set_property -dict [list \
      "value_format" "bool" \
      "value_format" "bool" \
      "value" $v \
    ] \
    [ipx::get_user_parameters $k -of_objects $cc]
  set_property -dict [list \
      "value_format" "bool" \
      "value_format" "bool" \
      "value" $v \
    ] \
    [ipx::get_hdl_parameters $k -of_objects $cc]
}

### Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create a new GUI page
ipgui::add_page -name {Data Offload} -component [ipx::current_core] -display_name {Data Offload}
set page0 [ipgui::get_pagespec -name "Data Offload" -component $cc]

## General Configurations
set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "TX_OR_RXN_PATH" -component $cc -parent $general_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Data path type" \
] [ipgui::get_guiparamspec -name "TX_OR_RXN_PATH" -component $cc]

ipgui::add_param -name "MEM_TYPE" -component $cc -parent $general_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Storage Type" \
] [ipgui::get_guiparamspec -name "MEM_TYPE" -component $cc]

ipgui::add_param -name "MEM_SIZE_LOG2" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Storage Size" \
  "tooltip" "Log2 value of Storage Size in bytes" \
] [ipgui::get_guiparamspec -name "MEM_SIZE_LOG2" -component $cc]

## Transmit and receive endpoints
set source_group [ipgui::add_group -name "Source Endpoint Configuration" -component $cc \
    -parent $page0 -display_name "Source Endpoint Configuration" \
    -layout "horizontal"]
set destination_group [ipgui::add_group -name "Destination Endpoint Configuration" -component $cc \
    -parent $page0 -display_name "Destination Endpoint Configuration" \
    -layout "horizontal"]

ipgui::add_param -name "SRC_DATA_WIDTH" -component $cc -parent $source_group
set_property -dict [list \
  "display_name" "Source Interface data width" \
] [ipgui::get_guiparamspec -name "SRC_DATA_WIDTH" -component $cc]

ipgui::add_param -name "DST_DATA_WIDTH" -component $cc -parent $destination_group
set_property -dict [list \
  "display_name" "Destination Interface data width" \
] [ipgui::get_guiparamspec -name "DST_DATA_WIDTH" -component $cc]

## Other features
set features_group [ipgui::add_group -name "Features" -component $cc \
    -parent $page0 -display_name "Features" ]

ipgui::add_param -name "HAS_BYPASS" -component $cc -parent $features_group
set_property -dict [list \
  "display_name" "Internal Bypass Data Path Enabled" \
] [ipgui::get_guiparamspec -name "HAS_BYPASS" -component $cc]

ipgui::add_param -name "DST_CYCLIC_EN" -component $cc -parent $features_group
set_property -dict [list \
  "display_name" "Destination Cyclic Mode Enabled" \
] [ipgui::get_guiparamspec -name "DST_CYCLIC_EN" -component $cc]
set_property enablement_tcl_expr {$TX_OR_RXN_PATH == 1} [ipx::get_user_parameters DST_CYCLIC_EN -of_objects $cc]

ipgui::add_param -name "SYNC_EXT_ADD_INTERNAL_CDC" -component $cc -parent $features_group
set_property -dict [list \
  "display_name" "Generate CDC Circuit for sync_ext" \
] [ipgui::get_guiparamspec -name "SYNC_EXT_ADD_INTERNAL_CDC" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]


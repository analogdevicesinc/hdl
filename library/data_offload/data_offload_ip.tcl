source ../scripts/adi_env.tcl
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
adi_add_bus_clock "m_axis_aclk" "m_axis" "m_axis_aresetn"

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
adi_add_bus_clock "s_axis_aclk" "s_axis" "s_axis_aresetn"

set cc [ipx::current_core]

## Parameter validations

## MEM_TPYE
set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "Internal memory" "0" \
      "External memory" "1" \
    } \
 ] \
 [ipx::get_user_parameters MEM_TYPE -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "RX path" "0" \
      "TX path" "1" \
    } \
 ] \
 [ipx::get_user_parameters TX_OR_RXN_PATH -of_objects $cc]

## MEMC_UIF_DATA_WIDTH
set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "64 128 256 512 1024" \
 ] \
 [ipx::get_user_parameters MEMC_UIF_DATA_WIDTH -of_objects $cc]

## MEMC_UIF_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "31" \
 ] \
 [ipx::get_user_parameters MEMC_UIF_ADDRESS_WIDTH -of_objects $cc]

## MEM_SIZE - 8GB??
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "2" \
  "value_validation_range_maximum" "8589934592" \
 ] \
 [ipx::get_user_parameters MEM_SIZE -of_objects $cc]

## Boolean parameters
foreach {k v} { \
    "SRC_RAW_DATA_EN" "false" \
    "DST_RAW_DATA_EN" "false" \
    "DST_CYCLIC_EN" "true" \
    "SYNC_EXT_ADD_INTERNAL_CDC" "true" \
  } { \
  set_property -dict [list \
      "value_format" "bool" \
      "value" $v \
    ] \
    [ipx::get_user_parameters $k -of_objects $cc]
  set_property -dict [list \
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

ipgui::add_param -name "MEM_SIZE" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Storage Size" \
] [ipgui::get_guiparamspec -name "MEM_SIZE" -component $cc]

## DDR controller's user interface related configurations
set m_controller_group [ipgui::add_group -name "DDR Controller Interface Configuration" -component $cc \
    -parent $page0 -display_name "DDR Controller Interface Configuration" ]

ipgui::add_param -name "MEMC_UIF_DATA_WIDTH" -component $cc -parent $m_controller_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Interface data width" \
] [ipgui::get_guiparamspec -name "MEMC_UIF_DATA_WIDTH" -component $cc]
set_property enablement_tcl_expr {$MEM_TYPE == 1} [ipx::get_user_parameters MEMC_UIF_DATA_WIDTH -of_objects $cc]

ipgui::add_param -name "MEMC_UIF_ADDRESS_WIDTH" -component $cc -parent $m_controller_group
set_property -dict [list \
  "widget" "comboBox" \
  "display_name" "Interface address width" \
] [ipgui::get_guiparamspec -name "MEMC_UIF_ADDRESS_WIDTH" -component $cc]
set_property enablement_tcl_expr {$MEM_TYPE == 1} [ipx::get_user_parameters MEMC_UIF_ADDRESS_WIDTH -of_objects $cc]

ipgui::add_param -name "MEMC_BADDRESS" -component $cc -parent $m_controller_group
set_property -dict [list \
  "display_name" "PL DDR base address" \
] [ipgui::get_guiparamspec -name "MEMC_BADDRESS" -component $cc]
set_property enablement_tcl_expr {$MEM_TYPE == 1} [ipx::get_user_parameters MEMC_BADDRESS -of_objects $cc]

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

ipgui::add_param -name "SRC_ADDR_WIDTH" -component $cc -parent $source_group
set_property -dict [list \
  "display_name" "Source Interface address width" \
] [ipgui::get_guiparamspec -name "SRC_ADDR_WIDTH" -component $cc]

ipgui::add_param -name "DST_DATA_WIDTH" -component $cc -parent $destination_group
set_property -dict [list \
  "display_name" "Destination Interface data width" \
] [ipgui::get_guiparamspec -name "DST_DATA_WIDTH" -component $cc]

ipgui::add_param -name "DST_ADDR_WIDTH" -component $cc -parent $destination_group
set_property -dict [list \
  "display_name" "Destination Interface address width" \
] [ipgui::get_guiparamspec -name "DST_ADDR_WIDTH" -component $cc]

## Other features
set features_group [ipgui::add_group -name "Features" -component $cc \
    -parent $page0 -display_name "Features" ]


ipgui::add_param -name "SRC_RAW_DATA_EN" -component $cc -parent $features_group
set_property -dict [list \
  "display_name" "Source Raw Data Enable" \
] [ipgui::get_guiparamspec -name "SRC_RAW_DATA_EN" -component $cc]
set_property enablement_tcl_expr {$TX_OR_RXN_PATH == 0} [ipx::get_user_parameters SRC_RAW_DATA_EN -of_objects $cc]

ipgui::add_param -name "DST_RAW_DATA_EN" -component $cc -parent $features_group
set_property -dict [list \
  "display_name" "Destionation Raw Data Enable" \
] [ipgui::get_guiparamspec -name "DST_RAW_DATA_EN" -component $cc]
set_property enablement_tcl_expr {$TX_OR_RXN_PATH == 1} [ipx::get_user_parameters DST_RAW_DATA_EN -of_objects $cc]

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

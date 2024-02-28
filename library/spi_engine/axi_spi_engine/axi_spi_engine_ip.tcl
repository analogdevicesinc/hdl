###############################################################################
## Copyright (C) 2015-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_spi_engine
adi_ip_files axi_spi_engine [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "axi_spi_engine_constr.ttcl" \
  "axi_spi_engine.v" \
]

adi_ip_properties axi_spi_engine
adi_ip_ttcl axi_spi_engine "axi_spi_engine_constr.ttcl"

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/spi_engine/axi} [ipx::current_core]

## Interface definitions

adi_add_bus "spi_engine_ctrl" "master" \
	"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_ctrl:1.0" \
	{
		{"cmd_ready" "cmd_ready"} \
		{"cmd_valid" "cmd_valid"} \
		{"cmd_data" "cmd_data"} \
		{"sdo_data_ready" "sdo_ready"} \
		{"sdo_data_valid" "sdo_valid"} \
		{"sdo_data" "sdo_data"} \
		{"sdi_data_ready" "sdi_ready"} \
		{"sdi_data_valid" "sdi_valid"} \
		{"sdi_data" "sdi_data"} \
		{"sync_ready" "sync_ready"} \
		{"sync_valid" "sync_valid"} \
		{"sync_data" "sync_data"} \
	}
adi_add_bus_clock "spi_clk" "spi_engine_ctrl" "spi_resetn" "master"

adi_add_bus "spi_engine_offload_ctrl0" "master" \
	"analog.com:interface:spi_engine_offload_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_offload_ctrl:1.0" \
	{ \
		{ "offload0_cmd_wr_en" "cmd_wr_en"} \
		{ "offload0_cmd_wr_data" "cmd_wr_data"} \
		{ "offload0_sdo_wr_en" "sdo_wr_en"} \
		{ "offload0_sdo_wr_data" "sdo_wr_data"} \
		{ "offload0_enable" "enable"} \
		{ "offload0_enabled" "enabled"} \
		{ "offload0_mem_reset" "mem_reset"} \
		{ "offload_sync_ready" "sync_ready"} \
		{ "offload_sync_valid" "sync_valid"} \
		{ "offload_sync_data" "sync_data"} \
	}
adi_add_bus_clock "s_axi_aclk" "spi_engine_offload_ctrl0:s_axi" "s_axi_aresetn"

foreach port {"up_clk" "up_rstn" "up_wreq" "up_waddr" "up_wdata" "up_rreq" "up_raddr"} {
  set_property DRIVER_VALUE "0" [ipx::get_ports $port]
}
adi_set_bus_dependency "spi_engine_offload_ctrl0" "spi_engine_offload_ctrl0" \
	"(spirit:decode(id('MODELPARAM_VALUE.NUM_OFFLOAD')) > 0)"

adi_set_bus_dependency "s_axi" "s_axi" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 0)"

adi_set_ports_dependency "up_clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rstn" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_waddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rreq" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_raddr" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_wack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rdata" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"
adi_set_ports_dependency "up_rack" \
      "(spirit:decode(id('MODELPARAM_VALUE.MM_IF_TYPE')) = 1)"

## Parameter validations

set cc [ipx::current_core]

## ID
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "255" \
 ] \
 [ipx::get_user_parameters ID -of_objects $cc]

## CMD_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters CMD_FIFO_ADDRESS_WIDTH -of_objects $cc]

## SYNC_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters SYNC_FIFO_ADDRESS_WIDTH -of_objects $cc]

## SDO_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters SDO_FIFO_ADDRESS_WIDTH -of_objects $cc]

## SDI_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters SDI_FIFO_ADDRESS_WIDTH -of_objects $cc]

## MM_IF_TYPE
set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
      "AXI4 Memory Mapped" "0" \
      "ADI uP FIFO" "1" \
    } \
 ] \
 [ipx::get_user_parameters MM_IF_TYPE -of_objects $cc]

## ASYNC_SPI_CLK
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ASYNC_SPI_CLK -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters ASYNC_SPI_CLK -of_objects $cc]

## NUM_OFFLOAD
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OFFLOAD -of_objects $cc]

## OFFLOAD0_CMD_MEM_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters OFFLOAD0_CMD_MEM_ADDRESS_WIDTH -of_objects $cc]

## OFFLOAD0_SDO_MEM_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters OFFLOAD0_SDO_MEM_ADDRESS_WIDTH -of_objects $cc]

## DATA_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "256" \
 ] \
 [ipx::get_user_parameters DATA_WIDTH -of_objects $cc]

## NUM_OF_SDI
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OF_SDI -of_objects $cc]

## Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {AXI SPI Engine soft-controller} -component [ipx::current_core] -display_name {AXI SPI Engine soft-controller}
set page0 [ipgui::get_pagespec -name "AXI SPI Engine soft-controller" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
  "tooltip" "\[ID\] Core instance ID" \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "DATA_WIDTH" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Parallel data width" \
  "tooltip" "\[DATA_WIDTH\] Define the data interface width"
] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component $cc]

ipgui::add_param -name "NUM_OF_SDI" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Number of MISO lines" \
  "tooltip" "\[NUM_OF_SDI\] Define the number of MISO lines" \
] [ipgui::get_guiparamspec -name "NUM_OF_SDI" -component $cc]

ipgui::add_param -name "MM_IF_TYPE" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Memory Mapped Interface Type" \
  "tooltip" "\[MM_IF_TYPE\] Define the memory mapped interface type" \
] [ipgui::get_guiparamspec -name "MM_IF_TYPE" -component $cc]

ipgui::add_param -name "ASYNC_SPI_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_SPI_CLK\] Define the relationship between the core clock and the memory mapped interface clock" \
] [ipgui::get_guiparamspec -name "ASYNC_SPI_CLK" -component $cc]

## Command stream FIFO depth configuration
set cmd_stream_fifo_group [ipgui::add_group -name "Command stream FIFO configuration" -component $cc \
    -parent $page0 -display_name "Command stream FIFO configuration" ]

ipgui::add_param -name "CMD_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "Command FIFO address width" \
  "tooltip" "\[CMD_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "CMD_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SYNC_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "SYNC FIFO address width" \
  "tooltip" "\[SYNC_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SYNC_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SDO_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "MOSI FIFO address width" \
  "tooltip" "\[SDO_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDO_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SDI_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "MISO FIFO address width" \
  "tooltip" "\[SDI_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDI_FIFO_ADDRESS_WIDTH" -component $cc]

## Offload module(s) configuration
set offload_group [ipgui::add_group -name "Offload module configuration" -component $cc \
    -parent $page0 -display_name "Offload module configuration" ]

ipgui::add_param -name "NUM_OFFLOAD" -component $cc -parent $offload_group
set_property -dict [list \
  "display_name" "Number of offloads" \
  "tooltip" "\[NUM_OFFLOAD\] Number of offloads" \
] [ipgui::get_guiparamspec -name "NUM_OFFLOAD" -component $cc]

ipgui::add_param -name "OFFLOAD0_CMD_MEM_ADDRESS_WIDTH" -component $cc -parent $offload_group
set_property -dict [list \
  "display_name" "Offload command FIFO address width" \
  "tooltip" "\[OFFLOAD0_CMD_MEM_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "OFFLOAD0_CMD_MEM_ADDRESS_WIDTH" -component $cc]
set_property enablement_tcl_expr {$NUM_OFFLOAD > 0} [ipx::get_user_parameters OFFLOAD0_CMD_MEM_ADDRESS_WIDTH -of_objects $cc]

ipgui::add_param -name "OFFLOAD0_SDO_MEM_ADDRESS_WIDTH" -component $cc -parent $offload_group
set_property -dict [list \
  "display_name" "Offload MOSI FIFO address width" \
  "tooltip" "\[OFFLOAD0_SDO_MEM_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "OFFLOAD0_SDO_MEM_ADDRESS_WIDTH" -component $cc]
set_property enablement_tcl_expr {$NUM_OFFLOAD > 0} [ipx::get_user_parameters OFFLOAD0_SDO_MEM_ADDRESS_WIDTH -of_objects $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]

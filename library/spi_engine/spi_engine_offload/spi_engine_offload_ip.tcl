###############################################################################
## Copyright (C) 2015-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create spi_engine_offload
adi_ip_files spi_engine_offload [list \
  "spi_engine_offload_constr.ttcl" \
	"spi_engine_offload.v" \
]

adi_ip_properties_lite spi_engine_offload
adi_ip_ttcl spi_engine_offload "spi_engine_offload_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/spi_engine/offload} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

adi_ip_add_core_dependencies [list \
	analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

## Interface definitions

adi_add_bus "spi_engine_ctrl" "master" \
	"analog.com:interface:spi_engine_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_ctrl:1.0" \
	{
		{"cmd_ready" "cmd_ready"} \
		{"cmd_valid" "cmd_valid"} \
		{"cmd" "cmd_data"} \
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

adi_add_bus "spi_engine_offload_ctrl" "slave" \
	"analog.com:interface:spi_engine_offload_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_offload_ctrl:1.0" \
	{ \
		{ "ctrl_cmd_wr_en" "cmd_wr_en"} \
		{ "ctrl_cmd_wr_data" "cmd_wr_data"} \
		{ "ctrl_sdo_wr_en" "sdo_wr_en"} \
		{ "ctrl_sdo_wr_data" "sdo_wr_data"} \
		{ "ctrl_enable" "enable"} \
		{ "ctrl_enabled" "enabled"} \
		{ "ctrl_mem_reset" "mem_reset"} \
		{ "status_sync_ready" "sync_ready"} \
		{ "status_sync_valid" "sync_valid"} \
		{ "status_sync_data" "sync_data"} \
	}

adi_add_bus "offload_sdi" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"offload_sdi_valid" "TVALID"} \
		{"offload_sdi_ready" "TREADY"} \
		{"offload_sdi_data" "TDATA"} \
	}

adi_add_bus "s_axis_sdo" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	[list {"s_axis_sdo_ready" "TREADY"} \
	  {"s_axis_sdo_valid" "TVALID"} \
	  {"s_axis_sdo_data" "TDATA"}]

adi_add_bus "m_interconnect_ctrl" "master" \
	"analog.com:interface:spi_engine_interconnect_ctrl_rtl:1.0" \
	"analog.com:interface:spi_engine_interconnect_ctrl:1.0" \
	{ \
		{"interconnect_dir" "interconnect_dir"} \
	}
adi_add_bus_clock "spi_clk" "m_interconnect_ctrl" "resetn"

adi_add_bus_clock "spi_clk" "spi_engine_ctrl:offload_sdi:s_axis_sdo" "spi_resetn"
adi_add_bus_clock "ctrl_clk" "spi_engine_offload_ctrl"

adi_set_bus_dependency "s_axis_sdo" "s_axis_sdo" \
	"(spirit:decode(id('MODELPARAM_VALUE.SDO_STREAMING')) = 1)"

## Parameter validations

set cc [ipx::current_core]

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

## ASYNC_TRIG
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ASYNC_TRIG -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters ASYNC_TRIG -of_objects $cc]

## SDO_STREAMING
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters SDO_STREAMING -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters SDO_STREAMING -of_objects $cc]

## NUM_OF_SDI
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "8" \
 ] \
 [ipx::get_user_parameters NUM_OF_SDI -of_objects $cc]

## DATA_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "8" \
  "value_validation_range_maximum" "256" \
 ] \
 [ipx::get_user_parameters DATA_WIDTH -of_objects $cc]

## CMD_MEM_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters CMD_MEM_ADDRESS_WIDTH -of_objects $cc]

## SDO_MEM_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters SDO_MEM_ADDRESS_WIDTH -of_objects $cc]

## Customize IP Layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {SPI Engine RX offload} -component [ipx::current_core] -display_name {SPI Engine RX offload}
set page0 [ipgui::get_pagespec -name "SPI Engine RX offload" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "DATA_WIDTH" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Shift register's data width" \
  "tooltip" "\[DATA_WIDTH\] Define the data interface width"
] [ipgui::get_guiparamspec -name "DATA_WIDTH" -component $cc]

ipgui::add_param -name "NUM_OF_SDI" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Number of MISO lines" \
  "tooltip" "\[NUM_OF_SDI\] Define the number of MISO lines" \
] [ipgui::get_guiparamspec -name "NUM_OF_SDI" -component $cc]

ipgui::add_param -name "ASYNC_SPI_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_SPI_CLK\] Define the relationship between the core clock and the memory mapped interface clock" \
] [ipgui::get_guiparamspec -name "ASYNC_SPI_CLK" -component $cc]

ipgui::add_param -name "ASYNC_TRIG" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous trigger" \
  "tooltip" "\[ASYNC_TRIG\] Set if the external trigger is asynchronous to the core clk" \
] [ipgui::get_guiparamspec -name "ASYNC_TRIG" -component $cc]

ipgui::add_param -name "SDO_STREAMING" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "SDO Streaming" \
  "tooltip" "\[SDO_STREAMING\] Enable an AXI-Streaming Slave interface for streaming SDO data during offload." \
] [ipgui::get_guiparamspec -name "SDO_STREAMING" -component $cc]

## Command stream FIFO depth configuration
set cmd_stream_fifo_group [ipgui::add_group -name "Command stream FIFO configuration" -component $cc \
    -parent $page0 -display_name "Command stream FIFO configuration" ]

ipgui::add_param -name "CMD_MEM_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "Command FIFO address width" \
  "tooltip" "\[CMD_MEM_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "CMD_MEM_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SDO_MEM_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "MOSI FIFO address width" \
  "tooltip" "\[SDO_MEM_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDO_MEM_ADDRESS_WIDTH" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]

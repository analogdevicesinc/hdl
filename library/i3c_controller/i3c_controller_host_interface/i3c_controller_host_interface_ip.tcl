###############################################################################
## Copyright (C) 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create i3c_controller_host_interface
adi_ip_files i3c_controller_host_interface [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/ad_rst.v" \
  "$ad_hdl_dir/library/common/ad_mem_dual.v" \
  "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
  "i3c_controller_host_interface_constr.ttcl" \
  "i3c_controller_host_interface.v" \
  "i3c_controller_regmap.v" \
  "i3c_controller_regmap.vh" \
  "i3c_controller_cmd_parser.v" \
  "i3c_controller_pack.v" \
  "i3c_controller_unpack.v" \
  "i3c_controller_write_ibi.v" \
]

adi_ip_properties i3c_controller_host_interface
adi_ip_ttcl i3c_controller_host_interface "i3c_controller_host_interface_constr.ttcl"

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_axis_fifo:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/host_interface} [ipx::current_core]

## Interface definitions

adi_add_bus "sdio" "master" \
  "analog.com:interface:i3c_controller_sdio_rtl:1.0" \
  "analog.com:interface:i3c_controller_sdio:1.0" \
  {
    {"sdo_ready" "sdo_ready"} \
    {"sdo_valid" "sdo_valid"} \
    {"sdo"       "sdo"} \
    {"sdi_ready" "sdi_ready"} \
    {"sdi_valid" "sdi_valid"} \
    {"sdi_last"  "sdi_last"} \
    {"sdi"       "sdi"} \
    {"ibi_ready" "ibi_ready"} \
    {"ibi_valid" "ibi_valid"} \
    {"ibi"       "ibi"} \
  }
adi_add_bus_clock "clk" "sdio" "reset_n"

adi_add_bus "offload_sdi" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  {
    {"offload_sdi_ready"  "TREADY"} \
    {"offload_sdi_valid"  "TVALID"} \
    {"offload_sdi"        "TDATA"} \
  }
adi_add_bus_clock "clk" "offload_sdi" "reset_n" "master"

adi_add_bus "cmdp" "master" \
  "analog.com:interface:i3c_controller_cmdp_rtl:1.0" \
  "analog.com:interface:i3c_controller_cmdp:1.0" \
  {
    {"cmdp_valid"       "cmdp_valid"} \
    {"cmdp_ready"       "cmdp_ready"} \
    {"cmdp"             "cmdp"} \
    {"cmdp_error"       "cmdp_error"} \
    {"cmdp_nop"         "cmdp_nop"} \
    {"cmdp_daa_trigger" "cmdp_daa_trigger"} \
  }
adi_add_bus_clock "clk" "cmdp" "reset_n"

adi_add_bus "rmap" "master" \
  "analog.com:interface:i3c_controller_rmap_rtl:1.0" \
  "analog.com:interface:i3c_controller_rmap:1.0" \
  {
    {"rmap_ibi_config"    "rmap_ibi_config"} \
    {"rmap_pp_sg"         "rmap_pp_sg"} \
    {"rmap_dev_char_addr" "rmap_dev_char_addr"} \
    {"rmap_dev_char_data" "rmap_dev_char_data"} \
  }
adi_add_bus_clock "clk" "rmap" "reset_n" "master"

adi_set_ports_dependency "clk" \
      "(spirit:decode(id('MODELPARAM_VALUE.ASYNC_CLK')) = 1)"

adi_set_bus_dependency "offload_sdi" "offload_sdi" \
      "(spirit:decode(id('MODELPARAM_VALUE.OFFLOAD')) = 1)"
adi_set_ports_dependency "offload_trigger" \
      "(spirit:decode(id('MODELPARAM_VALUE.OFFLOAD')) = 1)" 0

set cc [ipx::current_core]

ipx::associate_bus_interfaces -clock s_axi_aclk -reset reset_n $cc

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

## CMDR_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters CMDR_FIFO_ADDRESS_WIDTH -of_objects $cc]

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

## IBI_FIFO_ADDRESS_WIDTH
set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "16" \
 ] \
 [ipx::get_user_parameters IBI_FIFO_ADDRESS_WIDTH -of_objects $cc]

foreach {k v} { \
        "ASYNC_CLK" "false" \
        "OFFLOAD" "false" \
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

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Host Interface} -component [ipx::current_core] -display_name {AXI I3C Controller Host Interface}
set page0 [ipgui::get_pagespec -name "I3C Controller Host Interface" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ID" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Core ID" \
  "tooltip" "\[ID\] Core instance ID" \
] [ipgui::get_guiparamspec -name "ID" -component $cc]

ipgui::add_param -name "ASYNC_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_CLK\] Define the relationship between the core clock and the memory mapped interface clock" \
] [ipgui::get_guiparamspec -name "ASYNC_CLK" -component $cc]

ipgui::add_param -name "OFFLOAD" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Offload engine" \
  "tooltip" "\[OFFLOAD\] Allows to offload output data to a external receiver, like a DMA" \
] [ipgui::get_guiparamspec -name "OFFLOAD" -component $cc]

## Command stream FIFO depth configuration
set cmd_stream_fifo_group [ipgui::add_group -name "Command stream FIFO configuration" -component $cc \
    -parent $page0 -display_name "Command stream FIFO configuration" ]

ipgui::add_param -name "CMD_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "Command FIFO address width" \
  "tooltip" "\[CMD_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "CMD_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "CMDR_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "CMDR FIFO address width" \
  "tooltip" "\[CMDR_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "CMDR_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SDO_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "SDO FIFO address width" \
  "tooltip" "\[SDO_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDO_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "SDI_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "SDI FIFO address width" \
  "tooltip" "\[SDI_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDI_FIFO_ADDRESS_WIDTH" -component $cc]

ipgui::add_param -name "IBI_FIFO_ADDRESS_WIDTH" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "IBI FIFO address width" \
  "tooltip" "\[IBI_FIFO_ADDRESS_WIDTH\] Define the depth of the FIFO" \
] [ipgui::get_guiparamspec -name "SDI_FIFO_ADDRESS_WIDTH" -component $cc]

## Provisioned ID and dynamic address configuration
set cmd_stream_fifo_group [ipgui::add_group -name "Provisioned ID and dynamic address configuration" -component $cc \
    -parent $page0 -display_name "Provisioned ID and dynamic address configuration" ]

ipgui::add_param -name "DA" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "Dynamic address" \
  "tooltip" "\[DA\] Controller dynamic address, used only for conformity, has no effect." \
] [ipgui::get_guiparamspec -name "DA" -component $cc]

ipgui::add_param -name "PID_MANUF_ID" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "PID - Manufacturer ID" \
  "tooltip" "\[PID_MANUF_ID\] MIPI Manufacturer ID" \
] [ipgui::get_guiparamspec -name "PID_MANUF_ID" -component $cc]

ipgui::add_param -name "PID_TYPE_SELECTOR" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "PID - Type selector" \
  "tooltip" "\[PID_TYPE_SELECTOR\] 1'b1: Random Value, 1'b0: Vendor Fixed Value" \
] [ipgui::get_guiparamspec -name "PID_TYPE_SELECTOR" -component $cc]


ipgui::add_param -name "PID_PART_ID" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "PID - Part ID" \
  "tooltip" "\[PID_PART_ID\] Device identifier, use the same for all instances of this controller" \
] [ipgui::get_guiparamspec -name "PID_PART_ID" -component $cc]


ipgui::add_param -name "PID_INSTANCE_ID" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "PID - Instance ID" \
  "tooltip" "\[PID_INSTANCE_ID\] Identify the individual device" \
] [ipgui::get_guiparamspec -name "PID_INSTANCE_ID" -component $cc]


ipgui::add_param -name "PID_EXTRA_ID" -component $cc -parent $cmd_stream_fifo_group
set_property -dict [list \
  "display_name" "PID - Extra ID" \
  "tooltip" "\[PID_EXTRA_ID\] Extra characteristics field" \
] [ipgui::get_guiparamspec -name "PID_EXTRA_ID" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc
ipx::save_core $cc

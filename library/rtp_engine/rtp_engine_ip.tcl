###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create rtp_engine
adi_ip_files rtp_engine [list \
  "rtp_engine.sv" \
  "rtp_engine_regmap.sv" \
  "rtp_engine_package.sv" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
   "../common/up_axi.v" ]

adi_ip_properties rtp_engine
set_property display_name "RTP Engine" [ipx::current_core]
set_property description "RTP Engine" [ipx::current_core]

adi_init_bd_tcl

proc add_reset {name polarity} {
  set reset_intf [ipx::infer_bus_interface $name xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]]
  set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_intf]
  set_property value $polarity $reset_polarity
}

ipx::infer_bus_interface aclk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

add_reset aresetn ACTIVE_LOW

adi_add_bus "rtp_engine_slave" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid" "TVALID"} \
		{"s_axis_tdata" "TDATA"} \
		{"s_axis_tlast" "TLAST"} \
		{"s_axis_tready" "TREADY"} \
	}

adi_add_bus "rtp_engine_master" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"m_axis_tvalid" "TVALID"} \
		{"m_axis_tdata" "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
		{"m_axis_tready" "TREADY"} \
		{"m_axis_tkeep" "TKEEP"} \
	}

adi_add_bus_clock "aclk" "rtp_engine_slave:rtp_engine_master" "aresetn"

set cc [ipx::current_core]

## Customize XGUI layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page

ipgui::add_page -name {RTP Engine} -component $cc -display_name {RTP Engine}
set page0 [ipgui::get_pagespec -name "RTP Engine" -component $cc]

ipgui::add_param -name "S_TDATA_WIDTH" -component $cc -parent $page0
set_property -dict [list \
	"display_name" "S_TDATA_WIDTH" \
  	"tooltip" "The TDATA width of the slave interface is hardcoded to 64 bits (8 bytes)" \
] [ipgui::get_guiparamspec -name "S_TDATA_WIDTH" -component $cc]
set_property -dict [list \
        "value_validation_type" "range_long" \
        "value_validation_range_minimum" "64" \
        "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters S_TDATA_WIDTH -of_objects $cc]

ipgui::add_param -name "M_TDATA_WIDTH" -component $cc -parent $page0
set_property -dict [list \
        "display_name" "M_TDATA_WIDTH" \
  	"tooltip" "The TDATA width of the master interface is hardcoded to 64 bits (8 bytes)" \
] [ipgui::get_guiparamspec -name "M_TDATA_WIDTH" -component $cc]
set_property -dict [list \
	"value_validation_type" "range_long" \
        "value_validation_range_minimum" "64" \
        "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters M_TDATA_WIDTH -of_objects $cc]

ipgui::add_param -name "SSRC_ID" -component $cc -parent $page0
set_property -dict [list \
        "display_name" "SSRC_ID" \
  	"tooltip" "SSRC IDs can be between 0 to 7, representing the unique ID of each RTP engine instance" \
] [ipgui::get_guiparamspec -name "SSRC_ID" -component $cc]
set_property -dict [list \
	"value_validation_type" "range_long" \
        "value_validation_range_minimum" "0" \
        "value_validation_range_maximum" "7" \
] [ipx::get_user_parameters SSRC_ID -of_objects $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc

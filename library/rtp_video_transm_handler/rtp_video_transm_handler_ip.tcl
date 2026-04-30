###############################################################################
## Copyright (C) 2025 - 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create rtp_video_transm_handler
adi_ip_files rtp_session_concat [list \
  "rtp_video_transm_handler.sv" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/arbiter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/priority_encoder.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_arb_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_rate_limit.v" ]

adi_ip_properties_lite rtp_video_transm_handler

set_property display_name "RTP Video Transmission Handler" [ipx::current_core]
set_property description "RTP Video Transmission Handler" [ipx::current_core]

adi_add_bus "transm_s0" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s0" "TVALID"} \
		{"s_axis_tdata_s0" "TDATA"} \
        	{"s_axis_tkeep_s0" "TKEEP"} \
		{"s_axis_tlast_s0" "TLAST"} \
		{"s_axis_tready_s0" "TREADY"} \
		{"s_axis_tuser_s0" "TUSER"} \
	}

adi_add_bus "transm_s1" "slave" \
        "xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s1" "TVALID"} \
		{"s_axis_tdata_s1" "TDATA"} \
        	{"s_axis_tkeep_s1" "TKEEP"} \
		{"s_axis_tlast_s1" "TLAST"} \
		{"s_axis_tready_s1" "TREADY"} \
	}

adi_add_bus "transm_master" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"m_axis_tvalid_res" "TVALID"} \
		{"m_axis_tdata_res" "TDATA"} \
		{"m_axis_tlast_res" "TLAST"} \
		{"m_axis_tready_res" "TREADY"} \
		{"m_axis_tkeep_res" "TKEEP"} \
		{"m_axis_tuser_res" "TUSER"} \
	}

adi_add_bus_clock "aclk" "transm_s0:transm_s1:transm_master" "areset"

set cc [ipx::current_core]

## Customize XGUI layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page

ipgui::add_page -name {RTP Video Transmission Handler} -component $cc -display_name {RTP Video Transmission Handler}
set page0 [ipgui::get_pagespec -name "RTP Video Transmission Handler" -component $cc]

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

ipx::create_xgui_files $cc
ipx::save_core $cc

###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ip
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create rtp_session_mux
adi_ip_files rtp_session_mux [list \
  "rtp_session_mux.sv" \
  "rtp_session_mux_regmap.sv" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/arbiter.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/axi/rtl/priority_encoder.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_arb_mux.v" \
  "$ad_hdl_dir/../corundum/fpga/lib/eth/lib/axis/rtl/axis_fifo.v" \
  "../common/up_axi.v" ]

adi_ip_properties rtp_session_mux

set_property display_name "RTP Session MUX" [ipx::current_core]
set_property description "RTP Session MUX" [ipx::current_core]

adi_add_bus "rtp_session_0" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s0" "TVALID"} \
		{"s_axis_tdata_s0" "TDATA"} \
        {"s_axis_tkeep_s0" "TKEEP"} \
		{"s_axis_tlast_s0" "TLAST"} \
		{"s_axis_tready_s0" "TREADY"} \
	}

adi_add_bus "rtp_session_1" "slave" \
        "xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s1" "TVALID"} \
		{"s_axis_tdata_s1" "TDATA"} \
        {"s_axis_tkeep_s1" "TKEEP"} \
		{"s_axis_tlast_s1" "TLAST"} \
		{"s_axis_tready_s1" "TREADY"} \
	}

adi_add_bus "rtp_session_2" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s2" "TVALID"} \
		{"s_axis_tdata_s2" "TDATA"} \
        {"s_axis_tkeep_s2" "TKEEP"} \
		{"s_axis_tlast_s2" "TLAST"} \
		{"s_axis_tready_s2" "TREADY"} \
	}

adi_add_bus "rtp_session_3" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s3" "TVALID"} \
		{"s_axis_tdata_s3" "TDATA"} \
        {"s_axis_tkeep_s3" "TKEEP"} \
		{"s_axis_tlast_s3" "TLAST"} \
		{"s_axis_tready_s3" "TREADY"} \
	}

adi_add_bus "rtp_session_4" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s4" "TVALID"} \
		{"s_axis_tdata_s4" "TDATA"} \
        {"s_axis_tkeep_s4" "TKEEP"} \
		{"s_axis_tlast_s4" "TLAST"} \
		{"s_axis_tready_s4" "TREADY"} \
	}

adi_add_bus "rtp_session_5" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s5" "TVALID"} \
		{"s_axis_tdata_s5" "TDATA"} \
        {"s_axis_tkeep_s5" "TKEEP"} \
		{"s_axis_tlast_s5" "TLAST"} \
		{"s_axis_tready_s5" "TREADY"} \
	}

adi_add_bus "rtp_session_6" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s6" "TVALID"} \
		{"s_axis_tdata_s6" "TDATA"} \
        {"s_axis_tkeep_s6" "TKEEP"} \
		{"s_axis_tlast_s6" "TLAST"} \
		{"s_axis_tready_s6" "TREADY"} \
	}

adi_add_bus "rtp_session_7" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"s_axis_tvalid_s7" "TVALID"} \
		{"s_axis_tdata_s7" "TDATA"} \
        {"s_axis_tkeep_s7" "TKEEP"} \
		{"s_axis_tlast_s7" "TLAST"} \
		{"s_axis_tready_s7" "TREADY"} \
	}

adi_add_bus "rtp_master" "master" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{ \
		{"m_axis_tvalid" "TVALID"} \
		{"m_axis_tdata" "TDATA"} \
		{"m_axis_tlast" "TLAST"} \
		{"m_axis_tready" "TREADY"} \
		{"m_axis_tkeep" "TKEEP"} \
	}

adi_set_bus_dependency "rtp_session_1" "rtp_session_1" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 2)"
adi_set_bus_dependency "rtp_session_2" "rtp_session_2" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 3)"
adi_set_bus_dependency "rtp_session_3" "rtp_session_3" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 4)"
adi_set_bus_dependency "rtp_session_4" "rtp_session_4" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 5)"
adi_set_bus_dependency "rtp_session_5" "rtp_session_5" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 6)"
adi_set_bus_dependency "rtp_session_6" "rtp_session_6" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 7)"
adi_set_bus_dependency "rtp_session_7" "rtp_session_7" \
	"(spirit:decode(id('MODELPARAM_VALUE.SESSION_NUMBER')) >= 8)"

adi_add_bus_clock "aclk" "rtp_session_0:rtp_session_1:rtp_session_2:rtp_session_3:rtp_session_4:rtp_session_5:rtp_session_6:rtp_session_7:rtp_master" "aresetn"

set cc [ipx::current_core]

## Customize XGUI layout

## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core $cc

## Create a new GUI page

ipgui::add_page -name {RTP Session MUX} -component $cc -display_name {RTP Session MUX}
set page0 [ipgui::get_pagespec -name "RTP Session MUX" -component $cc]

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

ipgui::add_param -name "SESSION_NUMBER" -component $cc -parent $page0
set_property -dict [list \
        "display_name" "SESSION_NUMBER" \
  	"tooltip" "There can be 1 to 8 RTP engines (sesssions) connected to the MUX design" \
] [ipgui::get_guiparamspec -name "SESSION_NUMBER" -component $cc]
set_property -dict [list \
	"value_validation_type" "range_long" \
        "value_validation_range_minimum" "1" \
        "value_validation_range_maximum" "8" \
] [ipx::get_user_parameters SESSION_NUMBER -of_objects $cc]

#ipgui::remove_param -component $cc [ipx::get_user_parameters -name "S_TKEEP_WIDTH" -component $cc]
#ipgui::remove_param -component $cc [ipx::get_user_parameters -name "M_TKEEP_WIDTH" -component $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc

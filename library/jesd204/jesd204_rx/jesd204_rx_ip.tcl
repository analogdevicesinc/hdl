###############################################################################
## Copyright (C) 2017-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create jesd204_rx
adi_ip_files jesd204_rx [list \
  "jesd204_rx_lane.v" \
  "jesd204_rx_lane_64b.v" \
  "jesd204_rx_header.v" \
  "jesd204_rx_cgs.v" \
  "jesd204_rx_ctrl.v" \
  "jesd204_rx_ctrl_64b.v" \
  "elastic_buffer.v" \
  "error_monitor.v" \
  "jesd204_ilas_monitor.v" \
  "align_mux.v" \
  "jesd204_lane_latency_monitor.v" \
  "jesd204_rx_frame_align.v" \
  "jesd204_rx_constr.ttcl" \
  "jesd204_rx_ooc.ttcl" \
  "jesd204_rx.v" \
  "../../common/ad_pack.v" \
  "../../common/ad_upack.v" \
  "bd/bd.tcl"
]

set_property used_in_simulation false [get_files ./bd/bd.tcl]
set_property used_in_synthesis false [get_files ./bd/bd.tcl]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties_lite jesd204_rx
adi_ip_ttcl jesd204_rx "jesd204_rx_constr.ttcl"
adi_ip_ttcl jesd204_rx "jesd204_rx_ooc.ttcl"
adi_ip_bd jesd204_rx "bd/bd.tcl"

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:jesd204_common:1.0 \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

set_property display_name "ADI JESD204 Receive" [ipx::current_core]
set_property description "ADI JESD204 Receive" [ipx::current_core]

#adi_add_bus "rx_data" "master" \
#  "xilinx.com:interface:axis_rtl:1.0" \
#  "xilinx.com:interface:axis:1.0" \
#  { \
#    { "rx_valid" "TVALID" } \
#    { "rx_data" "TDATA" } \
#  }

adi_add_multi_bus 32 "rx_phy" "slave" \
  "xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_rx_bus:1.0" \
  [list \
    { "phy_data" "rxdata" 32 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')) * 8)"} \
    { "phy_charisk" "rxcharisk" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_disperr" "rxdisperr" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_notintable" "rxnotintable" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_header" "rxheader" 2} \
    { "phy_block_sync" "rxblock_sync" 1} \
  ] \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_LANES')) > {i})"

set_property driver_value 0 [ipx::get_ports phy_charisk -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports phy_disperr -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports phy_notintable -of_objects [ipx::current_core]]

adi_add_bus "rx_cfg" "slave" \
  "analog.com:interface:jesd204_rx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_rx_cfg:1.0" \
  { \
    { "cfg_lanes_disable" "lanes_disable" } \
    { "cfg_links_disable" "links_disable" } \
    { "cfg_octets_per_multiframe" "octets_per_multiframe" } \
    { "cfg_octets_per_frame" "octets_per_frame" } \
    { "cfg_disable_scrambler" "disable_scrambler" } \
    { "cfg_disable_char_replacement" "disable_char_replacement" } \
    { "cfg_frame_align_err_threshold" "frame_align_err_threshold" } \
    { "device_cfg_octets_per_multiframe" "device_octets_per_multiframe" } \
    { "device_cfg_octets_per_frame" "device_octets_per_frame" } \
    { "device_cfg_beats_per_multiframe" "device_beats_per_multiframe" } \
    { "device_cfg_lmfc_offset" "device_lmfc_offset" } \
    { "device_cfg_sysref_oneshot" "device_sysref_oneshot" } \
    { "device_cfg_sysref_disable" "device_sysref_disable" } \
    { "device_cfg_buffer_delay" "device_buffer_delay" } \
    { "device_cfg_buffer_early_release" "device_buffer_early_release" } \
    { "ctrl_err_statistics_reset" "err_statistics_reset" } \
    { "ctrl_err_statistics_mask" "err_statistics_mask" } \
  }

adi_add_bus "rx_status" "master" \
  "analog.com:interface:jesd204_rx_status_rtl:1.0" \
  "analog.com:interface:jesd204_rx_status:1.0" \
  { \
    { "status_ctrl_state" "ctrl_state" } \
    { "status_lane_cgs_state" "lane_cgs_state" } \
    { "status_lane_emb_state" "lane_emb_state" } \
    { "status_err_statistics_cnt" "err_statistics_cnt" } \
    { "status_lane_ifs_ready" "lane_ifs_ready" } \
    { "status_lane_latency" "lane_latency" } \
    { "status_lane_frame_align_err_cnt" "lane_frame_align_err_cnt" } \
    { "status_synth_params0" "synth_params0" } \
    { "status_synth_params1" "synth_params1" } \
    { "status_synth_params2" "synth_params2" } \
  }

adi_add_bus "rx_ilas_config" "master" \
  "analog.com:interface:jesd204_rx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_rx_ilas_config:1.0" \
  { \
    { "ilas_config_valid" "valid" } \
    { "ilas_config_addr" "addr" } \
    { "ilas_config_data" "data" } \
  }

adi_add_bus "rx_event" "master" \
  "analog.com:interface:jesd204_rx_event_rtl:1.0" \
  "analog.com:interface:jesd204_rx_event:1.0" \
  { \
    { "device_event_sysref_alignment_error" "sysref_alignment_error" } \
    { "device_event_sysref_edge" "sysref_edge" } \
    { "event_frame_alignment_error" "frame_alignment_error" } \
    { "event_unexpected_lane_state_error" "unexpected_lane_state_error" } \
  }

adi_add_bus_clock "clk" "rx_cfg:rx_ilas_config:rx_event:rx_status" "reset"
adi_add_bus_clock "device_clk" "rx_data" "device_reset"

adi_set_bus_dependency "rx_ilas_config" "rx_ilas_config" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

adi_set_ports_dependency "sync" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

adi_set_ports_dependency "phy_en_char_align" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

set cc [ipx::current_core]

set_property -dict [list \
  driver_value 0 \
] [ipx::get_ports phy_header -of_objects $cc]

# Arrange GUI page layout
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

# Link layer mode
set p [ipgui::get_guiparamspec -name "LINK_MODE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $page0
set_property -dict [list \
 "display_name" "Link Layer mode" \
 "tooltip" "Link Layer mode" \
 "widget" "comboBox" \
] $p

set_property -dict [list \
  value_validation_type pairs \
  value_validation_pairs {64B66B 2 8B10B 1} \
] [ipx::get_user_parameters $p -of_objects $cc]

# Data width selection
set param [ipx::get_user_parameters DATA_PATH_WIDTH -of_objects $cc]
set_property -dict [list \
  enablement_tcl_expr {$LINK_MODE==1} \
  value_tcl_expr {expr $LINK_MODE*4} \
] $param


set param [ipx::add_user_parameter SYSREF_IOB $cc]
set_property -dict {value_resolve_type user value_format bool value true} $param

set param [ipgui::add_param -name {SYSREF_IOB} -component $cc -parent $page0]
set_property -dict [list \
  display_name {Place SYSREF in IOB} \
  widget {checkBox} \
  show_label true \
] $param

set clk_group [ipgui::add_group -name {Clock Domain Configuration} -component $cc \
    -parent $page0 -display_name {Clock Domain Configuration}]

set p [ipgui::get_guiparamspec -name "ASYNC_CLK" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $clk_group
set_property -dict [list \
  "display_name" "Link and Device Clock Asynchronous" \
  "widget" "checkBox" \
] $p

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]

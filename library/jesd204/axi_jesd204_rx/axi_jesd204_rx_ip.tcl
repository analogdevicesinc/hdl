###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_jesd204_rx
adi_ip_files axi_jesd204_rx [list \
  "../../common/up_axi.v" \
  "jesd204_up_rx.v" \
  "jesd204_up_rx_lane.v" \
  "jesd204_up_ilas_mem.v" \
  "axi_jesd204_rx_constr.xdc" \
  "axi_jesd204_rx_ooc.ttcl" \
  "axi_jesd204_rx.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties axi_jesd204_rx

adi_ip_ttcl axi_jesd204_rx "axi_jesd204_rx_ooc.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_rx} [ipx::current_core]

set_property PROCESSING_ORDER LATE [ipx::get_files axi_jesd204_rx_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:axi_jesd204_common:1.0 \
]

set_property display_name "ADI JESD204C Receive AXI Interface" [ipx::current_core]
set_property description "ADI JESD204C Receive AXI Interface" [ipx::current_core]

adi_add_bus "rx_cfg" "master" \
  "analog.com:interface:jesd204_rx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_rx_cfg:1.0" \
  { \
    { "core_cfg_lanes_disable" "lanes_disable" } \
    { "core_cfg_links_disable" "links_disable" } \
    { "core_cfg_octets_per_multiframe" "octets_per_multiframe" } \
    { "core_cfg_octets_per_frame" "octets_per_frame" } \
    { "core_cfg_disable_char_replacement" "disable_char_replacement" } \
    { "core_cfg_disable_scrambler" "disable_scrambler" } \
    { "core_cfg_frame_align_err_threshold" "frame_align_err_threshold" } \
    { "device_cfg_octets_per_multiframe" "device_octets_per_multiframe" } \
    { "device_cfg_octets_per_frame" "device_octets_per_frame" } \
    { "device_cfg_beats_per_multiframe" "device_beats_per_multiframe" } \
    { "device_cfg_lmfc_offset" "device_lmfc_offset" } \
    { "device_cfg_sysref_oneshot" "device_sysref_oneshot" } \
    { "device_cfg_sysref_disable" "device_sysref_disable" } \
    { "device_cfg_buffer_early_release" "device_buffer_early_release" } \
    { "device_cfg_buffer_delay" "device_buffer_delay" } \
    { "core_ctrl_err_statistics_reset" "err_statistics_reset" } \
    { "core_ctrl_err_statistics_mask" "err_statistics_mask" } \
  }

adi_add_bus "rx_ilas_config" "slave" \
  "analog.com:interface:jesd204_rx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_rx_ilas_config:1.0" \
  { \
    { "core_ilas_config_valid" "valid" } \
    { "core_ilas_config_addr" "addr" } \
    { "core_ilas_config_data" "data" } \
  }

adi_add_bus "rx_event" "slave" \
  "analog.com:interface:jesd204_rx_event_rtl:1.0" \
  "analog.com:interface:jesd204_rx_event:1.0" \
  { \
    { "device_event_sysref_alignment_error" "sysref_alignment_error" } \
    { "device_event_sysref_edge" "sysref_edge" } \
    { "core_event_frame_alignment_error" "frame_alignment_error" } \
    { "core_event_unexpected_lane_state_error" "unexpected_lane_state_error" } \
  }

adi_add_bus "rx_status" "slave" \
  "analog.com:interface:jesd204_rx_status_rtl:1.0" \
  "analog.com:interface:jesd204_rx_status:1.0" \
  { \
    { "core_status_ctrl_state" "ctrl_state" } \
    { "core_status_lane_cgs_state" "lane_cgs_state" } \
    { "core_status_lane_emb_state" "lane_emb_state" } \
    { "core_status_lane_ifs_ready" "lane_ifs_ready" } \
    { "core_status_lane_latency" "lane_latency" } \
    { "core_status_lane_frame_align_err_cnt" "lane_frame_align_err_cnt" } \
    { "core_status_err_statistics_cnt" "err_statistics_cnt" } \
    { "status_synth_params0" "synth_params0" } \
    { "status_synth_params1" "synth_params1" } \
    { "status_synth_params2" "synth_params2" } \
  }

ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

adi_add_bus_clock "core_clk" "rx_status:rx_event:rx_ilas_config:rx_cfg" \
  "core_reset" "master"

set_property DRIVER_VALUE "0" [ipx::get_ports "core_reset_ext"]

adi_set_bus_dependency "rx_ilas_config" "rx_ilas_config" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"
set cc [ipx::current_core]
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

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]

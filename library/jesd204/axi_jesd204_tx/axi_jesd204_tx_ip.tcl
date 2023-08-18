###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_jesd204_tx
adi_ip_files axi_jesd204_tx [list \
  "../../common/up_axi.v" \
  "axi_jesd204_tx_constr.xdc" \
  "axi_jesd204_tx_ooc.ttcl" \
  "jesd204_up_tx.v" \
  "axi_jesd204_tx.v" \
]

set_property source_mgmt_mode DisplayOnly [current_project]

adi_ip_properties axi_jesd204_tx

adi_ip_ttcl axi_jesd204_tx "axi_jesd204_tx_ooc.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/jesd204/axi_jesd204_tx} [ipx::current_core]

set_property PROCESSING_ORDER LATE [ipx::get_files axi_jesd204_tx_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:axi_jesd204_common:1.0 \
]

set_property display_name "ADI JESD204C Transmit AXI Interface" [ipx::current_core]
set_property description "ADI JESD204B Transmit AXI Interface" [ipx::current_core]

adi_add_bus "tx_cfg" "master" \
  "analog.com:interface:jesd204_tx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_tx_cfg:1.0" \
  { \
    { "core_cfg_lanes_disable" "lanes_disable" } \
    { "core_cfg_links_disable" "links_disable" } \
    { "core_cfg_octets_per_multiframe" "octets_per_multiframe" } \
    { "core_cfg_octets_per_frame" "octets_per_frame" } \
    { "core_cfg_continuous_cgs" "continuous_cgs" } \
    { "core_cfg_continuous_ilas" "continuous_ilas" } \
    { "core_cfg_skip_ilas" "skip_ilas" } \
    { "core_cfg_mframes_per_ilas" "mframes_per_ilas" } \
    { "core_cfg_disable_char_replacement" "disable_char_replacement" } \
    { "core_cfg_disable_scrambler" "disable_scrambler" } \
    { "device_cfg_octets_per_multiframe" "device_octets_per_multiframe" } \
    { "device_cfg_octets_per_frame" "device_octets_per_frame" } \
    { "device_cfg_beats_per_multiframe" "device_beats_per_multiframe" } \
    { "device_cfg_lmfc_offset" "device_lmfc_offset" } \
    { "device_cfg_sysref_oneshot" "device_sysref_oneshot" } \
    { "device_cfg_sysref_disable" "device_sysref_disable" } \
  }

adi_add_bus "tx_ilas_config" "slave" \
  "analog.com:interface:jesd204_tx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ilas_config:1.0" \
  { \
    { "core_ilas_config_rd" "rd" } \
    { "core_ilas_config_addr" "addr" } \
    { "core_ilas_config_data" "data" } \
  }

adi_add_bus "tx_event" "slave" \
  "analog.com:interface:jesd204_tx_event_rtl:1.0" \
  "analog.com:interface:jesd204_tx_event:1.0" \
  { \
    { "device_event_sysref_alignment_error" "sysref_alignment_error" } \
    { "device_event_sysref_edge" "sysref_edge" } \
  }

adi_add_bus "tx_status" "slave" \
  "analog.com:interface:jesd204_tx_status_rtl:1.0" \
  "analog.com:interface:jesd204_tx_status:1.0" \
  { \
    { "core_status_state" "state" } \
    { "core_status_sync" "sync" } \
    { "status_synth_params0" "synth_params0" } \
    { "status_synth_params1" "synth_params1" } \
    { "status_synth_params2" "synth_params2" } \
  }

adi_add_bus "tx_ctrl" "master" \
  "analog.com:interface:jesd204_tx_ctrl_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ctrl:1.0" \
  { \
    { "core_ctrl_manual_sync_request" "manual_sync_request" } \
  }

ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

adi_add_bus_clock "core_clk" "tx_status:tx_event:tx_ilas_config:tx_cfg:tx_ctrl" \
  "core_reset" "master"

set_property DRIVER_VALUE "0" [ipx::get_ports "core_reset_ext"]

adi_set_bus_dependency "tx_ilas_config" "tx_ilas_config" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

adi_set_bus_dependency "tx_ctrl" "tx_ctrl" \
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

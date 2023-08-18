###############################################################################
## Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_rx_static_config
adi_ip_files jesd204_rx_static_config [list \
  "jesd204_rx_static_config.v" \
]

adi_ip_properties_lite jesd204_rx_static_config

adi_add_bus "rx_cfg" "master" \
  "analog.com:interface:jesd204_rx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_rx_cfg:1.0" \
  { \
    { "cfg_lanes_disable" "lanes_disable" } \
    { "cfg_links_disable" "links_disable" } \
    { "cfg_octets_per_multiframe" "octets_per_multiframe" } \
    { "cfg_octets_per_frame" "octets_per_frame" } \
    { "cfg_disable_char_replacement" "disable_char_replacement" } \
    { "cfg_disable_scrambler" "disable_scrambler" } \
    { "cfg_frame_align_err_threshold" "frame_align_err_threshold" } \
    { "device_cfg_octets_per_multiframe" "device_octets_per_multiframe" } \
    { "device_cfg_octets_per_frame" "device_octets_per_frame" } \
    { "device_cfg_beats_per_multiframe" "device_beats_per_multiframe" } \
    { "device_cfg_lmfc_offset" "device_lmfc_offset" } \
    { "device_cfg_sysref_oneshot" "device_sysref_oneshot" } \
    { "device_cfg_sysref_disable" "device_sysref_disable" } \
    { "device_cfg_buffer_early_release" "device_buffer_early_release" } \
    { "device_cfg_buffer_delay" "device_buffer_delay" } \
  }
adi_add_bus_clock "clk" "rx_cfg"

ipx::save_core [ipx::current_core]

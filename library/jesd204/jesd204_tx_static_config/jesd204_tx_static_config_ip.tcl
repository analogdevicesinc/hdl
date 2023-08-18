###############################################################################
## Copyright (C) 2017-2019, 2021, 2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_tx_static_config
adi_ip_files jesd204_tx_static_config [list \
  "jesd204_tx_static_config.v" \
  "jesd204_ilas_cfg_static.v" \
]

adi_ip_properties_lite jesd204_tx_static_config

adi_add_bus "tx_cfg" "master" \
  "analog.com:interface:jesd204_tx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_tx_cfg:1.0" \
  { \
    { "cfg_lanes_disable" "lanes_disable" } \
    { "cfg_links_disable" "links_disable" } \
    { "cfg_octets_per_multiframe" "octets_per_multiframe" } \
    { "cfg_octets_per_frame" "octets_per_frame" } \
    { "cfg_continuous_cgs" "continuous_cgs" } \
    { "cfg_continuous_ilas" "continuous_ilas" } \
    { "cfg_skip_ilas" "skip_ilas" } \
    { "cfg_mframes_per_ilas" "mframes_per_ilas" } \
    { "cfg_disable_char_replacement" "disable_char_replacement" } \
    { "cfg_disable_scrambler" "disable_scrambler" } \
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
    { "ilas_config_rd" "rd" } \
    { "ilas_config_addr" "addr" } \
    { "ilas_config_data" "data" } \
  }

adi_add_bus_clock "clk" "tx_cfg:tx_ilas_config"

ipx::save_core [ipx::current_core]

###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create frame_combiner
adi_ip_files frame_combiner [list \
  "frame_combiner.v" \
  $ad_hdl_dir/library/axi_dmac/splitter.v \
  $ad_hdl_dir/library/common/up_axi.v \
  ]

adi_ip_properties frame_combiner

adi_add_bus "s_in_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_in_axis_ready" "TREADY"} \
        {"s_in_axis_valid" "TVALID"} \
        {"s_in_axis_data" "TDATA"} \
        {"s_in_axis_last" "TLAST"} \
        {"s_in_axis_user" "TUSER"} ]
adi_add_bus_clock "s_in_axis_aclk" "s_in_axis"

adi_add_bus "s_fb_in_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_fb_in_axis_ready" "TREADY"} \
        {"s_fb_in_axis_valid" "TVALID"} \
        {"s_fb_in_axis_data" "TDATA"} \
        {"s_fb_in_axis_last" "TLAST"} \
        {"s_fb_in_axis_user" "TUSER"} ]
adi_add_bus_clock "s_fb_in_axis_aclk" "s_fb_in_axis"


adi_add_bus "m_out_axis" "master" \
"xilinx.com:interface:axis_rtl:1.0" \
"xilinx.com:interface:axis:1.0" \
[list {"m_out_axis_ready" "TREADY"} \
      {"m_out_axis_valid" "TVALID"} \
      {"m_out_axis_data" "TDATA"} \
      {"m_out_axis_user" "TUSER"} \
      {"m_out_axis_last" "TLAST"} ]
adi_add_bus_clock "m_out_axis_aclk" "m_out_axis"

adi_add_bus "m_fb_out_axis" "master" \
"xilinx.com:interface:axis_rtl:1.0" \
"xilinx.com:interface:axis:1.0" \
[list {"m_fb_out_axis_ready" "TREADY"} \
      {"m_fb_out_axis_valid" "TVALID"} \
      {"m_fb_out_axis_data" "TDATA"} \
      {"m_fb_out_axis_user" "TUSER"} \
      {"m_fb_out_axis_last" "TLAST"} ]
adi_add_bus_clock "m_fb_out_axis_aclk" "m_fb_out_axis"

ipx::save_core [ipx::current_core]

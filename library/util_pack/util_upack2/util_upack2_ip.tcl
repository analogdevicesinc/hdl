# ***************************************************************************
# ***************************************************************************
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# Each core or library found in this collection may have its own licensing terms.
# The user should keep this in in mind while exploring these cores.
#
# Redistribution and use in source and binary forms,
# with or without modification of this file, are permitted under the terms of either
#  (at the option of the user):
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory, or at:
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
#
# OR
#
#   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
# https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
#
# ***************************************************************************
# ***************************************************************************

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_upack2
adi_ip_files util_upack2 [list \
  "../../common/ad_perfect_shuffle.v" \
  "../util_pack_common/pack_ctrl.v" \
  "../util_pack_common/pack_interconnect.v" \
  "../util_pack_common/pack_network.v" \
  "../util_pack_common/pack_shell.v" \
  "util_upack2_impl.v" \
  "util_upack2.v" ]

adi_ip_properties_lite util_upack2

adi_add_bus "s_axis" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"s_axis_ready" "TREADY"} \
    {"s_axis_valid" "TVALID"} \
    {"s_axis_data" "TDATA"} \
  ]
adi_add_bus_clock "clk" "s_axis" "reset"

set cc [ipx::current_core]

for {set i 1} {$i < 64} {incr i} {
  set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > $i" \
    [ipx::get_ports *_$i -of_objects $cc]
}

foreach {k v} { \
  "NUM_OF_CHANNELS" "Number of Channels" \
  "SAMPLES_PER_CHANNEL" "Samples per Channel" \
  "SAMPLE_DATA_WIDTH" "Sample Width" \
  } { \
  set p [ipgui::get_guiparamspec -name $k -component $cc]
#  ipgui::move_param -component $cc -order $i $p -parent $
  set_property -dict [list \
    DISPLAY_NAME $v \
  ] $p
  incr i
}

ipx::save_core [ipx::current_core]

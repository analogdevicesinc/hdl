###############################################################################
## Copyright (C) 2018-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_cpack2
adi_ip_files util_cpack2 [list \
  "../../common/ad_perfect_shuffle.v" \
  "../util_pack_common/pack_ctrl.v" \
  "../util_pack_common/pack_interconnect.v" \
  "../util_pack_common/pack_network.v" \
  "../util_pack_common/pack_shell.v" \
  "util_cpack2_impl.v" \
  "util_cpack2.v" ]

adi_ip_properties_lite util_cpack2

adi_add_bus "m_axis" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list {"m_axis_ready" "TREADY"} \
    {"m_axis_valid" "TVALID"} \
    {"m_axis_data" "TDATA"} \
    {"m_axis_keep" "TKEEP"} \
    {"m_axis_last" "TLAST"}]

adi_set_bus_dependency "m_axis" "m_axis" \
  "(spirit:decode(id('MODELPARAM_VALUE.INTERFACE_TYPE')) = 0)"

adi_add_bus "packed_fifo_wr" "master" \
  "analog.com:interface:fifo_wr_rtl:1.0" \
  "analog.com:interface:fifo_wr:1.0" \
  { \
    {"packed_fifo_wr_en" "EN"} \
    {"packed_fifo_wr_data" "DATA"} \
    {"packed_fifo_wr_overflow" "OVERFLOW"} \
  }

adi_set_bus_dependency "packed_fifo_wr" "packed_fifo_wr" \
  "(spirit:decode(id('MODELPARAM_VALUE.INTERFACE_TYPE')) = 1)"
adi_set_ports_dependency "packed_sync" \
  "(spirit:decode(id('MODELPARAM_VALUE.INTERFACE_TYPE')) = 1)"

adi_add_bus_clock "clk" "m_axis:packed_fifo_wr" "reset"

set cc [ipx::current_core]

for {set i 1} {$i < 64} {incr i} {
  set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.NUM_OF_CHANNELS')) > $i" \
    [ipx::get_ports *_$i -of_objects $cc]
}

foreach {k v} { \
  "NUM_OF_CHANNELS" "Number of Channels" \
  "SAMPLES_PER_CHANNEL" "Samples per Channel" \
  "SAMPLE_DATA_WIDTH" "Sample Width" \
  "PARALLEL_OR_SERIAL_N" "Parallel prefix sum calculation" \
  } { \
  set p [ipgui::get_guiparamspec -name $k -component $cc]
#  ipgui::move_param -component $cc -order $i $p -parent $
  set_property -dict [list \
    DISPLAY_NAME $v \
  ] $p
  incr i
}

ipx::save_core [ipx::current_core]

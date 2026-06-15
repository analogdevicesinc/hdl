###############################################################################
## Copyright (C) 2018-2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "AXI Streaming" "0" \
    "FIFO Interface" "1" \
  } \
] [ipx::get_user_parameters INTERFACE_TYPE -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Serial" "0" \
    "Parallel" "1" \
  } \
] [ipx::get_user_parameters PARALLEL_OR_SERIAL_N -of_objects $cc]

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set order 0
foreach {k v} { \
  "NUM_OF_CHANNELS" "Number of Channels" \
  "SAMPLES_PER_CHANNEL" "Samples per Channel" \
  "SAMPLE_DATA_WIDTH" "Sample Width" \
  "INTERFACE_TYPE" "Interface Type" \
  "PARALLEL_OR_SERIAL_N" "Parallel prefix sum calculation" \
  } { \
  set p [ipgui::get_guiparamspec -name $k -component $cc]
  ipgui::move_param -component $cc -order $order $p -parent $page0
  set_property -dict [list \
    DISPLAY_NAME $v \
  ] $p
  incr order
}

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]

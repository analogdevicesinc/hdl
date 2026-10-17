###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create util_sample_pack
adi_ip_files util_sample_pack [list \
  "../common/ad_sample_join_fifo.v" \
  "../common/ad_sample_pack.v" \
  "util_sample_pack.v" \
  "util_sample_pack_constr.ttcl" \
]

adi_ip_properties_lite util_sample_pack
adi_ip_ttcl util_sample_pack "util_sample_pack_constr.ttcl"

set cc [ipx::current_core]

set_property display_name "ADI Sample Packer" $cc
set_property description  "Packs the samples of the enabled channels, run time sample size, optional join FIFO" $cc

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_add_bus "packed_fifo_wr" "master" \
  "analog.com:interface:fifo_wr_rtl:1.0" \
  "analog.com:interface:fifo_wr:1.0" \
  { \
    {"packed_fifo_wr_en" "EN"} \
    {"packed_fifo_wr_data" "DATA"} \
    {"packed_fifo_wr_overflow" "OVERFLOW"} \
    {"packed_fifo_wr_xfer_req" "XFER_REQ"} \
  }

adi_add_bus_clock "clk" "packed_fifo_wr" "reset"

set num_ch "spirit:decode(id('MODELPARAM_VALUE.NUM_CH'))"
set join_fifo "spirit:decode(id('MODELPARAM_VALUE.JOIN_FIFO_ENABLE')) = 1"

for {set i 1} {$i < 64} {incr i} {
  set_property enablement_dependency "$num_ch > $i" \
    [ipx::get_ports *_$i -of_objects $cc]
}
for {set i 0} {$i < 64} {incr i} {
  foreach p [list clk_$i reset_$i] {
    set_property enablement_dependency "$num_ch > $i and $join_fifo" \
      [ipx::get_ports $p -of_objects $cc]
  }
}

adi_set_ports_dependency "async_resetn" "($join_fifo)" 1
adi_set_ports_dependency "sample_slots_select" \
  "(spirit:decode(id('MODELPARAM_VALUE.ENABLE_SAMPLE_SLOTS_SELECT')) = 1)" 0
adi_set_ports_dependency "slot_enable" \
  "(spirit:decode(id('MODELPARAM_VALUE.SLOT_ENABLE')) = 1)" 0

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters SLOT_W -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1 2 4 8 16 32 64" \
] [ipx::get_user_parameters NUM_CH -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "list" \
  "value_validation_list" "1 2 4 8 16" \
] [ipx::get_user_parameters CH_SLOTS -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "-1" \
  "value_validation_range_maximum" "16" \
] [ipx::get_user_parameters PIPE_STAGES -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "16" \
] [ipx::get_user_parameters LEVEL_BUDGET -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "2" \
  "value_validation_range_maximum" "8" \
] [ipx::get_user_parameters JOIN_FIFO_ADDRESS_WIDTH -of_objects $cc]

set_property enablement_tcl_expr {expr {$SLOT_ENABLE != 0}} \
  [ipx::get_user_parameters ALWAYS_SLOT_ENABLE_MASK -of_objects $cc]

foreach p {ENABLE_SAMPLE_SLOTS_SELECT CONFIG_CDC SLOT_ENABLE JOIN_FIFO_ENABLE XFER_REQ_ENABLE OVERFLOW_XFER_REQ CONFIG_XFER_HOLD} {
  set_property -dict [list \
    "value_validation_type" "pairs" \
    "value_validation_pairs" { \
      "Disabled" "0" \
      "Enabled" "1" \
    } \
  ] [ipx::get_user_parameters $p -of_objects $cc]
}

# derived here, as packaging freezes the default expression of the Verilog parameter
set_property -dict [list \
  enablement_value false \
  value_tcl_expr {expr {($CH_SLOTS >= 256) ? 4 : ($CH_SLOTS >= 16) ? 3 : ($CH_SLOTS >= 4) ? 2 : 1}} \
] [ipx::get_user_parameters SAMPLE_SLOTS_SELECT_WIDTH -of_objects $cc]

ipx::create_xgui_files $cc
ipx::save_core $cc

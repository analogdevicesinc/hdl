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

adi_ip_create util_sample_join_fifo
adi_ip_files util_sample_join_fifo [list \
  "../common/ad_sample_join_fifo.v" \
  "util_sample_join_fifo.v" \
  "util_sample_join_fifo_constr.ttcl" \
]

adi_ip_properties_lite util_sample_join_fifo
adi_ip_ttcl util_sample_join_fifo "util_sample_join_fifo_constr.ttcl"

set cc [ipx::current_core]

set_property display_name "ADI Sample Join FIFO" $cc
set_property description  "Joins the samples of channels on their own clocks" $cc

adi_ip_add_core_dependencies [list \
  analog.com:$VIVADO_IP_LIBRARY:util_cdc:1.0 \
]

adi_set_ports_dependency "xfer_req" \
  "(spirit:decode(id('MODELPARAM_VALUE.XFER_REQ_ENABLE')) = 1)" 1

for {set i 1} {$i < 64} {incr i} {
  set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.NUM_CHANNELS')) > $i" \
    [ipx::get_ports *_$i -of_objects $cc]
}

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters NUM_CHANNELS -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Disabled" "0" \
    "Enabled" "1" \
  } \
] [ipx::get_user_parameters XFER_REQ_ENABLE -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Disabled" "0" \
    "Enabled" "1" \
  } \
] [ipx::get_user_parameters OVERFLOW_XFER_REQ -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Disabled" "0" \
    "Enabled" "1" \
  } \
] [ipx::get_user_parameters CHANNEL_ENABLE_XFER_HOLD -of_objects $cc]

ipx::save_core $cc

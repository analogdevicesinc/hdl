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

adi_ip_create util_sample_compact
adi_ip_files util_sample_compact [list \
  "../common/ad_sample_compact.v" \
  "util_sample_compact.v" \
]

adi_ip_properties_lite util_sample_compact

set cc [ipx::current_core]

set_property display_name "ADI Sample Compactor" $cc
set_property description  "Packs the kept slots of every cycle into whole words" $cc

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters SLOT_W -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "64" \
] [ipx::get_user_parameters IN_SLOTS -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "1" \
  "value_validation_range_maximum" "128" \
] [ipx::get_user_parameters OUT_SLOTS -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Synchronous" "0" \
    "Asynchronous" "1" \
  } \
] [ipx::get_user_parameters ASYNC_RESET -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "pairs" \
  "value_validation_pairs" { \
    "Automatic" "0" \
    "Mux" "1" \
    "Barrel" "2" \
  } \
] [ipx::get_user_parameters ROT_IMPL -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "-1" \
  "value_validation_range_maximum" "32" \
] [ipx::get_user_parameters PIPE_STAGES -of_objects $cc]

set_property -dict [list \
  "value_validation_type" "range_long" \
  "value_validation_range_minimum" "0" \
  "value_validation_range_maximum" "16" \
] [ipx::get_user_parameters LEVEL_BUDGET -of_objects $cc]

ipx::save_core $cc

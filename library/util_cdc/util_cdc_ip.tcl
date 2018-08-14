# ***************************************************************************
# ***************************************************************************
# Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
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

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create util_cdc

add_files -fileset [get_filesets sources_1] [list \
  "sync_gray.v" \
  "sync_bits.v" \
  "sync_data.v" \
  "sync_event.v" \
]

adi_ip_properties_lite util_cdc

set_property name "util_cdc" [ipx::current_core]
set_property display_name "ADI Clock-Domain-Crossing Utils" [ipx::current_core]
set_property description "ADI Clock-Domain-Crossing Utils" [ipx::current_core]
set_property hide_in_gui {1} [ipx::current_core]

ipx::save_core [ipx::current_core]

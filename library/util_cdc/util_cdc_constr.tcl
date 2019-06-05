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

proc util_cdc_sync_bits_constr {inst {from {}}} {
  if {$from != {}} {
    set_false_path \
      -from [get_registers $from] \
      -to   [get_registers [format "%s%s" ${inst} {|cdc_sync_stage1[0]}]]
  } else {
    set_false_path \
      -to   [get_registers [format "%s%s" ${inst} {|cdc_sync_stage1[0]}]]
  }
}

proc util_cdc_sync_data_constr {inst} {
  util_cdc_sync_bits_constr ${inst}|sync_bits:i_sync_out ${inst}|in_toggle_d1
  util_cdc_sync_bits_constr ${inst}|sync_bits:i_sync_in ${inst}|out_toggle_d1

  # set_max_skew
  set_false_path \
    -from [get_registers [format "%s%s" ${inst} {|cdc_hold[*]}]] \
    -to   [get_registers [format "%s%s" ${inst} {|out_data[*]}]]
}

proc util_cdc_sync_event_constr {inst} {
  util_cdc_sync_bits_constr ${inst}|sync_bits:i_sync_out ${inst}|in_toggle_d1
  util_cdc_sync_bits_constr ${inst}|sync_bits:i_sync_in ${inst}|out_toggle_d1

  set cdc_hold_reg [get_registers -nowarn [format "%s%s" ${inst} {|cdc_hold[*]}]]

  # For a event synchronizer with one event there is no hold register
  if {[get_collection_size ${cdc_hold_reg}] != 0} {
    # set_max_skew
    set_false_path \
      -from ${cdc_hold_reg} \
      -to   [get_registers [format "%s%s" ${inst} {|out_event[*]}]]
  }
}

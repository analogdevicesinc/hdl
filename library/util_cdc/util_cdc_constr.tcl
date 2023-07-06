###############################################################################
## Copyright (C) 2017-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

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

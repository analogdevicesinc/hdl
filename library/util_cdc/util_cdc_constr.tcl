###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
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

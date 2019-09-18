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

package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create util_cpack2 {Channel Pack Utility v2} util_cpack_elab
ad_ip_files util_cpack2_impl [list \
  $ad_hdl_dir/library/common/ad_perfect_shuffle.v \
  ../util_pack_common/pack_ctrl.v \
  ../util_pack_common/pack_interconnect.v \
  ../util_pack_common/pack_network.v \
  ../util_pack_common/pack_shell.v \
  util_cpack2_impl.v ]

# parameters

ad_ip_parameter NUM_OF_CHANNELS INTEGER 4 true [list \
  DISPLAY_NAME "Number of Channels" \
  ALLOWED_RANGES {2, 4, 8, 16}
]

ad_ip_parameter SAMPLES_PER_CHANNEL INTEGER 1 true [list \
  DISPLAY_NAME "Samples per Channel"
]

ad_ip_parameter SAMPLE_DATA_WIDTH INTEGER 16 true [list \
  DISPLAY_NAME "Sample Data Width"
]

# defaults

proc util_cpack_elab {} {
  set num_channels [get_parameter_value NUM_OF_CHANNELS]
  set samples_per_channel [get_parameter_value SAMPLES_PER_CHANNEL]
  set sample_data_width [get_parameter_value SAMPLE_DATA_WIDTH]

  set channel_data_width [expr $sample_data_width * $samples_per_channel]
  set total_data_width [expr $num_channels * $channel_data_width]

  add_interface clk clock end
  add_interface_port clk clk clk Input 1
  add_interface reset reset end
  add_interface_port reset reset reset Input 1
  set_interface_property reset associatedClock clk

  ad_interface signal packed_fifo_wr_en output 1 valid
  ad_interface signal packed_fifo_wr_sync output 1 sync
  ad_interface signal packed_fifo_wr_data output $total_data_width data
  ad_interface signal packed_fifo_wr_overflow input 1 ovf

  ad_interface signal fifo_wr_overflow output 1 ovf

  for {set n 0} {$n < $num_channels} {incr n} {
    add_interface adc_ch_$n conduit end
    add_interface_port adc_ch_$n enable_$n enable Input 1
    set_port_property enable_$n fragment_list [format "enable(%d:%d)" $n $n]

    add_interface_port adc_ch_$n fifo_wr_en_$n valid Input 1
    set_port_property fifo_wr_en_$n fragment_list [format "fifo_wr_en(%d)" $n]
    add_interface_port adc_ch_$n fifo_wr_data_$n data Input $channel_data_width
    set_port_property fifo_wr_data_$n fragment_list [format "fifo_wr_data(%d:%d)" \
      [expr ($n+1) * $channel_data_width - 1] [expr $n * $channel_data_width]]
    set_interface_property adc_ch_$n associatedClock clk
    set_interface_property adc_ch_$n associatedReset ""
  }
}


###############################################################################
## Copyright (C) 2018-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create util_upack2 {Channel Unpack Utility v2} util_upack_elab
ad_ip_files util_upack2_impl [list \
  $ad_hdl_dir/library/common/ad_perfect_shuffle.v \
  ../util_pack_common/pack_ctrl.v \
  ../util_pack_common/pack_interconnect.v \
  ../util_pack_common/pack_network.v \
  ../util_pack_common/pack_shell.v \
  util_upack2_impl.v ]

# parameters

ad_ip_parameter NUM_OF_CHANNELS INTEGER 4 true [list \
  DISPLAY_NAME "Number of Channels"
]

ad_ip_parameter SAMPLES_PER_CHANNEL INTEGER 1 true [list \
  DISPLAY_NAME "Samples per Channel"
]

ad_ip_parameter SAMPLE_DATA_WIDTH INTEGER 16 true [list \
  DISPLAY_NAME "Sample Data Width"
]

ad_ip_parameter INTERFACE_TYPE INTEGER 0 false [list \
  DISPLAY_NAME "Interface Type" \
  ALLOWED_RANGES {"0:AXIS" "1:FIFO"} \
]

ad_ip_parameter PARALLEL_OR_SERIAL_N INTEGER 0 true [list \
  DISPLAY_NAME "Parallel prefix sum calculation" \
  ALLOWED_RANGES {"0:Serial" "1:Parallel"} \
]

# defaults

proc util_upack_elab {} {
  set num_channels [get_parameter_value NUM_OF_CHANNELS]
  set samples_per_channel [get_parameter_value SAMPLES_PER_CHANNEL]
  set sample_data_width [get_parameter_value SAMPLE_DATA_WIDTH]
  set interface_type [get_parameter_value INTERFACE_TYPE]

  set channel_data_width [expr $sample_data_width * $samples_per_channel]
  set total_data_width [expr $num_channels * $channel_data_width]

  add_interface clk clock end
  add_interface_port clk clk clk Input 1
  add_interface reset reset end
  add_interface_port reset reset reset Input 1
  set_interface_property reset associatedClock clk

  # This is a temporary hack and should be removed once all projects have been
  # updated to use the AXI streaming interface to connect the the upack
  if {$interface_type == 0} {
    add_interface s_axis axi4stream end
    set_interface_property s_axis associatedClock clk
    set_interface_property s_axis associatedReset reset
    add_interface_port  s_axis  s_axis_valid tvalid  Input   1
    add_interface_port  s_axis  s_axis_ready tready  Output  1
    add_interface_port  s_axis  s_axis_data  tdata   Input   $total_data_width
  } else {
    ad_interface signal packed_fifo_rd_en output 1 valid
    set_port_property packed_fifo_rd_en fragment_list "s_axis_ready"
    ad_interface signal packed_fifo_rd_data input $total_data_width data
    set_port_property packed_fifo_rd_data fragment_list \
      [format "s_axis_data(%d:0)" [expr $total_data_width - 1]]
    ad_interface signal s_axis_valid input 1 valid
    set_port_property s_axis_valid TERMINATION TRUE
    set_port_property s_axis_valid TERMINATION_VALUE 1
  }

  ad_interface signal fifo_rd_underflow output 1 unf

  for {set n 0} {$n < $num_channels} {incr n} {
    add_interface dac_ch_${n} conduit end
    add_interface_port dac_ch_${n} enable_${n} enable Input 1
    set_port_property enable_${n} fragment_list "enable(${n}:${n})"

    add_interface_port dac_ch_${n} fifo_rd_en_${n} valid Input 1
    set_port_property fifo_rd_en_${n} fragment_list "fifo_rd_en(${n})"
    add_interface_port dac_ch_${n} fifo_rd_valid_${n} data_valid Output 1
    set_port_property fifo_rd_valid_${n} fragment_list "fifo_rd_valid(0)"
    add_interface_port dac_ch_${n} fifo_rd_data_${n} data Output $channel_data_width
    set_port_property fifo_rd_data_${n} fragment_list [format "fifo_rd_data(%d:%d)" \
      [expr ($n+1) * $channel_data_width - 1] [expr $n * $channel_data_width]]
    set_interface_property dac_ch_${n} associatedClock clk
    set_interface_property dac_ch_${n} associatedReset ""
  }
}

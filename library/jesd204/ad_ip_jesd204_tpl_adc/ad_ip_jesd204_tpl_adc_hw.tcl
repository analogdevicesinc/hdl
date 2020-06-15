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

ad_ip_create ad_ip_jesd204_tpl_adc "JESD204 Transport Layer for ADCs" p_ad_ip_jesd204_tpl_adc_elab
set_module_property VALIDATION_CALLBACK p_ad_ip_jesd204_tpl_adc_validate
ad_ip_files ad_ip_jesd204_tpl_adc [list \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/ad_perfect_shuffle.v \
  $ad_hdl_dir/library/common/ad_pnmon.v \
  $ad_hdl_dir/library/common/ad_datafmt.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_adc_common.v \
  $ad_hdl_dir/library/common/up_adc_channel.v \
  $ad_hdl_dir/library/common/ad_xcvr_rx_if.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_common/up_tpl_common.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc_regmap.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc_pnmon.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc_channel.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc_core.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc_deframer.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_adc/ad_ip_jesd204_tpl_adc.v \
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc]

# parameters

set group "General Configuration"

ad_ip_parameter ID INTEGER 0 true [list \
  DISPLAY_NAME "Core ID" \
  GROUP $group \
]

set group "JESD204 Deframer Configuration"

ad_ip_parameter NUM_LANES INTEGER 1 true [list \
  DISPLAY_NAME "Number of Lanes (L)" \
  DISPLAY_UNITS "lanes" \
  ALLOWED_RANGES {1 2 3 4 8} \
  GROUP $group \
]

ad_ip_parameter NUM_CHANNELS INTEGER 1 true [list \
  DISPLAY_NAME "Number of Converters (M)" \
  DISPLAY_UNITS "converters" \
  ALLOWED_RANGES {1 2 4 6 8 16 32 64} \
  GROUP $group \
]

ad_ip_parameter BITS_PER_SAMPLE INTEGER 16 true [list \
  DISPLAY_NAME "Bits per Sample (N')" \
  ALLOWED_RANGES {8 12 16} \
  UNITS bits \
  GROUP $group \
]

ad_ip_parameter CONVERTER_RESOLUTION INTEGER 16 true [list \
  DISPLAY_NAME "Converter Resolution (N)" \
  ALLOWED_RANGES {8 11 12 16} \
  UNITS bits \
  GROUP $group \
]

ad_ip_parameter ENABLE_SAMPLES_PER_FRAME_MANUAL BOOLEAN 0 false [list \
  DISPLAY_NAME "Manual Samples per Frame" \
  GROUP $group \
]

ad_ip_parameter SAMPLES_PER_FRAME INTEGER 1 true [list \
  DISPLAY_NAME "Samples per Frame (S)" \
  DISPLAY_UNITS "samples" \
  ALLOWED_RANGES {1 2 3 4 6 8 12 16} \
  DERIVED true \
  GROUP $group \
]

ad_ip_parameter SAMPLES_PER_FRAME_MANUAL INTEGER 1 false [list \
  DISPLAY_NAME "Samples per Frame (S)" \
  DISPLAY_UNITS "samples" \
  ALLOWED_RANGES {1 2 3 4 6 8 12 16} \
  VISIBLE false \
  GROUP $group \
]

ad_ip_parameter OCTETS_PER_FRAME INTEGER 1 false [list \
  DISPLAY_NAME "Octets per Frame (F)" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {1 2 4 8 12 16} \
  DERIVED true \
  GROUP $group \
]

set group "Deframer Output Information"

# Parameters in this group are informative only and can be read back after the
# core has been configured to find out the expected layout of the input data.
# E.g.
#  set NUM_OF_CHANNELS  [get_instance_parameter_value jesd204_transport NUM_CHANNELS]
#  set CHANNEL_DATA_WIDTH [get_instance_parameter_value jesd204_transport CHANNEL_DATA_WIDTH]
#
#  add_instance util_adc_cpack util_cpack
#  set_instance_parameter_values util_adc_cpack [list \
#    CHANNEL_DATA_WIDTH $CHANNEL_DATA_WIDTH \
#    NUM_OF_CHANNELS $NUM_OF_CHANNELS \
#  ]

ad_ip_parameter SAMPLES_PER_CHANNEL INTEGER 1 false [list \
  DISPLAY_NAME "Samples per Channel per Beat" \
  DERIVED true \
  GROUP $group \
]

ad_ip_parameter CHANNEL_DATA_WIDTH INTEGER 1 false [list \
  DISPLAY_NAME "Channel Data Width" \
  UNITS bits \
  DERIVED true \
  GROUP $group \
]

set group "Datapath Configuration"

ad_ip_parameter TWOS_COMPLEMENT boolean 1 true [list \
  DISPLAY_NAME "Twos Complement" \
  GROUP $group \
]


# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 12

# core clock and start of frame

add_interface link_clk clock end
add_interface_port link_clk link_clk clk Input 1
ad_interface signal link_sof input 4 export

# We don't expect too large values for a and b, trivial implementation will do
proc gcd {a b} {
  if {$a == $b} {
    return $b
  } elseif {$a > $b} {
    return [gcd [expr $a - $b] $b]
  } else {
    return [gcd $a [expr $b - $a]]
  }
}

# validate

proc p_ad_ip_jesd204_tpl_adc_validate {} {
  set L [get_parameter_value "NUM_LANES"]
  set M [get_parameter_value "NUM_CHANNELS"]
  set NP [get_parameter_value "BITS_PER_SAMPLE"]
  set N [get_parameter_value "CONVERTER_RESOLUTION"]
  set S_manual [get_parameter_value "SAMPLES_PER_FRAME_MANUAL"]
  set enable_S_manual [get_parameter_value "ENABLE_SAMPLES_PER_FRAME_MANUAL"]

  # With fixed values for M, L and N' all valid values for S and F have a
  # constant ratio of S / F. Choose a ratio so that S and F are co-prime.
  # Choosing values for F and S that have a common factor has higher latency
  # and no added benefits.
  #
  # Since converters often support those higher latency modes still allow a
  # manual override of the S parameter in case somebody wants to use those modes
  # anyway.
  #
  # To be able to set samples per frame manually ENABLE_SAMPLES_PER_FRAME_MANUAL
  # needs to be set to true and SAMPLES_PER_FRAME_MANUAL to the desired value.
  #
  # When manual sample per frame selection is enabled still verify that the
  # selected value is valid.

  set S_min [expr $L * 8]
  set F_min [expr $M * $NP]
  set common_factor [gcd $S_min $F_min]
  set S_min [expr $S_min / $common_factor]
  set F_min [expr $F_min / $common_factor]

  if {$enable_S_manual} {
    if {$S_manual % $S_min != 0} {
      send_message ERROR "For framer configuration (L=$L, M=$M, NP=$NP) samples per frame (S) must be an integer multiple of $S_min"
      set S $S_min
      set F $F_min
    } else {
      set S $S_manual
      set F [expr $S_manual * $M * $NP / $L / 8]
    }
  } else {
    set S $S_min
    set F $F_min
  }

  set_parameter_value OCTETS_PER_FRAME $F
  set_parameter_value SAMPLES_PER_FRAME $S

  set_parameter_property SAMPLES_PER_FRAME VISIBLE [expr !$enable_S_manual]
  set_parameter_property SAMPLES_PER_FRAME_MANUAL VISIBLE $enable_S_manual

  set_parameter_value SAMPLES_PER_CHANNEL [expr 4 * $S / $F]
  set_parameter_value CHANNEL_DATA_WIDTH [expr 16 * (4 * $S / $F)]

}

# elaborate

proc p_ad_ip_jesd204_tpl_adc_elab {} {

  # read core parameters

  set m_num_of_lanes [get_parameter_value "NUM_LANES"]
  set m_num_of_channels [get_parameter_value "NUM_CHANNELS"]
  set channel_bus_witdh [expr 32*$m_num_of_lanes/$m_num_of_channels]

  # link layer interface

  add_interface link_data avalon_streaming sink
  add_interface_port link_data link_data  data  input  [expr 32*$m_num_of_lanes]
  add_interface_port link_data link_valid valid input  1
  add_interface_port link_data link_ready ready output 1
  set_interface_property link_data associatedClock link_clk
  set_interface_property link_data dataBitsPerSymbol [expr 32*$m_num_of_lanes]

  # dma interface

  for {set i 0} {$i < $m_num_of_channels} {incr i} {
    add_interface adc_ch_$i conduit end
    add_interface_port adc_ch_$i adc_enable_$i enable output 1
    set_port_property adc_enable_$i fragment_list [format "enable(%d:%d)" $i $i]
    add_interface_port adc_ch_$i adc_valid_$i  valid  output 1
    set_port_property adc_valid_$i fragment_list [format "adc_valid(%d:%d)" $i $i]
    add_interface_port adc_ch_$i adc_data_$i   data   output $channel_bus_witdh
    set_port_property adc_data_$i fragment_list \
          [format "adc_data(%d:%d)" [expr $channel_bus_witdh*$i+$channel_bus_witdh-1] [expr $channel_bus_witdh*$i]]
    set_interface_property adc_ch_$i associatedClock link_clk
  }

  ad_interface signal  adc_dovf  input  1 ovf
}

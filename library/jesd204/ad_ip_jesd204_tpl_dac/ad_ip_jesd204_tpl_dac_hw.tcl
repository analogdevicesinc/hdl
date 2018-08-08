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
#   2. An ADI specific BSD license as noted in the top level directory, or on-line at:
# https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
#
# ***************************************************************************
# ***************************************************************************

package require qsys
source ../../scripts/adi_env.tcl
source ../../scripts/adi_ip_alt.tcl

ad_ip_create ad_ip_jesd204_tpl_dac "JESD204 Transport Layer for DACs" p_ad_ip_jesd204_tpl_dac_elab
set_module_property VALIDATION_CALLBACK p_ad_ip_jesd204_tpl_dac_validate
ad_ip_files ad_ip_jesd204_tpl_dac [list \
  $ad_hdl_dir/library/altera/common/ad_mul.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
  $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v \
  $ad_hdl_dir/library/common/ad_dds_sine_cordic.v \
  $ad_hdl_dir/library/common/ad_dds_2.v \
  $ad_hdl_dir/library/common/ad_dds_1.v \
  $ad_hdl_dir/library/common/ad_dds.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_dac_common.v \
  $ad_hdl_dir/library/common/up_dac_channel.v \
  \
  $ad_hdl_dir/library/altera/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_rst_constr.sdc \
  \
  ad_ip_jesd204_tpl_dac.v \
  ad_ip_jesd204_tpl_dac_channel.v \
  ad_ip_jesd204_tpl_dac_core.v \
  ad_ip_jesd204_tpl_dac_framer.v \
  ad_ip_jesd204_tpl_dac_pn.v \
  ad_ip_jesd204_tpl_dac_regmap.v \
]

# parameters

set group "General Configuration"

ad_ip_parameter ID INTEGER 0 true [list \
  DISPLAY_NAME "Core ID" \
  GROUP $group \
]

set group "JESD204 Framer Configuration"

ad_ip_parameter NUM_LANES INTEGER 1 true [list \
  DISPLAY_NAME "Number of Lanes (L)" \
  DISPLAY_UNITS "lanes" \
  ALLOWED_RANGES {1 2 3 4 8} \
  GROUP $group \
]

ad_ip_parameter NUM_CHANNELS INTEGER 1 true [list \
  DISPLAY_NAME "Number of Converters (M)" \
  DISPLAY_UNITS "converters" \
  ALLOWED_RANGES {1 2 4 6 8} \
  GROUP $group \
]

ad_ip_parameter BITS_PER_SAMPLE INTEGER 16 false [list \
  DISPLAY_NAME "Bits per Sample (N')" \
  ALLOWED_RANGES {12 16} \
  UNITS bits \
  GROUP $group \
]

ad_ip_parameter CONVERTER_RESOLUTION INTEGER 16 true [list \
  DISPLAY_NAME "Converter Resolution (N)" \
  ALLOWED_RANGES {11 12 16} \
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
  ALLOWED_RANGES {1 2 4} \
  DERIVED true \
  GROUP $group \
]

set group "Datapath Configuration"

ad_ip_parameter DATAPATH_DISABLE boolean 0 true [list \
  DISPLAY_NAME "Disable Datapath" \
  GROUP $group \
]

ad_ip_parameter DDS_TYPE INTEGER 1 true [list \
  DISPLAY_NAME "DDS Type" \
  ALLOWED_RANGES {"0:Polynominal" "1:CORDIC"} \
  GROUP $group \
]

ad_ip_parameter DDS_CORDIC_DW INTEGER 16 true [list \
  DISPLAY_NAME "CORDIC DDS Data Width" \
  ALLOWED_RANGES {8:20} \
  UNITS bits \
  GROUP $group \
]

ad_ip_parameter DDS_CORDIC_PHASE_DW INTEGER 16 true [list \
  DISPLAY_NAME "CORDIC DDS Phase Width" \
  ALLOWED_RANGES {8:20} \
  UNITS bits \
  GROUP $group \
]

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# core clock and start of frame

add_interface link_clk clock end
add_interface_port link_clk link_clk clk Input 1

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

proc p_ad_ip_jesd204_tpl_dac_validate {} {
  set L [get_parameter_value "NUM_LANES"]
  set M [get_parameter_value "NUM_CHANNELS"]
  set NP [get_parameter_value "BITS_PER_SAMPLE"]
  set N [get_parameter_value "CONVERTER_RESOLUTION"]
  set S_manual [get_parameter_value "SAMPLES_PER_FRAME_MANUAL"]
  set enable_S_manual [get_parameter_value "ENABLE_SAMPLES_PER_FRAME_MANUAL"]

  set channel_bus_width [expr 32 * $L / $M]

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
    foreach i {1 2 4} {
      if {$F * $i <= 4 && $S * $i <= 16} {
        lappend allowed_S [expr $S * $i]
      }
    }

    set_parameter_property SAMPLES_PER_FRAME_MANUAL ALLOWED_RANGES $allowed_S

    if {$S_manual % $S_min != 0} {
      send_message ERROR "For framer configuration (L=$L, M=$M, NP=$NP) samples per frame (S) must be an integer multiple of $S_min"
      set S $S_min
      set F $F_min
    } else {
      set S $S_manual
      set F [expr $S_manual * $M * $NP / $L / 8]
    }
  } else {
    set_parameter_property SAMPLES_PER_FRAME_MANUAL ALLOWED_RANGES {1 2 3 4 6 8 12 16}
    set S $S_min
    set F $F_min
  }

  set_parameter_value OCTETS_PER_FRAME $F
  set_parameter_value SAMPLES_PER_FRAME $S

  set_parameter_property SAMPLES_PER_FRAME VISIBLE [expr !$enable_S_manual]
  set_parameter_property SAMPLES_PER_FRAME_MANUAL VISIBLE $enable_S_manual

  set data_path_enabled [expr ![get_parameter_value DATAPATH_DISABLE]]
  set cordic_enabled [expr $data_path_enabled && [get_parameter_value DDS_TYPE] == 1]

  set_parameter_property DDS_TYPE ENABLED $data_path_enabled
  set_parameter_property DDS_CORDIC_DW ENABLED $cordic_enabled
  set_parameter_property DDS_CORDIC_PHASE_DW ENABLED $cordic_enabled
}

# elaborate

proc p_ad_ip_jesd204_tpl_dac_elab {} {

  # read core parameters

  set L [get_parameter_value "NUM_LANES"]
  set M [get_parameter_value "NUM_CHANNELS"]
  set NP [get_parameter_value "BITS_PER_SAMPLE"]

  # The DMA interface is always 16-bits per sample, regardless of NP
  set channel_bus_width [expr 16 * (32 * $L / ($M * $NP))]

  # link layer interface

  add_interface link_data avalon_streaming source
  add_interface_port link_data link_data  data  output  [expr 32 * $L]
  add_interface_port link_data link_valid valid output  1
  add_interface_port link_data link_ready ready input   1
  set_interface_property link_data associatedClock link_clk
  set_interface_property link_data dataBitsPerSymbol [expr 32 * $L]

  # dma interface

  for {set i 0} {$i < $M} {incr i} {
    add_interface dac_ch_$i conduit end
    add_interface_port dac_ch_$i dac_enable_$i enable output 1
    set_port_property dac_enable_$i fragment_list [format "enable(%d:%d)" $i $i]
    add_interface_port dac_ch_$i dac_valid_$i  valid  output 1
    set_port_property dac_valid_$i fragment_list [format "dac_valid(%d:%d)" $i $i]
    add_interface_port dac_ch_$i dac_data_$i   data   input $channel_bus_width
    set_port_property dac_data_$i fragment_list \
          [format "dac_ddata(%d:%d)" [expr $channel_bus_width*$i+$channel_bus_width-1] [expr $channel_bus_width*$i]]
    set_interface_property dac_ch_$i associatedClock link_clk
  }

  ad_alt_intf signal  dac_dunf  input  1 unf
}

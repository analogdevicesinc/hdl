###############################################################################
## Copyright (C) 2018-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_ip_intel.tcl

ad_ip_create ad_ip_jesd204_tpl_dac "JESD204 Transport Layer for DACs" p_ad_ip_jesd204_tpl_dac_elab
set_module_property VALIDATION_CALLBACK p_ad_ip_jesd204_tpl_dac_validate
ad_ip_files ad_ip_jesd204_tpl_dac [list \
  $ad_hdl_dir/library/intel/common/ad_mul.v \
  $ad_hdl_dir/library/common/ad_mux.v \
  $ad_hdl_dir/library/common/ad_mux_core.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
  $ad_hdl_dir/library/common/ad_dds_cordic_pipe.v \
  $ad_hdl_dir/library/common/ad_dds_sine_cordic.v \
  $ad_hdl_dir/library/common/ad_dds_2.v \
  $ad_hdl_dir/library/common/ad_dds_1.v \
  $ad_hdl_dir/library/common/ad_dds.v \
  $ad_hdl_dir/library/common/ad_iqcor.v \
  $ad_hdl_dir/library/common/ad_perfect_shuffle.v \
  $ad_hdl_dir/library/common/ad_rst.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_xfer_cntrl.v \
  $ad_hdl_dir/library/common/up_xfer_status.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/common/up_dac_common.v \
  $ad_hdl_dir/library/common/up_dac_channel.v \
  $ad_hdl_dir/library/common/util_ext_sync.v \
  \
  $ad_hdl_dir/library/intel/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/intel/common/up_rst_constr.sdc \
  \
  ad_ip_jesd204_tpl_dac.v \
  ad_ip_jesd204_tpl_dac_channel.v \
  ad_ip_jesd204_tpl_dac_core.v \
  ad_ip_jesd204_tpl_dac_framer.v \
  ad_ip_jesd204_tpl_dac_pn.v \
  ad_ip_jesd204_tpl_dac_regmap.v \
  ../ad_ip_jesd204_tpl_common/up_tpl_common.v \
]

# parameters

set group "General Configuration"

ad_ip_parameter ID INTEGER 0 true [list \
  DISPLAY_NAME "Core ID" \
  GROUP $group \
]

ad_ip_parameter OCTETS_PER_BEAT INTEGER 4 true [list \
  DISPLAY_NAME "Datapath width" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 6 8 12} \
  GROUP $group \
]

set group "JESD204 Framer Configuration"

ad_ip_parameter PART STRING "Generic" false [list \
  DISPLAY_NAME "Part" \
  ALLOWED_RANGES { \
    "Generic" \
    "AD9135" \
    "AD9136" \
    "AD9144" \
    "AD9152" \
    "AD9154" \
    "AD9161" \
    "AD9162" \
    "AD9163" \
    "AD9164" \
    "AD9171" \
    "AD9172" \
    "AD9173" \
  } \
  GROUP $group \
]

ad_ip_parameter NUM_LANES INTEGER 1 true [list \
  DISPLAY_NAME "Number of Lanes (L)" \
  DISPLAY_UNITS "lanes" \
  ALLOWED_RANGES {1 2 3 4 8 16 24 32} \
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

ad_ip_parameter DMA_BITS_PER_SAMPLE INTEGER 16 true [list \
  DISPLAY_NAME "DMA Bits per Sample" \
  ALLOWED_RANGES {8 16} \
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
  ALLOWED_RANGES {1 2 3 4 6 8} \
  DERIVED true \
  GROUP $group \
]

set group "Framer Input Information"

# Parameters in this group are informative only and can be read back after the
# core has been configured to find out the expected layout of the input data.
# E.g.
#  set NUM_OF_CHANNELS  [get_instance_parameter_value jesd204_transport NUM_CHANNELS]
#  set CHANNEL_DATA_WIDTH [get_instance_parameter_value jesd204_transport CHANNEL_DATA_WIDTH]
#
#  add_instance util_dac_upack util_upack
#  set_instance_parameter_values util_dac_upack [list \
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

ad_ip_parameter XBAR_ENABLE boolean 0 true [list \
  DISPLAY_NAME "Channel Crossbar Enable" \
  GROUP $group \
]

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 12

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

#  M L S F N  NP
set ad9136_modes { \
  {1 4 2 1 16 16} \
  {1 2 1 1 16 16} \
  {1 1 1 2 16 16} \
  {2 8 2 1 16 16} \
  {2 4 1 1 16 16} \
  {2 2 1 2 16 16} \
}

set ad9144_modes { \
  {4 8 1 1 16 16} \
  {4 8 2 2 16 16} \
  {4 4 1 2 16 16} \
  {4 2 1 4 16 16} \
  {2 4 1 1 16 16} \
  {2 4 2 2 16 16} \
  {2 2 1 2 16 16} \
  {2 1 1 4 16 16} \
  {1 2 1 1 16 16} \
  {1 1 1 2 16 16} \
}

set ad9152_modes { \
  {2 4 1 1 16 16} \
  {2 4 2 2 16 16} \
  {2 2 1 2 16 16} \
  {2 1 1 4 16 16} \
  {1 2 1 1 16 16} \
  {1 1 1 2 16 16} \
}

set ad9161_modes { \
  {2 1 1 4 16 16} \
  {2 2 1 2 16 16} \
  {2 3 3 4 16 16} \
  {2 4 1 1 16 16} \
  {2 6 3 2 16 16} \
  {1 8 4 1 16 16} \
  {2 8 2 1 16 16} \
}

set ad9163_modes { \
  {2 1 1 4 16 16} \
  {2 2 1 2 16 16} \
  {2 3 3 4 16 16} \
  {2 4 1 1 16 16} \
  {2 6 3 2 16 16} \
  {2 8 2 1 16 16} \
}

set ad9171_modes { \
  {2 1 1 4 16 16} \
  {2 2 1 2 16 16} \
  {2 1 1 3 12 12} \
}

set ad9172_modes { \
  {2 1 1 4 16 16} \
  {4 2 1 4 16 16} \
  {6 3 1 4 16 16} \
  {2 2 1 2 16 16} \
  {4 4 1 2 16 16} \
  {2 1 1 3 12 12} \
  {4 2 1 3 12 12} \
  {4 1 1 8 16 16} \
  {2 4 1 1 16 16} \
  {2 4 2 2 16 16} \
  {2 8 2 1 16 16} \
  {2 8 4 2 16 16} \
  {2 8 8 3 12 12} \
  {1 4 2 1 16 16} \
  {1 4 4 2 16 16} \
  {1 8 4 1 16 16} \
  {1 8 8 2 16 16} \
}

set ad9173_modes { \
  {2 1 1 4 16 16} \
  {4 2 1 4 16 16} \
  {6 3 1 4 16 16} \
  {2 2 1 2 16 16} \
  {4 4 1 2 16 16} \
  {2 1 1 3 12 12} \
  {4 2 1 3 12 12} \
  {4 1 1 8 16 16} \
  {2 4 1 1 16 16} \
  {2 4 2 2 16 16} \
  {2 4 1 1 11 16} \
  {2 4 2 2 11 16} \
  {2 8 2 1 11 16} \
  {2 8 4 2 11 16} \
  {2 8 8 3 11 12} \
}

# validate

proc p_ad_ip_jesd204_tpl_dac_validate {} {
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

  set data_path_enabled [expr ![get_parameter_value DATAPATH_DISABLE]]
  set cordic_enabled [expr $data_path_enabled && [get_parameter_value DDS_TYPE] == 1]

  set_parameter_property DDS_TYPE ENABLED $data_path_enabled
  set_parameter_property DDS_CORDIC_DW ENABLED $cordic_enabled
  set_parameter_property DDS_CORDIC_PHASE_DW ENABLED $cordic_enabled

  set part [get_parameter_value "PART"]

  if {$part == "AD9135" || $part == "AD9136"} {
    global ad9136_modes
    set modes $ad9136_modes
  } elseif {$part == "AD9144" || $part == "AD9154"} {
    global ad9144_modes
    set modes $ad9144_modes
  } elseif {$part == "AD9152"} {
    global ad9152_modes
    set modes $ad9152_modes
  } elseif {$part == "AD9161" || $part == "AD9162" || $part == "AD9164"} {
    global ad9161_modes
    set modes $ad9161_modes
  } elseif {$part == "AD9163"} {
    global ad9163_modes
    set modes $ad9163_modes
  } elseif {$part == "AD9171"} {
    global ad9171_modes
    set modes $ad9171_modes
  } elseif {$part == "AD9172"} {
    global ad9172_modes
    set modes $ad9172_modes
  } elseif {$part == "AD9173"} {
    global ad9173_modes
    set modes $ad9173_modes
  } else {
    set modes {}
  }

  if {$modes != {}} {
    set allowed_channels {}
    set allowed_lanes {}
    set allowed_samples_per_frame {}
    set allowed_resolution {}
    set allowed_bits_per_sample {}

    set valid_mode false
    foreach m $modes {
      if {$m == [list $M $L $S $F $N $NP]} {
        set valid_mode true
      }

      lappend allowed_channels [lindex $m 0]
      lappend allowed_lanes [lindex $m 1]
      lappend allowed_samples_per_frame [lindex $m 2]
      lappend allowed_resolution [lindex $m 4]
      lappend allowed_bits_per_sample [lindex $m 5]
    }

    set allowed_channels [lsort -unique -integer $allowed_channels]
    set allowed_lanes [lsort -unique -integer $allowed_lanes]
    set allowed_samples_per_frame [lsort -unique -integer $allowed_samples_per_frame]
    set allowed_resolution [lsort -unique -integer $allowed_resolution]
    set allowed_bits_per_sample [lsort -unique -integer $allowed_bits_per_sample]

    if {!$valid_mode} {
      send_message ERROR "Framer configuration (L=$L, M=$M, N=$N, NP=$NP, S=$S, F=$F) not supported by $part"
    }
  } else {
    set allowed_channels {1 2 4 6 8 16 32 64}
    set allowed_lanes {1 2 3 4 8 16}
    set allowed_samples_per_frame {1 2 3 4 6 8 12 16}
    set allowed_resolution {8 11 12 16}
    set allowed_bits_per_sample {8 12 16}
  }

  set_parameter_property "NUM_CHANNELS" "ALLOWED_RANGES" $allowed_channels
  set_parameter_property "NUM_LANES" "ALLOWED_RANGES" $allowed_lanes
  set_parameter_property "SAMPLES_PER_FRAME" "ALLOWED_RANGES" $allowed_samples_per_frame
  set_parameter_property "CONVERTER_RESOLUTION" "ALLOWED_RANGES" $allowed_resolution
  set_parameter_property "BITS_PER_SAMPLE" "ALLOWED_RANGES" $allowed_bits_per_sample

  if {$enable_S_manual} {
    set allowed_S {}
    foreach i {1 2 4} {
      if {$F_min * $i <= 4 && $S_min * $i <= 16} {
        set new_S [expr $S_min * $i]
        if {[lsearch -integer $allowed_samples_per_frame $new_S] != -1} {
          lappend allowed_S $new_S
        }
      }
    }
    set_parameter_property SAMPLES_PER_FRAME_MANUAL ALLOWED_RANGES $allowed_S
  } else {
    set_parameter_property SAMPLES_PER_FRAME_MANUAL ALLOWED_RANGES {1 2 3 4 6 8 12 16}
  }
}

# elaborate

proc p_ad_ip_jesd204_tpl_dac_elab {} {

  # read core parameters

  set L [get_parameter_value "NUM_LANES"]
  set M [get_parameter_value "NUM_CHANNELS"]
  set NP [get_parameter_value "BITS_PER_SAMPLE"]
  set OPB [get_parameter_value "OCTETS_PER_BEAT"]
  set DMA_BPS [get_parameter_value "DMA_BITS_PER_SAMPLE"]

  # The DMA interface is rounded to nearest power of two bytes per sample,
  # e.g NP=12 is padded into 16 bits
  set samples_per_beat_per_channel [expr ($OPB * 8 * $L / ($M * $NP))]
  set channel_bus_width [expr $samples_per_beat_per_channel*$DMA_BPS]

  # link layer interface

  add_interface link_data avalon_streaming source
  add_interface_port link_data link_data  data  output  [expr $OPB*8*$L]
  add_interface_port link_data link_valid valid output  1
  add_interface_port link_data link_ready ready input   1
  set_interface_property link_data associatedClock link_clk
  set_interface_property link_data dataBitsPerSymbol [expr $OPB*8*$L]

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

  ad_interface signal  dac_dunf  input  1 unf
}

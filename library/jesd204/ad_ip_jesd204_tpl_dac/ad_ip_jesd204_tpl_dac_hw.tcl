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

ad_ip_parameter SAMPLES_PER_FRAME INTEGER 1 true [list \
  DISPLAY_NAME "Samples per Frame (S)" \
  DISPLAY_UNITS "samples" \
  ALLOWED_RANGES {1 2 3 4 6 8 12 16} \
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

# validate

proc p_ad_ip_jesd204_tpl_dac_validate {} {
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

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

ad_ip_create ad_ip_jesd204_tpl_dac {ADI JESD204 Transport DAC Layer} p_ad_ip_jesd204_tpl_dac_elab
ad_ip_files ad_ip_jesd204_tpl_dac [list \
  $ad_hdl_dir/library/altera/common/ad_mul.v \
  $ad_hdl_dir/library/common/ad_dds_sine.v \
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
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_channel.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_core.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_framer.v \
  $ad_hdl_dir/library/jesd204/ad_ip_jesd204_tpl_dac/ad_ip_jesd204_tpl_dac_regmap.v \
  \
  $ad_hdl_dir/library/altera/common/up_xfer_cntrl_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_xfer_status_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_clock_mon_constr.sdc \
  $ad_hdl_dir/library/altera/common/up_rst_constr.sdc \
]

# parameters

ad_ip_parameter ID INTEGER 0
ad_ip_parameter NUM_CHANNELS INTEGER 1
ad_ip_parameter CHANNEL_WIDTH INTEGER 14
ad_ip_parameter NUM_LANES INTEGER 1

# axi4 slave

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

# core clock and start of frame

add_interface link_clk clock end
add_interface_port link_clk link_clk clk Input 1

# elaborate

proc p_ad_ip_jesd204_tpl_dac_elab {} {

  # read core parameters

  set m_num_of_lanes [get_parameter_value "NUM_LANES"]
  set m_num_of_channels [get_parameter_value "NUM_CHANNELS"]
  set channel_bus_witdh [expr 32*$m_num_of_lanes/$m_num_of_channels]

  # link layer interface

  add_interface link_data avalon_streaming source
  add_interface_port link_data link_data  data  output  [expr 32*$m_num_of_lanes]
  add_interface_port link_data link_valid valid output  1
  add_interface_port link_data link_ready ready input   1
  set_interface_property link_data associatedClock link_clk
  set_interface_property link_data dataBitsPerSymbol [expr 32*$m_num_of_lanes]

  # dma interface

  for {set i 0} {$i < $m_num_of_channels} {incr i} {
    add_interface dac_ch_$i conduit end
    add_interface_port dac_ch_$i dac_enable_$i enable output 1
    set_port_property dac_enable_$i fragment_list [format "enable(%d:%d)" $i $i]
    add_interface_port dac_ch_$i dac_valid_$i  valid  output 1
    set_port_property dac_valid_$i fragment_list [format "dac_valid(%d:%d)" $i $i]
    add_interface_port dac_ch_$i dac_data_$i   data   input $channel_bus_witdh
    set_port_property dac_data_$i fragment_list \
          [format "dac_ddata(%d:%d)" [expr $channel_bus_witdh*$i+$channel_bus_witdh-1] [expr $channel_bus_witdh*$i]]
    set_interface_property dac_ch_$i associatedClock link_clk
  }

  ad_alt_intf signal  dac_dunf  input  1 unf
}

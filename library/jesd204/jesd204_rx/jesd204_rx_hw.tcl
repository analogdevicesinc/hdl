###############################################################################
## Copyright (C) 2017-2022, 2024-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_rx "ADI JESD204 Receive" jesd204_rx_elaboration_callback

set_module_property INTERNAL true

# files

ad_ip_files jesd204_rx [list \
  jesd204_rx.v \
  align_mux.v \
  elastic_buffer.v \
  jesd204_ilas_monitor.v \
  jesd204_lane_latency_monitor.v \
  jesd204_rx_cgs.v \
  jesd204_rx_ctrl.v \
  jesd204_rx_ctrl_64b.v \
  jesd204_rx_lane.v \
  error_monitor.v \
  jesd204_rx_lane_64b.v \
  jesd204_rx_header.v \
  jesd204_rx_frame_align.v \
  jesd204_rx_constr.sdc \
  ../jesd204_common/jesd204_eof_generator.v \
  ../jesd204_common/jesd204_crc12.v \
  ../jesd204_common/jesd204_frame_mark.v \
  ../jesd204_common/jesd204_frame_align_replace.v \
  ../jesd204_common/jesd204_lmfc.v \
  ../jesd204_common/jesd204_scrambler.v \
  ../../common/util_pipeline_stage.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_data.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  ../../common/ad_pack.v \
  ../../common/ad_upack.v \
]

# parameters
ad_ip_parameter LINK_MODE INTEGER 1 true { \
  DISPLAY_NAME "Link Layer mode" \
  ALLOWED_RANGES {"1:8B10B" "2:64B66B"} \
  HDL_PARAMETER true \
}

add_parameter NUM_LANES INTEGER 1
set_parameter_property NUM_LANES DISPLAY_NAME "Number of Lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES 1:32
set_parameter_property NUM_LANES HDL_PARAMETER true

add_parameter NUM_LINKS INTEGER 1
set_parameter_property NUM_LINKS DISPLAY_NAME "Number of Links"
set_parameter_property NUM_LINKS ALLOWED_RANGES 1:8
set_parameter_property NUM_LINKS HDL_PARAMETER true

add_parameter NUM_INPUT_PIPELINE INTEGER 1
set_parameter_property NUM_INPUT_PIPELINE DISPLAY_NAME "Number of input pipeline stages"
set_parameter_property NUM_INPUT_PIPELINE ALLOWED_RANGES 1:3
set_parameter_property NUM_INPUT_PIPELINE HDL_PARAMETER true

add_parameter ASYNC_CLK BOOLEAN false
set_parameter_property ASYNC_CLK DISPLAY_NAME "Link and device clock asynchronous"
set_parameter_property ASYNC_CLK HDL_PARAMETER true

ad_ip_parameter DATA_PATH_WIDTH INTEGER 4 true { \
  DISPLAY_NAME "Physical layer datapath widthin" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 8} \
}

ad_ip_parameter TPL_DATA_PATH_WIDTH INTEGER 4 true { \
  DISPLAY_NAME "Transport layer datapath width" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 6 8 12} \
}

#ad_ip_parameter PORT_ENABLE_RX_EOF BOOLEAN false false
#ad_ip_parameter PORT_ENABLE_LMFC_CLK BOOLEAN false false
#ad_ip_parameter PORT_ENABLE_LMFC_EDGE BOOLEAN false false

# link clock

add_interface clock clock end
add_interface_port clock clk clk Input 1

# link clock reset

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT

add_interface_port reset reset reset Input 1

# device clock

add_interface device_clock clock end
add_interface_port device_clock device_clk clk Input 1

# device clock reset

add_interface device_reset reset end
set_interface_property device_reset associatedClock device_clock
set_interface_property device_reset synchronousEdges DEASSERT

add_interface_port device_reset device_reset reset Input 1

# SYSREF~ interface

add_interface sysref conduit end
set_interface_property sysref associatedClock device_clock
set_interface_property sysref associatedReset device_reset
add_interface_port sysref sysref export Input 1

# SYNC interface

add_interface sync conduit end
set_interface_property sync associatedClock clock
set_interface_property sync associatedReset reset
add_interface_port sync sync export Output NUM_LINKS

# link clock domain config interface

add_interface config conduit end
set_interface_property config associatedClock clock
set_interface_property config associatedReset reset

add_interface_port config cfg_lanes_disable lanes_disable Input NUM_LANES
add_interface_port config cfg_links_disable links_disable Input NUM_LINKS
add_interface_port config cfg_octets_per_multiframe octets_per_multiframe Input 10
add_interface_port config cfg_octets_per_frame octets_per_frame Input 8
add_interface_port config cfg_disable_scrambler disable_scrambler Input 1
add_interface_port config cfg_disable_char_replacement disable_char_replacement Input 1
add_interface_port config cfg_frame_align_err_threshold frame_align_err_threshold Input 8
add_interface_port config ctrl_err_statistics_reset err_statistics_reset Input 1
add_interface_port config ctrl_err_statistics_mask err_statistics_mask Input 7

# device clock domain config interface

add_interface device_config conduit end
set_interface_property device_config associatedClock device_clock
set_interface_property device_config associatedReset device_reset

add_interface_port device_config device_cfg_octets_per_multiframe octets_per_multiframe Input 10
add_interface_port device_config device_cfg_octets_per_frame octets_per_frame Input 8
add_interface_port device_config device_cfg_beats_per_multiframe beats_per_multiframe Input 8
add_interface_port device_config device_cfg_lmfc_offset lmfc_offset Input 8
add_interface_port device_config device_cfg_sysref_disable sysref_disable Input 1
add_interface_port device_config device_cfg_sysref_oneshot sysref_oneshot Input 1
add_interface_port device_config device_cfg_buffer_delay buffer_delay Input 8
add_interface_port device_config device_cfg_buffer_early_release buffer_early_release Input 1

# status interface

add_interface status conduit end
set_interface_property status associatedClock clock
set_interface_property status associatedReset reset

add_interface_port status status_ctrl_state ctrl_state Output 2
add_interface_port status status_lane_cgs_state lane_cgs_state Output 2*NUM_LANES
add_interface_port status status_lane_ifs_ready lane_ifs_ready Output NUM_LANES
add_interface_port status status_lane_latency lane_latency Output 14*NUM_LANES
add_interface_port status status_lane_emb_state lane_emb_state Output 3*NUM_LANES
add_interface_port status status_err_statistics_cnt err_statistics_cnt Output 32*NUM_LANES
add_interface_port status status_lane_frame_align_err_cnt lane_frame_align_err_cnt Output 8*NUM_LANES
add_interface_port status status_synth_params0 synth_params0 Output 32
add_interface_port status status_synth_params1 synth_params1 Output 32
add_interface_port status status_synth_params2 synth_params2 Output 32

# event interface

add_interface device_event conduit end
set_interface_property device_event associatedClock device_clock
set_interface_property device_event associatedReset device_reset

add_interface_port device_event device_event_sysref_alignment_error sysref_alignment_error Output 1
add_interface_port device_event device_event_sysref_edge sysref_edge Output 1

# ilas_config interface

add_interface ilas_config conduit end
set_interface_property ilas_config associatedClock clock
set_interface_property ilas_config associatedReset reset

add_interface_port ilas_config ilas_config_addr addr Output NUM_LANES*2
add_interface_port ilas_config ilas_config_data data Output NUM_LANES*32
add_interface_port ilas_config ilas_config_valid valid Output NUM_LANES

# rx_eof interface

add_interface rx_eof conduit end
#set_interface_property rx_eof associatedClock clock
#set_interface_property rx_eof associatedReset reset
add_interface_port rx_eof rx_eof export Output TPL_DATA_PATH_WIDTH
set_port_property rx_eof TERMINATION TRUE

# rx_sof interface

add_interface rx_sof conduit end
#set_interface_property rx_sof associatedClock clock
#set_interface_property rx_sof associatedReset reset
add_interface_port rx_sof rx_sof export Output TPL_DATA_PATH_WIDTH

# lmfc_clk interface

add_interface lmfc_clk conduit end
#set_interface_property lmfc_clk associatedClock clock
#set_interface_property lmfc_clk associatedReset reset
add_interface_port lmfc_clk lmfc_clk export Output 1
set_port_property lmfc_clk TERMINATION TRUE

# lmfc_edge interface

add_interface lmfc_edge conduit end
#set_interface_property lmfc_edge associatedClock clock
#set_interface_property lmfc_edge associatedReset reset
add_interface_port lmfc_edge lmfc_edge export Output 1
set_port_property lmfc_edge TERMINATION TRUE

proc jesd204_rx_elaboration_callback {} {
  set num_lanes [get_parameter_value "NUM_LANES"]
  set tpl_width [get_parameter_value "TPL_DATA_PATH_WIDTH"]
  set phy_width [get_parameter_value "DATA_PATH_WIDTH"]

  # rx_data interface

  add_interface rx_data avalon_streaming source
  set_interface_property rx_data associatedClock device_clock

  add_interface_port rx_data rx_data data output [expr 8*$tpl_width*$num_lanes]
  add_interface_port rx_data rx_valid valid output 1
  set_interface_property rx_data dataBitsPerSymbol [expr 8*$tpl_width*$num_lanes]

  # phy interfaces

  for {set i 0 } {$i < $num_lanes} {incr i} {
    add_interface rx_phy${i} conduit end

    add_interface_port rx_phy${i} rx_phy${i}_data char Input [expr 8*$phy_width]
    set_port_property rx_phy${i}_data fragment_list \
      [format "phy_data(%d:%d)" [expr (8*$phy_width)*($i+1)-1] [expr 8*$phy_width*$i]]

    add_interface_port rx_phy${i} rx_phy${i}_charisk charisk Input $phy_width
    set_port_property rx_phy${i}_charisk fragment_list \
      [format "phy_charisk(%d:%d)" [expr $phy_width*($i+1)-1] [expr $phy_width*$i]]

    add_interface_port rx_phy${i} rx_phy${i}_disperr disperr Input $phy_width
    set_port_property rx_phy${i}_disperr fragment_list \
      [format "phy_disperr(%d:%d)" [expr $phy_width*($i+1)-1] [expr $phy_width*$i]]

    add_interface_port rx_phy${i} rx_phy${i}_notintable notintable Input $phy_width
    set_port_property rx_phy${i}_notintable fragment_list \
      [format "phy_notintable(%d:%d)" [expr $phy_width*($i+1)-1] [expr $phy_width*$i]]

    add_interface_port rx_phy${i} rx_phy${i}_patternalign_en patternalign_en Output 1
    set_port_property rx_phy${i}_patternalign_en fragment_list "phy_en_char_align"

    if {[get_parameter_value "LINK_MODE"]==2} {
      add_interface_port rx_phy${i} rx_phy${i}_header header Input 2
      set_port_property rx_phy${i}_header fragment_list \
        [format "phy_header(%d:%d)" [expr 2*($i+1)-1] [expr 2*$i]]

      add_interface_port rx_phy${i} rx_phy${i}_block_sync block_sync Input 1
      set_port_property rx_phy${i}_block_sync fragment_list \
        [format "phy_block_sync(%d:%d)" [expr $i] [expr $i]]
    }
  }
}

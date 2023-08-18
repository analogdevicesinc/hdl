###############################################################################
## Copyright (C) 2017-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_tx "ADI JESD204 Transmit" jesd204_tx_elaboration_callback

set_module_property INTERNAL true

# files

ad_ip_files jesd204_tx [list \
  jesd204_tx.v \
  jesd204_tx_ctrl.v \
  jesd204_tx_lane.v \
  jesd204_tx_gearbox.v \
  jesd204_tx_constr.sdc \
  ../jesd204_common/jesd204_eof_generator.v \
  ../jesd204_common/jesd204_frame_align_replace.v \
  ../jesd204_common/jesd204_frame_mark.v \
  ../jesd204_common/jesd204_lmfc.v \
  ../jesd204_common/jesd204_scrambler.v \
  ../jesd204_common/pipeline_stage.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  $ad_hdl_dir/library/common/ad_pack.v \
  $ad_hdl_dir/library/common/ad_upack.v \
]

# parameters

add_parameter NUM_LANES INTEGER 1
set_parameter_property NUM_LANES DISPLAY_NAME "Number of Lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES 1:32
set_parameter_property NUM_LANES HDL_PARAMETER true

add_parameter NUM_LINKS INTEGER 1
set_parameter_property NUM_LINKS DISPLAY_NAME "Number of Links"
set_parameter_property NUM_LINKS ALLOWED_RANGES 1:8
set_parameter_property NUM_LINKS HDL_PARAMETER true

add_parameter NUM_OUTPUT_PIPELINE INTEGER 0
set_parameter_property NUM_OUTPUT_PIPELINE DISPLAY_NAME "Number of output pipeline stages"
set_parameter_property NUM_OUTPUT_PIPELINE ALLOWED_RANGES 0:3
set_parameter_property NUM_OUTPUT_PIPELINE HDL_PARAMETER true

add_parameter ASYNC_CLK BOOLEAN false
set_parameter_property ASYNC_CLK DISPLAY_NAME "Link and device clock asynchronous"
set_parameter_property ASYNC_CLK HDL_PARAMETER true

ad_ip_parameter TPL_DATA_PATH_WIDTH INTEGER 4 true { \
  DISPLAY_NAME "Transport layer datapath width" \
  DISPLAY_UNITS "octets" \
  ALLOWED_RANGES {4 6 8 12} \
}

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
add_interface_port sync sync export Input 1

# ilas_config interface

add_interface ilas_config conduit end
set_interface_property ilas_config associatedClock clock
set_interface_property ilas_config associatedReset reset

add_interface_port ilas_config ilas_config_addr addr Output 2
add_interface_port ilas_config ilas_config_data data Input 32*NUM_LANES
add_interface_port ilas_config ilas_config_rd rd Output 1

# event interface

add_interface device_event conduit end
set_interface_property device_event associatedClock device_clock
set_interface_property device_event associatedReset device_reset

add_interface_port device_event device_event_sysref_alignment_error sysref_alignment_error Output 1
add_interface_port device_event device_event_sysref_edge sysref_edge Output 1

# control interface

add_interface control conduit end
set_interface_property control associatedClock clock
set_interface_property control associatedReset reset

add_interface_port control ctrl_manual_sync_request manual_sync_request Input 1

# config interface

add_interface config conduit end
set_interface_property config associatedClock clock
set_interface_property config associatedReset reset

add_interface_port config cfg_octets_per_multiframe octets_per_multiframe Input 10
add_interface_port config cfg_continuous_cgs continuous_cgs Input 1
add_interface_port config cfg_continuous_ilas continuous_ilas Input 1
add_interface_port config cfg_disable_char_replacement disable_char_replacement Input 1
add_interface_port config cfg_disable_scrambler disable_scrambler Input 1
add_interface_port config cfg_lanes_disable lanes_disable Input NUM_LANES
add_interface_port config cfg_links_disable links_disable Input NUM_LINKS
add_interface_port config cfg_mframes_per_ilas mframes_per_ilas Input 8
add_interface_port config cfg_octets_per_frame octets_per_frame Input 8
add_interface_port config cfg_skip_ilas skip_ilas Input 1

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

# status interface

add_interface status conduit end
set_interface_property status associatedClock clock
set_interface_property status associatedReset reset

add_interface_port status status_state state Output 2
add_interface_port status status_sync sync Output 1
add_interface_port status status_synth_params0 synth_params0 Output 32
add_interface_port status status_synth_params1 synth_params1 Output 32
add_interface_port status status_synth_params2 synth_params2 Output 32

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

proc jesd204_tx_elaboration_callback {} {
  set num_lanes [get_parameter_value "NUM_LANES"]
  set tpl_width [get_parameter_value "TPL_DATA_PATH_WIDTH"]

  # tx_data interface

  add_interface tx_data avalon_streaming sink
  set_interface_property tx_data associatedClock device_clock

  add_interface_port tx_data tx_data data input [expr 8*$tpl_width*$num_lanes]
  add_interface_port tx_data tx_ready ready output 1
  add_interface_port tx_data tx_valid valid input 1
  set_interface_property tx_data dataBitsPerSymbol [expr 8*$tpl_width*$num_lanes]

  # phy interfaces

  for {set i 0 } {$i < $num_lanes} {incr i} {
    add_interface tx_phy${i} conduit start
#    set_interface_property tx_phy${i} associatedClock clock
#    set_interface_property tx_phy${i} associatedReset reset
    add_interface_port tx_phy${i} tx_phy${i}_data char Output 32
    set_port_property tx_phy${i}_data fragment_list \
      [format "phy_data(%d:%d)" [expr 32*$i+31] [expr 32*$i]]
    add_interface_port tx_phy${i} tx_phy${i}_charisk charisk Output 4
    set_port_property tx_phy${i}_charisk fragment_list \
      [format "phy_charisk(%d:%d)" [expr 4*$i+3] [expr 4*$i]]
  }
}

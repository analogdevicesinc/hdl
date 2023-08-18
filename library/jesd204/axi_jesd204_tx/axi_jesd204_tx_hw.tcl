###############################################################################
## Copyright (C) 2016-2019, 2021-2022 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

package require qsys 14.0

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create axi_jesd204_tx "ADI JESD204 Transmit AXI Interface"

set_module_property INTERNAL true

# files

ad_ip_files axi_jesd204_tx [list \
  axi_jesd204_tx.v \
  axi_jesd204_tx_constr.sdc \
  jesd204_up_tx.v \
  ../axi_jesd204_common/jesd204_up_common.v \
  ../axi_jesd204_common/jesd204_up_sysref.v \
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/common/up_clock_mon.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_data.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
  $ad_hdl_dir/library/intel/common/up_clock_mon_constr.sdc \
]

# parameters

add_parameter ID NATURAL 0
set_parameter_property ID DISPLAY_NAME "Peripheral ID"
set_parameter_property ID HDL_PARAMETER true

add_parameter NUM_LANES INTEGER 1
set_parameter_property NUM_LANES DISPLAY_NAME "Number of Lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES 1:32
set_parameter_property NUM_LANES HDL_PARAMETER true

add_parameter NUM_LINKS INTEGER 1
set_parameter_property NUM_LINKS DISPLAY_NAME "Number of Links"
set_parameter_property NUM_LINKS ALLOWED_RANGES 1:8
set_parameter_property NUM_LINKS HDL_PARAMETER true

# axi4 slave interface

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 14

# interrupt

add_interface interrupt interrupt end
set_interface_property interrupt associatedClock s_axi_clock
set_interface_property interrupt associatedReset s_axi_reset
#set_interface_property interrupt associatedAddressablePoint s_axi
add_interface_port interrupt irq irq Output 1

# core clock

add_interface core_clock clock end
add_interface_port core_clock core_clk clk Input 1

# device clock

add_interface device_clock clock end
add_interface_port device_clock device_clk clk Input 1

# core reset ext

add_interface core_reset_ext reset end
set_interface_property core_reset_ext associatedClock core_clock
add_interface_port core_reset_ext core_reset_ext reset Input 1

# core reset

add_interface core_reset reset start
set_interface_property core_reset associatedClock core_clock
set_interface_property core_reset associatedResetSinks core_reset_ext
add_interface_port core_reset core_reset reset Output 1

# device reset

add_interface device_reset reset start
set_interface_property device_reset associatedClock device_clock
set_interface_property device_reset associatedResetSinks core_reset_ext
add_interface_port device_reset device_reset reset Output 1

# config interface
#
add_interface config conduit end
set_interface_property config associatedClock core_clock
set_interface_property config associatedReset core_reset

add_interface_port config core_cfg_octets_per_multiframe octets_per_multiframe Output 10
add_interface_port config core_cfg_continuous_cgs continuous_cgs Output 1
add_interface_port config core_cfg_continuous_ilas continuous_ilas Output 1
add_interface_port config core_cfg_disable_char_replacement disable_char_replacement Output 1
add_interface_port config core_cfg_disable_scrambler disable_scrambler Output 1
add_interface_port config core_cfg_lanes_disable lanes_disable Output NUM_LANES
add_interface_port config core_cfg_links_disable links_disable Output NUM_LINKS
add_interface_port config core_cfg_mframes_per_ilas mframes_per_ilas Output 8
add_interface_port config core_cfg_octets_per_frame octets_per_frame Output 8
add_interface_port config core_cfg_skip_ilas skip_ilas Output 1

# device clock domain config interface

add_interface device_config conduit end
set_interface_property device_config associatedClock device_clock
set_interface_property device_config associatedReset device_reset

add_interface_port device_config device_cfg_octets_per_multiframe octets_per_multiframe Output 10
add_interface_port device_config device_cfg_octets_per_frame octets_per_frame Output 8
add_interface_port device_config device_cfg_beats_per_multiframe beats_per_multiframe Output 8
add_interface_port device_config device_cfg_lmfc_offset lmfc_offset Output 8
add_interface_port device_config device_cfg_sysref_disable sysref_disable Output 1
add_interface_port device_config device_cfg_sysref_oneshot sysref_oneshot Output 1

# control interface

add_interface control conduit end
set_interface_property control associatedClock core_clock
set_interface_property control associatedReset core_reset

add_interface_port control core_ctrl_manual_sync_request manual_sync_request Output 1

# ilas config interface

add_interface ilas_config conduit end
set_interface_property ilas_config associatedClock core_clock
set_interface_property ilas_config associatedReset core_reset

add_interface_port ilas_config core_ilas_config_addr addr Input 2
add_interface_port ilas_config core_ilas_config_data data Output 32*NUM_LANES
add_interface_port ilas_config core_ilas_config_rd rd Input 1

# event interface

add_interface device_event conduit end
set_interface_property device_event associatedClock device_clock
set_interface_property device_event associatedReset device_reset

add_interface_port device_event device_event_sysref_alignment_error sysref_alignment_error Input 1
add_interface_port device_event device_event_sysref_edge sysref_edge Input 1

# status interface

add_interface status conduit end
set_interface_property status associatedClock core_clock
set_interface_property status associatedReset core_reset

add_interface_port status core_status_state state Input 2
add_interface_port status core_status_sync sync Input 1
add_interface_port status status_synth_params0 synth_params0 Input 32
add_interface_port status status_synth_params1 synth_params1 Input 32
add_interface_port status status_synth_params2 synth_params2 Input 32

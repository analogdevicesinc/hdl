###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_tdd
set_module_property DESCRIPTION "AXI TDD Interface"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_tdd

ad_ip_files axi_tdd [list\
  $ad_hdl_dir/library/common/up_axi.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/sync_data.v \
  $ad_hdl_dir/library/util_cdc/sync_event.v \
  axi_tdd_pkg.sv \
  axi_tdd_channel.sv \
  axi_tdd_counter.sv \
  axi_tdd_regmap.sv \
  axi_tdd_sync_gen.sv \
  axi_tdd.sv \
  axi_tdd_constr.sdc]

# parameters

set group "General Configuration"

add_parameter ID INTEGER 0
set_parameter_property ID DISPLAY_NAME "Core ID"
set_parameter_property ID HDL_PARAMETER true
set_parameter_property ID GROUP $group

add_parameter CHANNEL_COUNT INTEGER 8
set_parameter_property CHANNEL_COUNT DISPLAY_NAME "Number of TDD Channels"
set_parameter_property CHANNEL_COUNT HDL_PARAMETER true
set_parameter_property CHANNEL_COUNT ALLOWED_RANGES {1:32}
set_parameter_property CHANNEL_COUNT GROUP $group

add_parameter DEFAULT_POLARITY INTEGER 0
set_parameter_property DEFAULT_POLARITY DISPLAY_NAME "Default Channel output Polarity"
set_parameter_property DEFAULT_POLARITY HDL_PARAMETER true
set_parameter_property DEFAULT_POLARITY GROUP $group

add_parameter REGISTER_WIDTH INTEGER 32
set_parameter_property REGISTER_WIDTH DISPLAY_NAME "TDD Register Width"
set_parameter_property REGISTER_WIDTH HDL_PARAMETER true
set_parameter_property REGISTER_WIDTH ALLOWED_RANGES {8:32}
set_parameter_property REGISTER_WIDTH GROUP $group

add_parameter BURST_COUNT_WIDTH INTEGER 32
set_parameter_property BURST_COUNT_WIDTH DISPLAY_NAME "TDD Burst Counter Width"
set_parameter_property BURST_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property BURST_COUNT_WIDTH ALLOWED_RANGES {8:32}
set_parameter_property BURST_COUNT_WIDTH GROUP $group

add_parameter SYNC_INTERNAL INTEGER 1
set_parameter_property SYNC_INTERNAL DISPLAY_NAME "Sync Internal enable"
set_parameter_property SYNC_INTERNAL HDL_PARAMETER true
set_parameter_property SYNC_INTERNAL ALLOWED_RANGES {0:1}
set_parameter_property SYNC_INTERNAL GROUP $group

add_parameter SYNC_EXTERNAL INTEGER 0
set_parameter_property SYNC_EXTERNAL DISPLAY_NAME "Sync External enable"
set_parameter_property SYNC_EXTERNAL HDL_PARAMETER true
set_parameter_property SYNC_EXTERNAL ALLOWED_RANGES {0:1}
set_parameter_property SYNC_EXTERNAL GROUP $group

add_parameter SYNC_EXTERNAL_CDC INTEGER 0
set_parameter_property SYNC_EXTERNAL_CDC DISPLAY_NAME "Sync External CDC enable"
set_parameter_property SYNC_EXTERNAL_CDC HDL_PARAMETER true
set_parameter_property SYNC_EXTERNAL_CDC ALLOWED_RANGES {0:1}
set_parameter_property SYNC_EXTERNAL_CDC GROUP $group

add_parameter SYNC_COUNT_WIDTH INTEGER 64
set_parameter_property SYNC_COUNT_WIDTH DISPLAY_NAME "TDD Sync Counter Width"
set_parameter_property SYNC_COUNT_WIDTH HDL_PARAMETER true
set_parameter_property SYNC_COUNT_WIDTH ALLOWED_RANGES {0:64}
set_parameter_property SYNC_COUNT_WIDTH GROUP $group

# interfaces

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn

add_interface tdd_clock clock end
add_interface_port tdd_clock clk clk Input 1

add_interface tdd_reset reset end
set_interface_property tdd_reset associatedClock tdd_clock
add_interface_port tdd_reset resetn reset_n Input 1

ad_interface signal sync_in input 1
ad_interface signal sync_out output 1
ad_interface signal tdd_channel output 32


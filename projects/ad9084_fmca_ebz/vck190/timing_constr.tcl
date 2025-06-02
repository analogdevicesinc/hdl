###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../../hdl/scripts/adi_env.tcl
# Primary clock definitions

# Set clocks depending on the requested LANE_RATE paramter from the util_adxcvr block
# Maximum values for Link clock:
# 204B - 15.5 Gbps /40 = 387.5MHz
# 204C - 24.75 Gbps /66 = 375MHz
set jesd_mode [get_env_param JESD_MODE 64B66B]
set link_mode [expr {$jesd_mode=="64B66B"?2:1}]

set rx_lane_rate [get_env_param RX_LANE_RATE 20.625]
set tx_lane_rate [get_env_param TX_LANE_RATE 20.625]

set rx_link_clk [expr $rx_lane_rate*1000/[expr {$link_mode==2?66:40}]]
set tx_link_clk [expr $tx_lane_rate*1000/[expr {$link_mode==2?66:40}]]

set rx_link_clk_period [expr 1000/$rx_link_clk]
set tx_link_clk_period [expr 1000/$tx_link_clk]

set rx_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_apollo_rx_jesd/rx/inst]]
set tx_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_apollo_tx_jesd/tx/inst]]
set rx_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_apollo_rx_jesd/rx/inst]]
set tx_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_apollo_tx_jesd/tx/inst]]

set rx_device_clk [expr $rx_link_clk*$rx_ll_width/$rx_tpl_width]
set tx_device_clk [expr $tx_link_clk*$tx_ll_width/$tx_tpl_width]
set rx_device_clk_period [expr 1000/$rx_device_clk]
set tx_device_clk_period [expr 1000/$tx_device_clk]

set ASYMMETRIC_A_B_MODE [get_env_param ASYMMETRIC_A_B_MODE 0]

if {$ASYMMETRIC_A_B_MODE} {
  set rx_b_lane_rate [get_env_param RX_B_LANE_RATE 20.625]
  set tx_b_lane_rate [get_env_param TX_B_LANE_RATE 20.625]

  set rx_b_link_clk [expr $rx_b_lane_rate*1000/[expr {$link_mode==2?66:40}]]
  set tx_b_link_clk [expr $tx_b_lane_rate*1000/[expr {$link_mode==2?66:40}]]

  set rx_b_link_clk_period [expr 1000/$rx_b_link_clk]
  set tx_b_link_clk_period [expr 1000/$tx_b_link_clk]

  set rx_b_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_apollo_rx_b_jesd/rx/inst]]
  set tx_b_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_apollo_tx_b_jesd/tx/inst]]
  set rx_b_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_apollo_rx_b_jesd/rx/inst]]
  set tx_b_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_apollo_tx_b_jesd/tx/inst]]

  set rx_b_device_clk [expr $rx_b_link_clk*$rx_b_ll_width/$rx_b_tpl_width]
  set tx_b_device_clk [expr $tx_b_link_clk*$tx_b_ll_width/$tx_b_tpl_width]
  set rx_b_device_clk_period [expr 1000/$rx_b_device_clk]
  set tx_b_device_clk_period [expr 1000/$tx_b_device_clk]
}

# refclk and refclk_replica are connect to the same source on the PCB
# Set reference clock to same frequency as the link clock,
# this will ease the XCVR out clocks propagation calculation.
# TODO: this restricts RX_LANE_RATE=TX_LANE_RATE
create_clock -name refclk0 -period  $rx_link_clk_period [get_ports ref_clk_p[0]]

# device clock
create_clock -name rx_device_clk     -period  $rx_device_clk_period [get_ports clk_m2c_p[0]]
create_clock -name tx_device_clk     -period  $tx_device_clk_period [get_ports clk_m2c_p[1]]

# hsci input clock
create_clock -name hsci_clk_out      -period  1.25 [get_ports hsci_cko_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] \
  [get_property PERIOD [get_clocks rx_device_clk]] \
  [get_ports {sysref_in*}]
set_input_delay -clock [get_clocks tx_device_clk] -add_delay\
  [get_property PERIOD [get_clocks tx_device_clk]] \
  [get_ports {sysref_in*}]
set_clock_groups -group rx_device_clk -group tx_device_clk -asynchronous

if {$ASYMMETRIC_A_B_MODE} {
  # create_clock -name rx_b_device_clk     -period  $rx_b_device_clk_period [get_ports ref_clk_p[1]]
  # create_clock -name tx_b_device_clk     -period  $tx_b_device_clk_period [get_ports ref_clk_p[2]]

  # set_input_delay -clock [get_clocks rx_device_clk] \
  #   [get_property PERIOD [get_clocks rx_device_clk]] \
  #   [get_ports {sysref_in*}]
  # set_input_delay -clock [get_clocks tx_device_clk] -add_delay\
  #   [get_property PERIOD [get_clocks tx_device_clk]] \
  #   [get_ports {sysref_in*}]
  set_clock_groups -group rx_device_clk -group tx_device_clk -asynchronous
}

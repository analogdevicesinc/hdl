###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Primary clock definitions

# Set clocks depending on the requested LANE_RATE paramter from the util_adxcvr block 
# Maximum values for Link clock: 
# 204B - 15.5 Gbps /40 = 387.5MHz
# 204C - 24.75 Gbps /66 = 375MHz

set link_mode [get_property LINK_MODE [get_cells i_system_wrapper/system_i/util_mxfe_xcvr/inst]]

set rx_lane_rate [get_property RX_LANE_RATE [get_cells i_system_wrapper/system_i/util_mxfe_xcvr/inst]]
set tx_lane_rate [get_property TX_LANE_RATE [get_cells i_system_wrapper/system_i/util_mxfe_xcvr/inst]]

set rx_link_clk [expr $rx_lane_rate*1000/[expr {$link_mode==2?66:40}]]
set tx_link_clk [expr $tx_lane_rate*1000/[expr {$link_mode==2?66:40}]]

set rx_link_clk_period [expr 1000/$rx_link_clk]
set tx_link_clk_period [expr 1000/$tx_link_clk]

set rx_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_mxfe_rx_jesd/rx/inst]]
set tx_ll_width   [get_property DATA_PATH_WIDTH     [get_cells i_system_wrapper/system_i/axi_mxfe_tx_jesd/tx/inst]]
set rx_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_mxfe_rx_jesd/rx/inst]]
set tx_tpl_width  [get_property TPL_DATA_PATH_WIDTH [get_cells i_system_wrapper/system_i/axi_mxfe_tx_jesd/tx/inst]]

set rx_device_clk [expr $rx_link_clk*$rx_ll_width/$rx_tpl_width]
set tx_device_clk [expr $tx_link_clk*$tx_ll_width/$tx_tpl_width]
set rx_device_clk_period [expr 1000/$rx_device_clk]
set tx_device_clk_period [expr 1000/$tx_device_clk]

# Set reference clock to same frequency as the link clock, 
# this will ease the XCVR out clocks propagation calculation.
# TODO: this restricts RX_LANE_RATE=TX_LANE_RATE
create_clock -name refclk         -period  $rx_link_clk_period [get_ports fpga_refclk_in_p]

# device clock
create_clock -name rx_device_clk     -period  $rx_device_clk_period [get_ports clkin8_p]
create_clock -name tx_device_clk     -period  $tx_device_clk_period [get_ports clkin6_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] \
  [get_property PERIOD [get_clocks rx_device_clk]] \
  [get_ports {sysref2_*}]
set_input_delay -clock [get_clocks tx_device_clk] -add_delay\
  [get_property PERIOD [get_clocks tx_device_clk]] \
  [get_ports {sysref2_*}]
set_clock_groups -group rx_device_clk -group tx_device_clk -asynchronous

# For transceiver output clocks use reference clock divided by one 
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]


###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../common/a5e/system_constr.sdc

## Default configuration: 8B10B, 10 Gbps lane rate
##   REF_CLK_RATE    = 10000 / 40 = 250 MHz
##   DEVICE_CLK_RATE = 250 MHz
## When changing the lane rate these have to be updated as well!

create_clock  -period "5.925 ns"  -name ref_clk        [get_ports {fpga_refclk_in_a}]
create_clock  -period "5.925 ns"  -name ref_clk        [get_ports {fpga_refclk_in_b}]
create_clock  -period "5.925 ns"  -name rx_device_clk  [get_ports {rx_device_clk}]
create_clock  -period "5.925 ns"  -name tx_device_clk  [get_ports {tx_device_clk}]

# Ignore these paths since the data is moving through an async fifo inside the
# link layer
set_clock_groups -asynchronous \
    -group [get_clocks rx_device_clk] \
    -group [get_clocks tx_device_clk] \
    -group [get_clocks {i_system_bd|jesd204_phy_a|jesd204_phy_a|native_phy|sip_inst|o_rx_clkout[0]}] \
    -group [get_clocks {i_system_bd|jesd204_phy_a|jesd204_phy_a|native_phy|sip_inst|o_tx_clkout[0]}] \
    -group [get_clocks {i_system_bd|jesd204_phy_b|jesd204_phy_b|native_phy|sip_inst|o_rx_clkout[0]}] \
    -group [get_clocks {i_system_bd|jesd204_phy_b|jesd204_phy_b|native_phy|sip_inst|o_tx_clkout[0]}]

# Constraint SYSREF
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set device_clk_period [get_clock_info -period tx_device_clk]
set_input_delay \
  -clock tx_device_clk \
  [expr $device_clk_period / 8] \
  [get_ports {sysref_in}]

set_false_path \
  -from [get_keepers -no_duplicates {i_system_bd|sys_hps|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}] \
  -to   [get_keepers -no_duplicates {i_system_bd|sys_hps|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}]

###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../common/a5e/system_constr.sdc

## Default configuration: 8B10B, 6.75 Gbps lane rate
##   REF_CLK_RATE    = 6750 / 40 = 168.75 MHz -> 5.926 ns
##   DEVICE_CLK_RATE = 168.75 MHz
## When changing the lane rate these have to be updated as well!

# create_clock  -period "5.926 ns"  -name ref_clk_a      [get_ports {fpga_refclk_in_a}]
# create_clock  -period "5.926 ns"  -name ref_clk_b      [get_ports {fpga_refclk_in_b}]
# create_clock  -period "5.926 ns"  -name rx_device_clk  [get_ports {rx_device_clk}]
# create_clock  -period "5.926 ns"  -name tx_device_clk  [get_ports {tx_device_clk}]

create_clock  -period "4.000 ns"  -name ref_clk_a      [get_ports {fpga_refclk_in_a}]
create_clock  -period "4.000 ns"  -name ref_clk_b      [get_ports {fpga_refclk_in_b}]
create_clock  -period "4.000 ns"  -name rx_device_clk  [get_ports {rx_device_clk}]
create_clock  -period "4.000 ns"  -name tx_device_clk  [get_ports {tx_device_clk}]

derive_clock_uncertainty

# Ignore these paths since the data is moving through an async fifo inside the
# link layer
# In 64B66B mode the adapters cross lane rate/66 (clkout, link side) to lane
# rate/64 (clkout2, gearbox side) through a dcfifo, so both are separate
# asynchronous domains. The instance name is wildcarded: the PHY's ID parameter
# does not reach the composition, so both cores compose native_phy_0.
set_clock_groups -asynchronous \
    -group [get_clocks rx_device_clk] \
    -group [get_clocks tx_device_clk] \
    -group [get_clocks {*|jesd204_phy_a|*|sip_inst|o_rx_clkout[0]}] \
    -group [get_clocks {*|jesd204_phy_a|*|sip_inst|o_tx_clkout[0]}] \
    -group [get_clocks {*|jesd204_phy_a|*|sip_inst|o_rx_clkout2[0]}] \
    -group [get_clocks {*|jesd204_phy_a|*|sip_inst|o_tx_clkout2[0]}] \
    -group [get_clocks {*|jesd204_phy_b|*|sip_inst|o_rx_clkout[0]}] \
    -group [get_clocks {*|jesd204_phy_b|*|sip_inst|o_tx_clkout[0]}] \
    -group [get_clocks {*|jesd204_phy_b|*|sip_inst|o_rx_clkout2[0]}] \
    -group [get_clocks {*|jesd204_phy_b|*|sip_inst|o_tx_clkout2[0]}]

# SYNC~ is asynchronous to the link clock; it is captured by sync_bits
# synchronizers inside the link layer.
set_false_path -to [get_registers {*|i_cdc_sync|cdc_sync_stage*[0]}]
set_false_path -from [get_ports {syncinb_a0 syncinb_b0}]
set_false_path -to [get_ports {syncoutb_a0 syncoutb_b0}]

# The PHY status and handshake signals are resynchronized into sys_cpu_clk by
# sync_bits instances; only their first stage needs the exception.
set_false_path -to [get_registers {*|i_dbg_status_cdc|cdc_sync_stage1*}]
set_false_path -to [get_registers {*|i_phy_handshake_cdc|cdc_sync_stage1*}]

# The TX word clock counters cross from the PHY clocks into sys_cpu_clk through
# their own synchronizer, and are only ever read by software.
# set_false_path -to [get_registers {*|i_phy_*_tx_clk_monitor|i_cdc|cdc_sync_stage1*}]

# Constraint SYSREF
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set device_clk_period [get_clock_info -period tx_device_clk]
set_input_delay \
  -clock tx_device_clk \
  [expr $device_clk_period / 8] \
  [get_ports {sysref_out}]

set_false_path \
  -from [get_keepers -no_duplicates {i_system_bd|sys_hps|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}] \
  -to   [get_keepers -no_duplicates {i_system_bd|sys_hps|sys_hps|sm_hps|sundancemesa_hps_inst~intosc_clk.reg}]

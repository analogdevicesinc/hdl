###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "10.0000 ns"   -name sys_clk_100mhz      [get_ports {sys_clk}]
create_clock -period "4.16667 ns"   -name ref_clk             [get_ports {fpga_refclk_in}]
create_clock -period "8.33334 ns"   -name device_clk          [get_ports {clkin6}]
create_clock -period "4.16667 ns"   -name obs_device_clk      [get_ports {clkin10}]

# Ignore these paths since the data is moving through an async fifo inside the link layer
set_clock_groups -asynchronous \
    -group [get_clocks device_clk] \
    -group [get_clocks {i_system_bd|jesd204_phy|jesd204_phy|native_phy|sip_inst|o_rx_clkout[0]}]

set_clock_groups -asynchronous \
    -group [get_clocks device_clk] \
    -group [get_clocks {i_system_bd|jesd204_phy|jesd204_phy|native_phy|sip_inst|o_tx_clkout[0]}]

set_clock_groups -asynchronous \
    -group [get_clocks obs_device_clk] \
    -group [get_clocks {i_system_bd|jesd204_phy_os|jesd204_phy_os|native_phy|sip_inst|o_rx_clkout[0]}]

set_false_path -from [get_registers *altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out*]

set_clock_groups -asynchronous \
    -group [get_clocks {hps_internal_osc}] \
    -group [get_clocks {sys_clk_100mhz}]

set_clock_groups -asynchronous \
    -group [get_clocks {device_clk}] \
    -group [get_clocks {obs_device_clk}]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set device_clk_period [get_clock_info -period obs_device_clk]
set_input_delay \
  -clock obs_device_clk \
  [expr $device_clk_period / 2] \
  [get_ports {sysref2}]

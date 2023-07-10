###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Primary clock definitions
create_clock -name refclk         -period  4 [get_ports fpga_refclk_in_p]

# device clock
create_clock -name tx_device_clk     -period  4 [get_ports clkin6_p]
create_clock -name rx_device_clk     -period  4 [get_ports clkin10_p]

create_clock -name tx_div_clk   -period  4 [get_pins i_system_wrapper/system_i/util_mxfe_xcvr/inst/i_xch_0/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  4 [get_pins i_system_wrapper/system_i/util_mxfe_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks tx_device_clk] \
  [get_property PERIOD [get_clocks tx_device_clk]] \
  [get_ports {sysref2_*}]


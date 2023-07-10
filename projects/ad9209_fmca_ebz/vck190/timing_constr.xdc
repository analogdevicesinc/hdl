###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Primary clock definitions
create_clock -name refclk         -period  2.667 [get_ports fpga_refclk_in_p]

# device clock
create_clock -name rx_device_clk  -period  2.667 [get_ports clkin10_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] \
  [get_property PERIOD [get_clocks rx_device_clk]] \
  [get_ports {sysref2_*}]

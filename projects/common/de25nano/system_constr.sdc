###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_time_format -unit ns -decimal_places 3

#create_clock -period "50.0 MHz" -name sys_clk_0   [get_ports {CLOCK0_50}]
#create_clock -period "50.0 MHz" -name sys_clk_1   [get_ports {CLOCK1_50}]
create_clock -period "50.0 MHz" -name sys_clk_2   [get_ports {CLOCK2_50}]

create_clock -period "25.0 MHz"    -name sys_hps_clk  [get_ports {HPS_CLK_25}]

# Set Clock Uncertainty
derive_clock_uncertainty

###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# In echo/master clock mode (CLK_MODE 1/2), ad463x_busy is muxed as an
# alternate echo_sclk source during offload. Define it as a physically
# exclusive clock so Vivado can analyze timing for both mux paths.
create_clock -period 12.500 -name BUSY_clk [get_ports ad463x_busy]
set_clock_groups -physically_exclusive -group [get_clocks ECHOSCLK_clk] -group [get_clocks BUSY_clk]

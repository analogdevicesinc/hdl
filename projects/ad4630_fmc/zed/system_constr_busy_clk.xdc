###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# In echo/master clock mode (CLK_MODE 1/2), ad463x_busy is muxed as an
# alternate echo_sclk source during offload. Define it as a physically
# exclusive clock so Vivado can analyze timing for both mux paths.
create_clock -period 12.500 -name BUSY_clk [get_ports ad463x_busy]
set_clock_groups -physically_exclusive -group [get_clocks ECHOSCLK_clk] -group [get_clocks BUSY_clk]

# CLK_MODE=1: echo_sclk is only used for register access (Table 3, 9.4/2.1ns).
# Override the per-SDI defaults (Table 4, 5.6/1.4ns) which apply to CLK_MODE=0.
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -max 9.4 [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks ECHOSCLK_clk] -clock_fall -min 2.1 [get_ports {ad463x_spi_sdi[*]}]

# CLK_MODE=1: source-synchronous DDR capture via SCKOUT/busy (Tables 5/6).
# SDO and SCKOUT are co-aligned from the ADC with tSKEW = ±0.4ns on both edges.
set_input_delay -clock [get_clocks BUSY_clk] -max  0.4              -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -min -0.4              -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -max  0.4 -clock_fall  -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -min -0.4 -clock_fall  -add_delay [get_ports {ad463x_spi_sdi[*]}]

# Source-synchronous: SCKOUT and SDO are co-aligned from AD4630 (tSKEW ±0.4ns).
# BUFG insertion delay on BUSY_clk is pipeline latency, not clock-data skew.
# TODO: uncomment after verifying hold violation in timing report
# set_false_path -hold -from [get_clocks BUSY_clk] -to [get_clocks BUSY_clk]

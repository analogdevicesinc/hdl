###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# In echo/master clock mode (CLK_MODE 1/2), ad463x_busy is muxed as an
# alternate echo_sclk source during offload. Define it as a physically
# exclusive clock so Vivado can analyze timing for both mux paths.
create_clock -period 12.500 -name BUSY_clk [get_ports ad463x_busy]
set_clock_groups -physically_exclusive -group [get_clocks ECHOSCLK_clk] -group [get_clocks BUSY_clk]

# CLK_MODE=1: source-synchronous DDR capture via SCKOUT/busy (Tables 5/6).
# SDO and SCKOUT are co-aligned from the ADC with tSKEW = ±0.4ns on both edges.
set_input_delay -clock [get_clocks BUSY_clk] -max  0.4              -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -min -0.4              -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -max  0.4 -clock_fall  -add_delay [get_ports {ad463x_spi_sdi[*]}]
set_input_delay -clock [get_clocks BUSY_clk] -min -0.4 -clock_fall  -add_delay [get_ports {ad463x_spi_sdi[*]}]

# cs_activate (spi_clk domain) drives async clear on ddr_clk (BUSY_clk)
# domain shift registers and counters. Same functional safety as the
# echo_sclk false_path: asserts during CHIPSELECT, de-asserts before
# SCKOUT begins toggling.
set_false_path -from [get_clocks spi_clk] -to [get_clocks BUSY_clk]

# Source-synchronous: SCKOUT and SDO are co-aligned from AD4630 (tSKEW ±0.4ns).
# BUFG insertion delay on BUSY_clk is not clock-data skew — waive intra-clock hold.
set_false_path -hold -from [get_clocks BUSY_clk] -to [get_clocks BUSY_clk]

# SDI data (shift registers, IDDR outputs, raw sdi pad) feeds combinationally
# into sdi_data via the interleaved/SDR mux. Data is stable for 3+ spi_clk
# cycles before sdi_data_valid fires (implicit synchronizer: last_sdi_bit_m[0..2]
# + edge detector). BUSY_clk and spi_clk are asynchronous (no common primary
# clock) — constrain only the combinational datapath delay (two spi_clk cycles).
set_max_delay -datapath_only -from [get_clocks BUSY_clk] -to [get_clocks spi_clk] [expr {[get_property PERIOD [get_clocks spi_clk]] * 2}]

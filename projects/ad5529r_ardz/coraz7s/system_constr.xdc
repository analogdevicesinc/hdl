###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

# AD5529R SPI interface
# Same Arduino header pins as AD57XX

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad5529r_ardz_spi_sclk]; # Arduino D13, FPGA bank 35
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad5529r_ardz_spi_miso]; # Arduino D12, FPGA bank 35
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad5529r_ardz_spi_mosi]; # Arduino D11, FPGA bank 35
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports ad5529r_ardz_spi_cs];   # Arduino D10, FPGA bank 34

# AD5529R control signals
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports ad5529r_ardz_reset]; # Arduino D8, FPGA bank 34
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports ad5529r_ardz_clear]; # Arduino D7, FPGA bank 34
# ALARM requires 1.8v logic but the arduino header that it is routed through on
# the schematic puts it on FPGA bank 34 which is used by various other important
# pins that require 3.3v
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports ad5529r_ardz_alarm]; # Arduino D4, FPGA bank 34

# AD5529R toggle pins (TG0-TG3)
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {ad5529r_ardz_tg[0]}]; # Arduino D9, FPGA bank 35
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {ad5529r_ardz_tg[1]}]; # Arduino D6, FPGA bank 34
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {ad5529r_ardz_tg[2]}]; # Arduino D5, FPGA bank 34
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {ad5529r_ardz_tg[3]}]; # Arduino D3, FPGA bank 34

# Clock generation and timing constraints
# SPI clock is generated from axi_ad5529r_clkgen MMCM
# 100 MHz -> 140 MHz -> 35 MHz SCLK (with PRESCALE=1)

create_generated_clock -name spi_clk \
  -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*axi_ad5529r_clkgen*i_mmcm]] \
  -master_clock clk_fpga_0 \
  [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*axi_ad5529r_clkgen*i_mmcm]]

create_generated_clock -name SCLK_clk \
  -source [get_pins -hier -filter name=~*sclk_reg/C] \
  -divide_by 4 \
  [get_ports ad5529r_ardz_spi_sclk]

# =============================================================================
# SPI MISO Input Constraint
# =============================================================================
# The SPI engine handles MISO capture timing internally using spi_clk.
# Using set_max_delay instead of set_input_delay because:
#   1. SCLK_clk is a forwarded clock at the output port, not a capture reference
#   2. The ADI SPI engine manages sampling edge alignment in RTL
#   3. Round-trip delay (~20ns) exceeds half-period (14.3ns), making
#      set_input_delay constraints unsolvable
# This constraint ensures reasonable input routing without clock relationship.
# =============================================================================
set_max_delay -datapath_only -from [get_ports ad5529r_ardz_spi_miso] -to [get_clocks spi_clk] 10.0

# =============================================================================
# SPI Output Constraints (CS, MOSI)
# =============================================================================
# Both signals driven by spi_clk domain. Using datapath constraints to ensure
# reasonable routing. CS has stricter limit to meet AD5529R t1 (4ns setup).
# =============================================================================
set_max_delay -datapath_only -from [get_clocks spi_clk] -to [get_ports ad5529r_ardz_spi_cs] 6.0
set_max_delay -datapath_only -from [get_clocks spi_clk] -to [get_ports ad5529r_ardz_spi_mosi] 7.0

# =============================================================================
# Control Signals (reset, clear, alarm)
# =============================================================================
# Connected to PS GPIO (clk_fpga_0 domain). Slow software-controlled signals.
# =============================================================================
set_max_delay -datapath_only -from [get_clocks clk_fpga_0] -to [get_ports ad5529r_ardz_reset] 10.0
set_max_delay -datapath_only -from [get_clocks clk_fpga_0] -to [get_ports ad5529r_ardz_clear] 10.0
set_max_delay -datapath_only -from [get_ports ad5529r_ardz_alarm] -to [get_clocks clk_fpga_0] 10.0

# =============================================================================
# Toggle Pin Output Constraints (TG0-TG3)
# =============================================================================
# Toggle pins are driven by axi_pwm_gen using spi_clk (140 MHz).
# AD5529R max toggle frequency is 5 MHz (200ns period) - no strict timing.
# Using datapath constraint to ensure reasonable routing.
# =============================================================================
set_max_delay -datapath_only -from [get_clocks spi_clk] -to [get_ports {ad5529r_ardz_tg[*]}] 7.0

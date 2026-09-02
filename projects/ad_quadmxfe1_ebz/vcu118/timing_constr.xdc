###############################################################################
## Copyright (C) 2021-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# Primary clock definitions
# These two reference clocks are connect to the same source on the PCB
create_clock -name refclk         -period  4.00 [get_ports fpga_clk_m2c_p[0]]
create_clock -name refclk_replica -period  4.00 [get_ports fpga_clk_m2c_0_replica_n]

# rx device clock
create_clock -name rx_device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[1]]
# tx device clock
create_clock -name tx_device_clk     -period  4.00 [get_ports fpga_clk_m2c_p[2]]

# SPI 2 clock
create_generated_clock -name spi_2_clk  \
  -source [get_pins i_system_wrapper/system_i/axi_spi_2/ext_spi_clk] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/axi_spi_2/sck_o]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Edge-Aligned signal to REFCLK
set_input_delay -clock [get_clocks rx_device_clk] \
  [get_property PERIOD [get_clocks rx_device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]
set_input_delay -clock [get_clocks tx_device_clk] -add_delay\
  [get_property PERIOD [get_clocks tx_device_clk]] \
  [get_ports {fpga_sysref_m2c_*}]
set_clock_groups -group rx_device_clk -group tx_device_clk -asynchronous


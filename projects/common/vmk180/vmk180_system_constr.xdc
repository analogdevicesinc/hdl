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

create_clock -period 5.000 -name sys_clk_p [get_ports sys_clk_p]

set_property	PACKAGE_PIN	AF43 	[get_ports sys_clk_n]
set_property	PACKAGE_PIN	AE42	[get_ports sys_clk_p]

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO*]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO*]

# GPIOs
# (switches, leds and such)
set_property -dict {PACKAGE_PIN H34 IOSTANDARD LVCMOS18} [get_ports gpio_led[0]] ; # DS6
set_property -dict {PACKAGE_PIN J33 IOSTANDARD LVCMOS18} [get_ports gpio_led[1]] ; # DS5
set_property -dict {PACKAGE_PIN K36 IOSTANDARD LVCMOS18} [get_ports gpio_led[2]] ; # DS4
set_property -dict {PACKAGE_PIN L35 IOSTANDARD LVCMOS18} [get_ports gpio_led[3]] ; # DS3

set_property -dict {PACKAGE_PIN J35 IOSTANDARD LVCMOS18} [get_ports gpio_dip_sw[0]] ; # SW6.1
set_property -dict {PACKAGE_PIN J34 IOSTANDARD LVCMOS18} [get_ports gpio_dip_sw[1]] ; # SW6.2
set_property -dict {PACKAGE_PIN H37 IOSTANDARD LVCMOS18} [get_ports gpio_dip_sw[2]] ; # SW6.3
set_property -dict {PACKAGE_PIN H36 IOSTANDARD LVCMOS18} [get_ports gpio_dip_sw[3]] ; # SW6.4

set_property -dict {PACKAGE_PIN G37 IOSTANDARD LVCMOS18} [get_ports gpio_pb[0]] ; # SW4
set_property -dict {PACKAGE_PIN G36 IOSTANDARD LVCMOS18} [get_ports gpio_pb[1]] ; # SW5

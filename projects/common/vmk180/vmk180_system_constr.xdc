###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period 5.000 -name sys_clk_p [get_ports sys_clk_p]

set_property	PACKAGE_PIN	AF43 	[get_ports sys_clk_n]
set_property	PACKAGE_PIN	AE42	[get_ports sys_clk_p]

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

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

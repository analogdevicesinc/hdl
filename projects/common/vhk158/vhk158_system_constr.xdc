###############################################################################
## Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period 5.000 -name sys_clk_p [get_ports sys_clk_p]


set_property	PACKAGE_PIN	AY6 	[get_ports sys_clk_n]
set_property	PACKAGE_PIN	AW6	  [get_ports sys_clk_p]

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

# GPIOs
# (switches, leds and such)
set_property -dict {PACKAGE_PIN BK26 IOSTANDARD LVCMOS15} [get_ports gpio_led[0]] ;
set_property -dict {PACKAGE_PIN BK25 IOSTANDARD LVCMOS15} [get_ports gpio_led[1]] ;
set_property -dict {PACKAGE_PIN BJ27 IOSTANDARD LVCMOS15} [get_ports gpio_led[2]] ;
set_property -dict {PACKAGE_PIN BJ26 IOSTANDARD LVCMOS15} [get_ports gpio_led[3]] ;

set_property -dict {PACKAGE_PIN BR28 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[0]] ; # SW6.0
set_property -dict {PACKAGE_PIN BP28 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[1]] ; # SW6.1
set_property -dict {PACKAGE_PIN BP29 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[2]] ; # SW6.2
set_property -dict {PACKAGE_PIN BN28 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[3]] ; # SW6.3

set_property -dict {PACKAGE_PIN BT29 IOSTANDARD LVCMOS15} [get_ports gpio_pb[0]] ; # SW4
set_property -dict {PACKAGE_PIN BT28 IOSTANDARD LVCMOS15} [get_ports gpio_pb[1]] ; # SW5

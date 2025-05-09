###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period 5.000 -name sys_clk_p [get_ports sys_clk_p]

set_property	PACKAGE_PIN	BK5 	  [get_ports sys_clk_n]
set_property	PACKAGE_PIN	BK6	    [get_ports sys_clk_p]

# Define SPI clock
create_clock -name spi0_clk      -period 40  [get_pins -hier */EMIOSPI0SCLKO*]
create_clock -name spi1_clk      -period 40  [get_pins -hier */EMIOSPI1SCLKO*]

# GPIOs
# (switches, leds and such)
set_property -dict {PACKAGE_PIN BA49 IOSTANDARD LVCMOS15} [get_ports gpio_led[0]]
set_property -dict {PACKAGE_PIN AY50 IOSTANDARD LVCMOS15} [get_ports gpio_led[1]]
set_property -dict {PACKAGE_PIN BA48 IOSTANDARD LVCMOS15} [get_ports gpio_led[2]]
set_property -dict {PACKAGE_PIN AY49 IOSTANDARD LVCMOS15} [get_ports gpio_led[3]]

set_property -dict {PACKAGE_PIN BE46 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[0]]
set_property -dict {PACKAGE_PIN BD46 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[1]]
set_property -dict {PACKAGE_PIN BJ48 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[2]]
set_property -dict {PACKAGE_PIN BH49 IOSTANDARD LVCMOS15} [get_ports gpio_dip_sw[3]]

set_property -dict {PACKAGE_PIN BT48 IOSTANDARD LVCMOS15} [get_ports gpio_pb[0]]
set_property -dict {PACKAGE_PIN BR47 IOSTANDARD LVCMOS15} [get_ports gpio_pb[1]]

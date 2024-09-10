###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
# gpio (switches, leds and such)

set_property -dict {PACKAGE_PIN AN14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[0]}]
set_property -dict {PACKAGE_PIN AP14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[1]}]
set_property -dict {PACKAGE_PIN AM14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[2]}]
set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[3]}]
set_property -dict {PACKAGE_PIN AN12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[4]}]
set_property -dict {PACKAGE_PIN AP12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[5]}]
set_property -dict {PACKAGE_PIN AL13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[6]}]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[7]}]
set_property -dict {PACKAGE_PIN AE14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[8]}]
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[9]}]
set_property -dict {PACKAGE_PIN AG15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[10]}]
set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[11]}]
set_property -dict {PACKAGE_PIN AG13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_i[12]}]

set_property -dict {PACKAGE_PIN AG14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[0]}]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[1]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[2]}]
set_property -dict {PACKAGE_PIN AJ14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[3]}]
set_property -dict {PACKAGE_PIN AJ15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[4]}]
set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[5]}]
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[6]}]
set_property -dict {PACKAGE_PIN AL12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_o[7]}]

# Define SPI clock
create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]
create_clock -period 40.000 -name spi1_clk [get_pins -hier */EMIOSPI1SCLKO]


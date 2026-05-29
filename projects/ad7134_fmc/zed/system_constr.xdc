###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad713x SPI configuration interface

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS18} [get_ports ad713x_spi_sdi]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS18} [get_ports ad713x_spi_sdo]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports ad713x_spi_sclk]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports {ad713x_spi_cs[0]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {ad713x_spi_cs[1]}]

# ad713x data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18} [get_ports ad713x_dclk]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[0]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[1]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[2]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[3]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[4]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[5]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[6]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS18} [get_ports {ad713x_din[7]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports ad713x_odr]

# ad713x GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {ad713x_resetn[0]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports {ad713x_resetn[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports {ad713x_pdn[0]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports {ad713x_pdn[1]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS18} [get_ports {ad713x_mode[0]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS18} [get_ports {ad713x_mode[1]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[0]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[1]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[2]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[3]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[4]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[5]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS18} [get_ports {ad713x_gpio[7]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS18} [get_ports {ad713x_dclkio[0]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS18} [get_ports {ad713x_dclkio[1]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS18} [get_ports ad713x_pinbspi]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports ad713x_dclkmode]

# ad713x reference clock (not used by default)

set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS18} [get_ports ad713x_sdpclk]

# set IOSTANDARD according to VADJ 1.8V

# constraints
# hdmi

set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS18} [get_ports hdmi_out_clk]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports hdmi_vsync]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports hdmi_hsync]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports hdmi_data_e]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[0]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[1]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[2]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[3]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[4]}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[5]}]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[6]}]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[7]}]
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[8]}]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[9]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[10]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[11]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[12]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[13]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[14]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports {hdmi_data[15]}]

# spdif

set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS18} [get_ports spdif]

# i2s

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS18} [get_ports i2s_mclk]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS18} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]

# iic

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS18} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS18} [get_ports iic_sda]
set_property PACKAGE_PIN AA18 [get_ports {iic_mux_scl[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_mux_scl[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[1]}]
set_property PACKAGE_PIN Y16 [get_ports {iic_mux_sda[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_mux_sda[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[1]}]
set_property PACKAGE_PIN AB4 [get_ports {iic_mux_scl[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_mux_scl[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[0]}]
set_property PACKAGE_PIN AB5 [get_ports {iic_mux_sda[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_mux_sda[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[0]}]

# otg

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[1]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[2]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[3]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[4]}]
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[5]}]
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[6]}]
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[7]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[8]}]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[9]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[10]}]

set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[11]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[12]}]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[13]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[14]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[15]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[16]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[17]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[18]}]

set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[19]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[20]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[21]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[22]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[23]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[24]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[25]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[26]}]

set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[27]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[28]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[29]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[30]}]

set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS18} [get_ports {gpio_bd[31]}]

# on-board 100 MHz oscillator IC17 — Fox 767-100-136, 25 ppm
# ZedBoard Bank 13 MRCC pin, LVCMOS33 (3.3 V rail) - error for LVCMOS33 -> set to LVCMOS18

set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS18} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk [get_ports sys_clk]

# Define SPI clock
create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]
create_clock -period 40.000 -name spi1_clk [get_pins -hier */EMIOSPI1SCLKO]







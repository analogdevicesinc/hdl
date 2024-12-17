###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# DAC SPI interface
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports spi_sck]           ; ## FMC-CLK1_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports spi_sdi]           ; ## FMC-LA01_N
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports spi_sdo]           ; ## FMC-LA01_P
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports spi_csb]           ; ## FMC-LA00_P

# DAC GPIO interface
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports dac_ldacb]         ; ## FMC-LA05_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports dac_resetb]        ; ## FMC-LA10_N

# Reconfigure the pins from Bank 34 and Bank 35 to use LVCMOS33 since VADJ must be set to 3.3V

# otg
set_property IOSTANDARD LVCMOS33 [get_ports otg_vbusoc]

# gpio (switches, leds and such)
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[0]]       ; ## BTNC
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[1]]       ; ## BTND
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[2]]       ; ## BTNL
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[3]]       ; ## BTNR
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[4]]       ; ## BTNU

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[11]]      ; ## SW0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[12]]      ; ## SW1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[13]]      ; ## SW2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[14]]      ; ## SW3
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[15]]      ; ## SW4
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[16]]      ; ## SW5
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[17]]      ; ## SW6
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[18]]      ; ## SW7

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[30]]      ; ## XADC-GIO3
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[31]]      ; ## OTG-RESETN

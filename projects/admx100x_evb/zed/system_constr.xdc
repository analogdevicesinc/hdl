###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# SPI interface

set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_sclk]; ## D17   FMC_LA13_P
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_miso]; ## C19   FMC_LA14_N
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_mosi]; ## H19   FMC_LA15_P
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_cs_0]; ## G18   FMC_LA16_P  CS_FPGA
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33}                 [get_ports admx100x_spi_cs_1]; ## G27   FMC_LA25_P  CS_DAC

# reset and GPIO signal

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33}                 [get_ports admx100x_reset];    ##G24   FMC_LA22_P  DAC_RESET
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33}                 [get_ports admx100x_en];       ##C14   FMC_LA10_P
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33}                 [get_ports admx100x_ready];    ##D14   FMC_LA09_P
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33}                 [get_ports admx100x_valid];    ##G12   FMC_LA08_P
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33}                 [get_ports admx100x_cal];      ##C26   FMC_LA27_P
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33}                 [get_ports admx100x_dac_ldac]; ##G21   FMC_LA20_P
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33}                 [get_ports admx100x_trig];     ##H13   FMC_LA07_P
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33}                 [get_ports admx100x_ot];       ##H16   FMC_LA11_P

# syncronization
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33}                 [get_ports admx100x_sync_mode]; ##H22  FMC_LA19_P  SYNC_MODE

# set IOSTANDARD according to VADJ 3.3V

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]       ; ## BTNU

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {IOSTANDARD LVCMOS33} [get_ports gpio_bd[31]]      ; ## OTG-RESETN
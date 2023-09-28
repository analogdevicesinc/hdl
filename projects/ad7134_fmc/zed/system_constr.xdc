###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad713x SPI configuration interface

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sdi]       ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sdo]       ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_sclk]      ; ## FMC_LPC_LA01_P_CC
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_cs[0]]     ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports ad713x_spi_cs[1]]     ; ## FMC_LPC_LA05_N

# ad713x data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ad713x_dclk]          ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad713x_din[0]]        ; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad713x_din[1]]        ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad713x_din[2]]        ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad713x_din[3]]        ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports ad713x_din[4]]        ; ## FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports ad713x_din[5]]        ; ## FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports ad713x_din[6]]        ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports ad713x_din[7]]        ; ## FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad713x_odr]           ; ## FMC_LPC_LA00_P_CC

# ad713x GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports ad713x_resetn[0]]     ; ## FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports ad713x_resetn[1]]     ; ## FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports ad713x_pdn[0]]        ; ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports ad713x_pdn[1]]        ; ## FMC_LPC_LA07_N
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad713x_mode[0]]       ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports ad713x_mode[1]]       ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[0]]       ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[1]]       ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[2]]       ; ## FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[3]]       ; ## FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[4]]       ; ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[5]]       ; ## FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[6]]       ; ## FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports ad713x_gpio[7]]       ; ## FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports ad713x_dclkio[0]]     ; ## FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports ad713x_dclkio[1]]     ; ## FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad713x_pinbspi]       ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports ad713x_dclkmode]      ; ## FMC_LPC_LA14_N

# ad713x reference clock (not used by default)

set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad713x_sdpclk]        ; ## FMC_LPC_LA01_N_CC

###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4134 SPI configuration interface
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports ad4134_spi_sdi]       ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports ad4134_spi_sdo]       ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad4134_spi_sclk]      ; ## FMC_LPC_LA01_P_CC
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports ad4134_spi_cs]        ; ## FMC_LPC_LA05_P

# ad4134 data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports ad4134_dclk]          ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad4134_din[0]]        ; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad4134_din[1]]        ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ad4134_din[2]]        ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ad4134_din[3]]        ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad4134_odr]           ; ## FMC_LPC_LA00_P_CC

# ad4134 GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports ad4134_resetn]        ; ## FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports ad4134_pdn]           ; ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports ad4134_mode]          ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio0]         ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio1]         ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio2]         ; ## FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio3]         ; ## FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio4]         ; ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio5]         ; ## FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio6]         ; ## FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports ad4134_gpio7]         ; ## FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad4134_pinbspi]       ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports ad4134_dclkio]        ; ## FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports ad4134_dclk_mode]     ; ## FMC_LPC_LA14_N

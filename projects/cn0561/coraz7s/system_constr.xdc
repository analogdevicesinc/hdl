###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports iic_sda]

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sdi]     ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sdo]     ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_sclk]    ; ## FMC_LPC_LA01_P_CC
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports cn0561_spi_cs]      ; ## FMC_LPC_LA05_P

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports cn0561_dclk]        ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports cn0561_din[0]]      ; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports cn0561_din[1]]      ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports cn0561_din[2]]      ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports cn0561_din[3]]      ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports cn0561_odr]         ; ## FMC_LPC_LA00_P_CC

set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports cn0561_pdn]         ; ## FMC_LPC_LA07_P

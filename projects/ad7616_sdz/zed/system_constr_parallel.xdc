###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad7616

set_property -dict {PACKAGE_PIN R19     IOSTANDARD LVCMOS25} [get_ports adc_db[0] ]         ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN M21     IOSTANDARD LVCMOS25} [get_ports adc_db[1] ]         ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN R20     IOSTANDARD LVCMOS25} [get_ports adc_db[2] ]         ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN N22     IOSTANDARD LVCMOS25} [get_ports adc_db[3] ]         ; ## FMC_LPC_LA03_P

set_property -dict {PACKAGE_PIN K18     IOSTANDARD LVCMOS25} [get_ports adc_db[4] ]         ; ## FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN P18     IOSTANDARD LVCMOS25} [get_ports adc_db[5] ]         ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN L22     IOSTANDARD LVCMOS25} [get_ports adc_db[6] ]         ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN M20     IOSTANDARD LVCMOS25} [get_ports adc_db[7] ]         ; ## FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN J18     IOSTANDARD LVCMOS25} [get_ports adc_db[8] ]         ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN P17     IOSTANDARD LVCMOS25} [get_ports adc_db[9] ]         ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN L21     IOSTANDARD LVCMOS25} [get_ports adc_db[10]]         ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVCMOS25} [get_ports adc_db[11]]         ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N20     IOSTANDARD LVCMOS25} [get_ports adc_db[12]]         ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN L19     IOSTANDARD LVCMOS25} [get_ports adc_db[13]]         ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN L18     IOSTANDARD LVCMOS25} [get_ports adc_db[14]]         ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN N19     IOSTANDARD LVCMOS25} [get_ports adc_db[15]]         ; ## FMC_LPC_LA01_CC_P

set_property -dict {PACKAGE_PIN P22     IOSTANDARD LVCMOS25} [get_ports adc_rd_n]           ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN R21     IOSTANDARD LVCMOS25} [get_ports adc_wr_n]           ; ## FMC_LPC_LA09_N

# control lines

set_property -dict {PACKAGE_PIN A18     IOSTANDARD LVCMOS25} [get_ports adc_cnvst]          ; ## FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN E20     IOSTANDARD LVCMOS25} [get_ports adc_chsel[0]]       ; ## FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN E18     IOSTANDARD LVCMOS25} [get_ports adc_chsel[1]]       ; ## FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN D22     IOSTANDARD LVCMOS25} [get_ports adc_chsel[2]]       ; ## FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN E19     IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[0]]   ; ## FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN F18     IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[1]]   ; ## FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN T19     IOSTANDARD LVCMOS25} [get_ports adc_busy]           ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN E21     IOSTANDARD LVCMOS25} [get_ports adc_seq_en]         ; ## FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN F19     IOSTANDARD LVCMOS25} [get_ports adc_reset_n]        ; ## FMC_LPC_LA22_N
set_property -dict {PACKAGE_PIN M22     IOSTANDARD LVCMOS25} [get_ports adc_cs_n]           ; ## FMC_LPC_LA04_N

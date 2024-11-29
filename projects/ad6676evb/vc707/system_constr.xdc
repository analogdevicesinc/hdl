###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad6676

set_property  -dict {PACKAGE_PIN  A10}  [get_ports rx_ref_clk_p]                                   ; ## D04  FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9 }  [get_ports rx_ref_clk_n]                                   ; ## D05  FMC1_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  D8 }  [get_ports rx_data_p[0]]                                   ; ## C06  FMC1_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  D7 }  [get_ports rx_data_n[0]]                                   ; ## C07  FMC1_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  C6 }  [get_ports rx_data_p[1]]                                   ; ## A02  FMC1_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  C5 }  [get_ports rx_data_n[1]]                                   ; ## A03  FMC1_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  J40   IOSTANDARD LVDS} [get_ports rx_sync_p]                     ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41   IOSTANDARD LVDS} [get_ports rx_sync_n]                     ; ## D09  FMC1_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  K39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G06  FMC1_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  K40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G07  FMC1_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  L41  IOSTANDARD LVCMOS18} [get_ports spi_csn]                    ; ## D12  FMC1_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  H41  IOSTANDARD LVCMOS18} [get_ports spi_clk]                    ; ## H11  FMC1_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  H40  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                   ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  M41  IOSTANDARD LVCMOS18} [get_ports spi_miso]                   ; ## D11  FMC1_HPC_LA05_P

set_property  -dict {PACKAGE_PIN  J42  IOSTANDARD LVCMOS18} [get_ports adc_oen]                    ; ## C11  FMC1_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  M37  IOSTANDARD LVCMOS18} [get_ports adc_sela]                   ; ## G12  FMC1_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  M38  IOSTANDARD LVCMOS18} [get_ports adc_selb]                   ; ## G13  FMC1_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  G41  IOSTANDARD LVCMOS18} [get_ports adc_s0]                     ; ## H13  FMC1_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  G42  IOSTANDARD LVCMOS18} [get_ports adc_s1]                     ; ## H14  FMC1_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  K42  IOSTANDARD LVCMOS18} [get_ports adc_resetb]                 ; ## C10  FMC1_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  P41  IOSTANDARD LVCMOS18} [get_ports adc_agc1]                   ; ## H07  FMC1_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  N41  IOSTANDARD LVCMOS18} [get_ports adc_agc2]                   ; ## H08  FMC1_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  M42  IOSTANDARD LVCMOS18} [get_ports adc_agc3]                   ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42  IOSTANDARD LVCMOS18} [get_ports adc_agc4]                   ; ## G10  FMC1_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period   5.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  10.00 [get_pins i_system_wrapper/system_i/util_ad6676_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]

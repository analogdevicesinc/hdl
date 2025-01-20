###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# daq3

set_property  -dict {PACKAGE_PIN  AK38} [get_ports tx_ref_clk_p]                                        ; ## D04  FMCP_HSPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AK39} [get_ports tx_ref_clk_n]                                        ; ## D05  FMCP_HSPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AM38} [get_ports rx_ref_clk_p]                                        ; ## B20  FMCP_HSPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AM39} [get_ports rx_ref_clk_n]                                        ; ## B21  FMCP_HSPC_GBTCLK1_M2C_N

set_property  -dict {PACKAGE_PIN  AL30 IOSTANDARD LVDS} [get_ports rx_sync_p]                           ; ## D08  FMCP_HSPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AL31 IOSTANDARD LVDS} [get_ports rx_sync_n]                           ; ## D09  FMCP_HSPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AT39 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]  ; ## G09  FMCP_HSPC_LA03_P
set_property  -dict {PACKAGE_PIN  AT40 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]  ; ## G10  FMCP_HSPC_LA03_N
set_property  -dict {PACKAGE_PIN  AJ32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]    ; ## H07  FMCP_HSPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]    ; ## H08  FMCP_HSPC_LA02_N
set_property  -dict {PACKAGE_PIN  AR37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]  ; ## H10  FMCP_HSPC_LA04_P
set_property  -dict {PACKAGE_PIN  AT37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]  ; ## H11  FMCP_HSPC_LA04_N

set_property  -dict {PACKAGE_PIN  AP38 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                     ; ## D11  FMCP_HSPC_LA05_P
set_property  -dict {PACKAGE_PIN  AP35 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                     ; ## C14  FMCP_HSPC_LA10_P
set_property  -dict {PACKAGE_PIN  AK33 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                     ; ## D15  FMCP_HSPC_LA09_N
set_property  -dict {PACKAGE_PIN  AR38 IOSTANDARD LVCMOS18} [get_ports spi_clk]                         ; ## D12  FMCP_HSPC_LA05_N
set_property  -dict {PACKAGE_PIN  AJ33 IOSTANDARD LVCMOS18} [get_ports spi_sdio]                        ; ## D14  FMCP_HSPC_LA09_P
set_property  -dict {PACKAGE_PIN  AT36 IOSTANDARD LVCMOS18} [get_ports spi_dir]                         ; ## C11  FMCP_HSPC_LA06_N

set_property  -dict {PACKAGE_PIN  AJ35 IOSTANDARD LVDS} [get_ports sysref_p]                            ; ## D17  FMCP_HSPC_LA13_P
set_property  -dict {PACKAGE_PIN  AJ36 IOSTANDARD LVDS} [get_ports sysref_n]                            ; ## D18  FMCP_HSPC_LA13_N
set_property  -dict {PACKAGE_PIN  AH34 IOSTANDARD LVCMOS18} [get_ports dac_txen]                        ; ## G16  FMCP_HSPC_LA12_N
set_property  -dict {PACKAGE_PIN  AT35 IOSTANDARD LVCMOS18} [get_ports adc_pd]                          ; ## C10  FMCP_HSPC_LA06_P

set_property  -dict {PACKAGE_PIN  AK29 IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                  ; ## G12  FMCP_HSPC_LA08_P
set_property  -dict {PACKAGE_PIN  AK30 IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                  ; ## G13  FMCP_HSPC_LA08_N
set_property  -dict {PACKAGE_PIN  AH33 IOSTANDARD LVCMOS18} [get_ports dac_irq]                         ; ## G15  FMCP_HSPC_LA12_P
set_property  -dict {PACKAGE_PIN  AJ30 IOSTANDARD LVCMOS18} [get_ports adc_fda]                         ; ## H16  FMCP_HSPC_LA11_P
set_property  -dict {PACKAGE_PIN  AJ31 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                         ; ## H17  FMCP_HSPC_LA11_N

set_property  -dict {PACKAGE_PIN  AP36 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]       ; ## H13  FMCP_HSPC_LA07_P
set_property  -dict {PACKAGE_PIN  AP37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]       ; ## H14  FMCP_HSPC_LA07_N

set_property  -dict {PACKAGE_PIN  AJ45} [get_ports rx_data_p[0]]                                        ; ## A10  FMCP_HSPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AJ46} [get_ports rx_data_n[0]]                                        ; ## A11  FMCP_HSPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AR45} [get_ports rx_data_p[1]]                                        ; ## C06  FMCP_HSPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AR46} [get_ports rx_data_n[1]]                                        ; ## C07  FMCP_HSPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AL45} [get_ports rx_data_p[2]]                                        ; ## A06  FMCP_HSPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AL46} [get_ports rx_data_n[2]]                                        ; ## A07  FMCP_HSPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AN45} [get_ports rx_data_p[3]]                                        ; ## A02  FMCP_HSPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AN46} [get_ports rx_data_n[3]]                                        ; ## A03  FMCP_HSPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AL40} [get_ports tx_data_p[0]]                                        ; ## A30  FMCP_HSPC_DP3_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  AL41} [get_ports tx_data_n[0]]                                        ; ## A31  FMCP_HSPC_DP3_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  AT42} [get_ports tx_data_p[1]]                                        ; ## C02  FMCP_HSPC_DP0_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  AT43} [get_ports tx_data_n[1]]                                        ; ## C03  FMCP_HSPC_DP0_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  AM42} [get_ports tx_data_p[2]]                                        ; ## A26  FMCP_HSPC_DP2_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  AM43} [get_ports tx_data_n[2]]                                        ; ## A27  FMCP_HSPC_DP2_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  AP42} [get_ports tx_data_p[3]]                                        ; ## A22  FMCP_HSPC_DP1_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  AP43} [get_ports tx_data_n[3]]                                        ; ## A23  FMCP_HSPC_DP1_C2M_N (tx_data_n[2])

## clocks
create_clock -name tx_ref_clk   -period  1.60 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]

# For transceiver output clocks use reference clock divided by two
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

create_generated_clock -name tx_div_clk   [get_pins i_system_wrapper/system_i/util_daq3_xcvr/inst/i_xch_0/i_gtye4_channel/TXOUTCLK]
create_generated_clock -name rx_div_clk   [get_pins i_system_wrapper/system_i/util_daq3_xcvr/inst/i_xch_0/i_gtye4_channel/RXOUTCLK]

# U145 QSFP+ Module
set_property -dict {LOC Y2  } [get_ports {qsfp_rx_p[0]}] ;# MGTYRXP0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC Y1  } [get_ports {qsfp_rx_n[0]}] ;# MGTYRXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V7  } [get_ports {qsfp_tx_p[0]}] ;# MGTYTXP0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V6  } [get_ports {qsfp_tx_n[0]}] ;# MGTYTXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC W4  } [get_ports {qsfp_rx_p[1]}] ;# MGTYRXP1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC W3  } [get_ports {qsfp_rx_n[1]}] ;# MGTYRXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC T7  } [get_ports {qsfp_tx_p[1]}] ;# MGTYTXP1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC T6  } [get_ports {qsfp_tx_n[1]}] ;# MGTYTXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V2  } [get_ports {qsfp_rx_p[2]}] ;# MGTYRXP2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V1  } [get_ports {qsfp_rx_n[2]}] ;# MGTYRXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC P7  } [get_ports {qsfp_tx_p[2]}] ;# MGTYTXP2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC P6  } [get_ports {qsfp_tx_n[2]}] ;# MGTYTXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC U4  } [get_ports {qsfp_rx_p[3]}] ;# MGTYRXP3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC U3  } [get_ports {qsfp_rx_n[3]}] ;# MGTYRXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M7  } [get_ports {qsfp_tx_p[3]}] ;# MGTYTXP3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M6  } [get_ports {qsfp_tx_n[3]}] ;# MGTYTXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12

# REF clock
set_property -dict {LOC W9  } [get_ports qsfp_mgt_refclk_p] ;# MGTREFCLK0P_231 from U38.4
set_property -dict {LOC W8  } [get_ports qsfp_mgt_refclk_n] ;# MGTREFCLK0N_231 from U38.5

set_property -dict {LOC AM21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell]
set_property -dict {LOC BA22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl]
set_property -dict {LOC AL21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_modprsl]
set_property -dict {LOC AP21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_intl]
set_property -dict {LOC AN21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode]

# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name qsfp_mgt_refclk [get_ports qsfp_mgt_refclk_p]

set_false_path -to [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_output_delay 0 [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_false_path -from [get_ports {qsfp_modprsl qsfp_intl}]
set_input_delay 0 [get_ports {qsfp_modprsl qsfp_intl}]

# QSPI flash
set_property -dict {LOC AM19 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[0]}]
set_property -dict {LOC AM18 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[1]}]
set_property -dict {LOC AN20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[2]}]
set_property -dict {LOC AP20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[3]}]
set_property -dict {LOC BF16 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_cs}]

set_false_path -to [get_ports {qspi1_dq[*] qspi1_cs}]
set_output_delay 0 [get_ports {qspi1_dq[*] qspi1_cs}]
set_false_path -from [get_ports {qspi1_dq}]
set_input_delay 0 [get_ports {qspi1_dq}]


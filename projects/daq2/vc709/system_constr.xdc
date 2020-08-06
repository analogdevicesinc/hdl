
# daq2

set_property  -dict {PACKAGE_PIN  J40 IOSTANDARD LVDS} [get_ports rx_sync_p]                                ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41 IOSTANDARD LVDS} [get_ports rx_sync_n]                                ; ## D09  FMC1_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  M42 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]       ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]       ; ## G10  FMC1_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  P41 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]         ; ## H07  FMC1_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  N41 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]         ; ## H08  FMC1_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  H40 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]       ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  H41 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]       ; ## H11  FMC1_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  M41 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                          ; ## D11  FMC1_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  N38 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                          ; ## C14  FMC1_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  P42 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                          ; ## D15  FMC1_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  L41 IOSTANDARD LVCMOS18} [get_ports spi_clk]                              ; ## D12  FMC1_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  R42 IOSTANDARD LVCMOS18} [get_ports spi_sdio]                             ; ## D14  FMC1_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  M38 IOSTANDARD LVCMOS18} [get_ports spi_dir]                              ; ## G13  FMC1_HPC_LA08_N

set_property  -dict {PACKAGE_PIN  M37 IOSTANDARD LVCMOS18} [get_ports clkd_sync]                            ; ## G12  FMC1_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  M39 IOSTANDARD LVCMOS18} [get_ports dac_reset]                            ; ## C15  FMC1_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  P40 IOSTANDARD LVCMOS18} [get_ports dac_txen]                             ; ## G16  FMC1_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  K42 IOSTANDARD LVCMOS18} [get_ports adc_pd]                               ; ## C10  FMC1_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  H39 IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                       ; ## D17  FMC1_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  G39 IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                       ; ## D18  FMC1_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  R40 IOSTANDARD LVCMOS18} [get_ports dac_irq]                              ; ## G15  FMC1_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  F40 IOSTANDARD LVCMOS18} [get_ports adc_fda]                              ; ## H16  FMC1_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  F41 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                              ; ## H17  FMC1_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  G41 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]            ; ## H13  FMC1_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  G42 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]            ; ## H14  FMC1_HPC_LA07_N

set_property  -dict {PACKAGE_PIN  E10} [get_ports rx_ref_clk_p]                                             ; ## B20 FMC1_HPC_GBTCLK1_M2C_P                                 
set_property  -dict {PACKAGE_PIN  E9 } [get_ports rx_ref_clk_n]                                             ; ## B21 FMC1_HPC_GBTCLK1_M2C_N
set_property  -dict {PACKAGE_PIN  G10} [get_ports tx_ref_clk_p]                                             ; ## D04 FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G9 } [get_ports tx_ref_clk_n]                                             ; ## D05 FMC1_HPC_GBTCLK0_M2C_N

set_property  LOC GTHE2_CHANNEL_X1Y32  [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_0/i_gthe2_channel}]
set_property  LOC GTHE2_CHANNEL_X1Y34  [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_1/i_gthe2_channel}]
set_property  LOC GTHE2_CHANNEL_X1Y35  [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_2/i_gthe2_channel}]
set_property  LOC GTHE2_CHANNEL_X1Y33  [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_3/i_gthe2_channel}]

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe2_channel/RXOUTCLK]

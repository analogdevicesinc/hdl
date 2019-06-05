
# daq2

set_property  -dict {PACKAGE_PIN  K6} [get_ports tx_ref_clk_p]                                              ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  K5} [get_ports tx_ref_clk_n]                                              ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  H6} [get_ports rx_ref_clk_p]                                              ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  H5} [get_ports rx_ref_clk_n]                                              ; ## B21  FMC_HPC_GBTCLK1_M2C_N

set_property  -dict {PACKAGE_PIN  G9  IOSTANDARD LVDS} [get_ports rx_sync_p]                                ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  F9  IOSTANDARD LVDS} [get_ports rx_sync_n]                                ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  A13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]       ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  A12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]       ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  K10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]         ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  J10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]         ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  L12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]       ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  K12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]       ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  L13 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                          ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L8  IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                          ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  H9  IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                          ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  K13 IOSTANDARD LVCMOS18} [get_ports spi_clk]                              ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  J9  IOSTANDARD LVCMOS18} [get_ports spi_sdio]                             ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  H8  IOSTANDARD LVCMOS18} [get_ports spi_dir]                              ; ## G13  FMC_HPC_LA08_N

set_property  -dict {PACKAGE_PIN  J8  IOSTANDARD LVCMOS18} [get_ports clkd_sync]                            ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  K8  IOSTANDARD LVCMOS18} [get_ports dac_reset]                            ; ## C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  D10 IOSTANDARD LVCMOS18} [get_ports dac_txen]                             ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  D13 IOSTANDARD LVCMOS18} [get_ports adc_pd]                               ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  D9  IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                       ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  C9  IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                       ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  E10 IOSTANDARD LVCMOS18} [get_ports dac_irq]                              ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  K11 IOSTANDARD LVCMOS18} [get_ports adc_fda]                              ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  J11 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                              ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  F8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]            ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  E8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]            ; ## H14  FMC_HPC_LA07_N

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe3_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/util_daq2_xcvr/inst/i_xch_0/i_gthe3_channel/RXOUTCLK]

# gt pin assignments below are for reference only and are ignored by the tool!

##  set_property  -dict {PACKAGE_PIN  A4} [get_ports rx_data_p[0]] ; ## A10  FMC_HPC_DP3_M2C_P
##  set_property  -dict {PACKAGE_PIN  A3} [get_ports rx_data_n[0]] ; ## A11  FMC_HPC_DP3_M2C_N
##  set_property  -dict {PACKAGE_PIN  E4} [get_ports rx_data_p[1]] ; ## C06  FMC_HPC_DP0_M2C_P
##  set_property  -dict {PACKAGE_PIN  E3} [get_ports rx_data_n[1]] ; ## C07  FMC_HPC_DP0_M2C_N
##  set_property  -dict {PACKAGE_PIN  B2} [get_ports rx_data_p[2]] ; ## A06  FMC_HPC_DP2_M2C_P
##  set_property  -dict {PACKAGE_PIN  B1} [get_ports rx_data_n[2]] ; ## A07  FMC_HPC_DP2_M2C_N
##  set_property  -dict {PACKAGE_PIN  D2} [get_ports rx_data_p[3]] ; ## A02  FMC_HPC_DP1_M2C_P
##  set_property  -dict {PACKAGE_PIN  D1} [get_ports rx_data_n[3]] ; ## A03  FMC_HPC_DP1_M2C_N
##  set_property  -dict {PACKAGE_PIN  B6} [get_ports tx_data_p[0]] ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[0])
##  set_property  -dict {PACKAGE_PIN  B5} [get_ports tx_data_n[0]] ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[0])
##  set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[1]] ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[3])
##  set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[1]] ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[3])
##  set_property  -dict {PACKAGE_PIN  C4} [get_ports tx_data_p[2]] ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[1])
##  set_property  -dict {PACKAGE_PIN  C3} [get_ports tx_data_n[2]] ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[1])
##  set_property  -dict {PACKAGE_PIN  D6} [get_ports tx_data_p[3]] ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[2])
##  set_property  -dict {PACKAGE_PIN  D5} [get_ports tx_data_n[3]] ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[2])

set_property LOC GTHE3_CHANNEL_X0Y19 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_0/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y16 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_1/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y18 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_2/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y17 [get_cells -hierarchical -filter {NAME =~ *util_daq2_xcvr/inst/i_xch_3/i_gthe3_channel}]


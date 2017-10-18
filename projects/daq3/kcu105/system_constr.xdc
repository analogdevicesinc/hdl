
# daq3

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
set_property  -dict {PACKAGE_PIN  C13 IOSTANDARD LVCMOS18} [get_ports spi_dir]                              ; ## C11  FMC_HPC_LA06_N

set_property  -dict {PACKAGE_PIN  D9  IOSTANDARD LVDS} [get_ports sysref_p]                                 ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  C9  IOSTANDARD LVDS} [get_ports sysref_n]                                 ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  D10 IOSTANDARD LVCMOS18} [get_ports dac_txen]                             ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  D13 IOSTANDARD LVCMOS18} [get_ports adc_pd]                               ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  J8  IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                       ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  H8  IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                       ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  E10 IOSTANDARD LVCMOS18} [get_ports dac_irq]                              ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  K11 IOSTANDARD LVCMOS18} [get_ports adc_fda]                              ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  J11 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                              ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  F8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]            ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  E8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]            ; ## H14  FMC_HPC_LA07_N

# clocks

create_clock -name tx_ref_clk   -period  1.60 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  3.20 [get_pins i_system_wrapper/system_i/axi_daq3_xcvr_tx_bufg/BUFG_GT_O[0]]
create_clock -name rx_div_clk   -period  3.20 [get_pins i_system_wrapper/system_i/axi_daq3_xcvr_rx_bufg/BUFG_GT_O[0]]

# reference clocks

set_property LOC GTHE3_COMMON_X0Y4 [get_cells i_ibufds_tx_ref_clk]
set_property LOC GTHE3_COMMON_X0Y4 [get_cells i_ibufds_rx_ref_clk]
set_property BEL GTHE3_COMMON.IBUFDS0_GTE3 [get_cells i_ibufds_tx_ref_clk] ; ## K6/K5 D04/D05 FMC_HPC_GBTCLK0_M2C
set_property BEL GTHE3_COMMON.IBUFDS1_GTE3 [get_cells i_ibufds_rx_ref_clk] ; ## H6/H5 B20/B21 FMC_HPC_GBTCLK1_M2C

# lanes
# device        fmc                         xcvr              location
# --------------------------------------------------------------------------------
# rx_data[1]    C06/C07   FMC_HPC_DP0_M2C   E4/E3 rx_data[0]  GTHE3_CHANNEL_X0Y16 
# rx_data[3]    A02/A03   FMC_HPC_DP1_M2C   D2/D1 rx_data[1]  GTHE3_CHANNEL_X0Y17 
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   B2/B1 rx_data[2]  GTHE3_CHANNEL_X0Y18 
# rx_data[0]    A10/A11   FMC_HPC_DP3_M2C   A4/A3 rx_data[3]  GTHE3_CHANNEL_X0Y19 
# --------------------------------------------------------------------------------
# tx_data[3]    C02/C03   FMC_HPC_DP0_C2M   F6/F5 tx_data[0]  GTHE3_CHANNEL_X0Y16 
# tx_data[2]    A22/A23   FMC_HPC_DP1_C2M   D6/D5 tx_data[1]  GTHE3_CHANNEL_X0Y17 
# tx_data[1]    A26/A27   FMC_HPC_DP2_C2M   C4/C3 tx_data[2]  GTHE3_CHANNEL_X0Y18 
# tx_data[0]    A30/A31   FMC_HPC_DP3_C2M   B6/B5 tx_data[3]  GTHE3_CHANNEL_X0Y19 
# --------------------------------------------------------------------------------


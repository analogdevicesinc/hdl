
# ad9371

set_property  -dict {PACKAGE_PIN  A13  IOSTANDARD LVDS} [get_ports rx_sync_p]                        ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  A12  IOSTANDARD LVDS} [get_ports rx_sync_n]                        ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVDS} [get_ports rx_os_sync_p]                     ; ## G27  FMC_HPC_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  D21  IOSTANDARD LVDS} [get_ports rx_os_sync_n]                     ; ## G28  FMC_HPC_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  K10  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p] ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  J10  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n] ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  A27  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_p]  ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  A28  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_n]  ; ## G37  FMC_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  H9   IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]               ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  J9   IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9371]               ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  F8   IOSTANDARD LVCMOS18} [get_ports spi_clk]                      ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  E8   IOSTANDARD LVCMOS18} [get_ports spi_mosi]                     ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  J8   IOSTANDARD LVCMOS18} [get_ports spi_miso]                     ; ## G12  FMC_HPC_LA08_P

set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]               ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  F20  IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]            ; ## D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  D9   IOSTANDARD LVCMOS18} [get_ports ad9371_tx1_enable]            ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  B10  IOSTANDARD LVCMOS18} [get_ports ad9371_tx2_enable]            ; ## C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  C9   IOSTANDARD LVCMOS18} [get_ports ad9371_rx1_enable]            ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  A10  IOSTANDARD LVCMOS18} [get_ports ad9371_rx2_enable]            ; ## C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18} [get_ports ad9371_test]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L12  IOSTANDARD LVCMOS18} [get_ports ad9371_reset_b]               ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18} [get_ports ad9371_gpint]                 ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  D8   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_00]               ; ## H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  C8   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_01]               ; ## H20  FMC_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  B9   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_02]               ; ## G18  FMC_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  A9   IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_03]               ; ## G19  FMC_HPC_LA16_N
set_property  -dict {PACKAGE_PIN  F23  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_04]               ; ## H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  F24  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_05]               ; ## H26  FMC_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  E22  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_06]               ; ## C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  E23  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_07]               ; ## C23  FMC_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  G24  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_15]               ; ## G24  FMC_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  F25  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_08]               ; ## G25  FMC_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  C21  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_09]               ; ## H22  FMC_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  C22  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_10]               ; ## H23  FMC_HPC_LA19_N
set_property  -dict {PACKAGE_PIN  B24  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_11]               ; ## G21  FMC_HPC_LA20_P
set_property  -dict {PACKAGE_PIN  A24  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_12]               ; ## G22  FMC_HPC_LA20_N
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_14]               ; ## G30  FMC_HPC_LA29_P
set_property  -dict {PACKAGE_PIN  A20  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_13]               ; ## G31  FMC_HPC_LA29_N
set_property  -dict {PACKAGE_PIN  E10  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_17]               ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  D10  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_16]               ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18} [get_ports ad9371_gpio_18]               ; ## D12  FMC_HPC_LA05_N

# clocks

create_clock -name tx_ref_clk     -period  8.00 [get_ports ref_clk0_p]
create_clock -name rx_ref_clk     -period  8.00 [get_ports ref_clk1_p]
create_clock -name tx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_0/i_gthe3_channel/TXOUTCLK]
create_clock -name rx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_0/i_gthe3_channel/RXOUTCLK]
create_clock -name rx_os_div_clk  -period  8.00 [get_pins i_system_wrapper/system_i/util_ad9371_xcvr/inst/i_xch_2/i_gthe3_channel/RXOUTCLK]

# gt pin assignments below are for reference only and are ignored by the tool!

# set_property  -dict {PACKAGE_PIN  T6   } [get_ports ref_clk0_p]                                        ; ## D04  FMC_HPC_GBTCLK0_M2C_P (C 0.1uF)
# set_property  -dict {PACKAGE_PIN  T5   } [get_ports ref_clk0_n]                                        ; ## D05  FMC_HPC_GBTCLK0_M2C_N (C 0.1uF)
# set_property  -dict {PACKAGE_PIN  H6   } [get_ports ref_clk1_p]                                        ; ## B20  FMC_HPC_GBTCLK1_M2C_P (C 0.1uF)
# set_property  -dict {PACKAGE_PIN  H5   } [get_ports ref_clk1_n]                                        ; ## B21  FMC_HPC_GBTCLK1_M2C_N (C 0.1uF)

# set_property  -dict {PACKAGE_PIN  D2   } [get_ports rx_data_p[0]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
# set_property  -dict {PACKAGE_PIN  D1   } [get_ports rx_data_n[0]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
# set_property  -dict {PACKAGE_PIN  B2   } [get_ports rx_data_p[1]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
# set_property  -dict {PACKAGE_PIN  B1   } [get_ports rx_data_n[1]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
# set_property  -dict {PACKAGE_PIN  E4   } [get_ports rx_data_p[2]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
# set_property  -dict {PACKAGE_PIN  E3   } [get_ports rx_data_n[2]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
# set_property  -dict {PACKAGE_PIN  A4   } [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
# set_property  -dict {PACKAGE_PIN  A3   } [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
# set_property  -dict {PACKAGE_PIN  D6   } [get_ports tx_data_p[0]]                                      ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[3])
# set_property  -dict {PACKAGE_PIN  D5   } [get_ports tx_data_n[0]]                                      ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[3])
# set_property  -dict {PACKAGE_PIN  C4   } [get_ports tx_data_p[1]]                                      ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[0])
# set_property  -dict {PACKAGE_PIN  C3   } [get_ports tx_data_n[1]]                                      ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[0])
# set_property  -dict {PACKAGE_PIN  F6   } [get_ports tx_data_p[2]]                                      ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[1])
# set_property  -dict {PACKAGE_PIN  F5   } [get_ports tx_data_n[2]]                                      ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[1])
# set_property  -dict {PACKAGE_PIN  B6   } [get_ports tx_data_p[3]]                                      ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[2])
# set_property  -dict {PACKAGE_PIN  B5   } [get_ports tx_data_n[3]]                                      ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[2])

# set_property LOC GTHE3_COMMON_X0Y2 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_rx_ref_clk}]
set_property LOC GTHE3_COMMON_X0Y4 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_ref_clk1}]
set_property BEL GTHE3_COMMON.IBUFDS1_GTE3 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_ref_clk1}]

set_property LOC GTHE3_CHANNEL_X0Y17 [get_cells -hierarchical -filter {NAME =~ *util_ad9371_xcvr/inst/i_xch_0/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y18 [get_cells -hierarchical -filter {NAME =~ *util_ad9371_xcvr/inst/i_xch_1/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y16 [get_cells -hierarchical -filter {NAME =~ *util_ad9371_xcvr/inst/i_xch_2/i_gthe3_channel}]
set_property LOC GTHE3_CHANNEL_X0Y19 [get_cells -hierarchical -filter {NAME =~ *util_ad9371_xcvr/inst/i_xch_3/i_gthe3_channel}]


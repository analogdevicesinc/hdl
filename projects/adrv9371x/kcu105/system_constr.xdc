
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

create_clock -name ref_clk        -period  8.00 [get_ports ref_clk_p]
create_clock -name tx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/axi_ad9371_tx_clkgen/clk_0]
create_clock -name rx_div_clk     -period  8.00 [get_pins i_system_wrapper/system_i/axi_ad9371_rx_clkgen/clk_0]
create_clock -name rx_os_div_clk  -period  8.00 [get_pins i_system_wrapper/system_i/axi_ad9371_rx_os_clkgen/clk_0]

# reference clocks

set_property LOC GTHE3_COMMON_X0Y4 [get_cells i_ibufds_ref_clk]
set_property BEL GTHE3_COMMON.IBUFDS1_GTE3 [get_cells i_ibufds_ref_clk] ; ## B20/B21 FMC_HPC_GBTCLK1_M2C (H6/H5)

# lanes
# device        fmc                         xcvr              location
# --------------------------------------------------------------------------------
# rx_data[2]    C06/C07   FMC_HPC_DP0_M2C   E4/E3 rx_data[0]  GTHE3_CHANNEL_X0Y16 
# rx_data[0]    A02/A03   FMC_HPC_DP1_M2C   D2/D1 rx_data[1]  GTHE3_CHANNEL_X0Y17 
# rx_data[1]    A06/A07   FMC_HPC_DP2_M2C   B2/B1 rx_data[2]  GTHE3_CHANNEL_X0Y18 
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   A4/A3 rx_data[3]  GTHE3_CHANNEL_X0Y19 
# --------------------------------------------------------------------------------
# tx_data[1]    C02/C03   FMC_HPC_DP0_C2M   F6/F5 tx_data[0]  GTHE3_CHANNEL_X0Y16 
# tx_data[3]    A22/A23   FMC_HPC_DP1_C2M   D6/D5 tx_data[1]  GTHE3_CHANNEL_X0Y17 
# tx_data[0]    A26/A27   FMC_HPC_DP2_C2M   C4/C3 tx_data[2]  GTHE3_CHANNEL_X0Y18 
# tx_data[2]    A30/A31   FMC_HPC_DP3_C2M   B6/B5 tx_data[3]  GTHE3_CHANNEL_X0Y19 
# --------------------------------------------------------------------------------



# ad9379

set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVDS_25} [get_ports rx_os_sync_p]                  ; ## G27  FMC_HPC_LA25_P (Sniffer)
set_property  -dict {PACKAGE_PIN  U29   IOSTANDARD LVDS_25} [get_ports rx_os_sync_n]                  ; ## G28  FMC_HPC_LA25_N (Sniffer)
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_p]       ; ## G06  FMC_HPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_n]       ; ## G07  FMC_HPC_LA00_CC_N       
set_property  -dict {PACKAGE_PIN  T30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_1_p]    ; ## H28  FMC_HPC_LA24_P
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_1_n]    ; ## H29  FMC_HPC_LA24_N
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_out_p]   ; ## D08  FMC_HPC_LA01_CC_P       
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_out_n]   ; ## D09  FMC_HPC_LA01_CC_N              

set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9528]               ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9379]               ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                     ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_miso]                     ; ## G12  FMC_HPC_LA08_P

set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVCMOS25} [get_ports ad9528_reset_b]               ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVCMOS25} [get_ports ad9528_sysref_req]            ; ## D27  FMC_HPC_LA26_N
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports ad9379_tx1_enable]            ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports ad9379_tx2_enable]            ; ## C18  FMC_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports ad9379_rx1_enable]            ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports ad9379_rx2_enable]            ; ## C19  FMC_HPC_LA14_N
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports ad9379_test]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVCMOS25} [get_ports ad9379_reset_b]               ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVCMOS25} [get_ports ad9379_gpint]                 ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_00]               ; ## H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_01]               ; ## H20  FMC_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_02]               ; ## G18  FMC_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_03]               ; ## G19  FMC_HPC_LA16_N
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_04]               ; ## H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_05]               ; ## H26  FMC_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_06]               ; ## C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_07]               ; ## C23  FMC_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_08]               ; ## G25  FMC_HPC_LA22_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_09]               ; ## H22  FMC_HPC_LA19_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_10]               ; ## H23  FMC_HPC_LA19_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  U25   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_11]               ; ## G21  FMC_HPC_LA20_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  V26   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_12]               ; ## G22  FMC_HPC_LA20_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  R26   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_13]               ; ## G31  FMC_HPC_LA29_N     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  R25   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_14]               ; ## G30  FMC_HPC_LA29_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_15]               ; ## G24  FMC_HPC_LA22_P     (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  U27   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_16]               ; ## G03  FMC_HPC_CLK1_M2C_N (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  U26   IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_17]               ; ## G02  FMC_HPC_CLK1_M2C_P (LVDS Pairs?)
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports ad9379_gpio_18]               ; ## D12  FMC_HPC_LA05_N

# clocks

create_clock -name ref_clk     	  -period  4.00 [get_ports ref_clk_p]
create_clock -name tx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/axi_ad9379_tx_clkgen/clk_0]
create_clock -name rx_div_clk     -period  4.00 [get_pins i_system_wrapper/system_i/axi_ad9379_rx_clkgen/clk_0]
create_clock -name rx_os_div_clk  -period  4.00 [get_pins i_system_wrapper/system_i/axi_ad9379_rx_os_clkgen/clk_0]

# reference clocks

set_property  -dict {PACKAGE_PIN  AA8 } [get_ports ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_ad9379_xcvr_0*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_ad9379_xcvr_0*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_ad9379_xcvr_1*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_ad9379_xcvr_1*gt1*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[2]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[0]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[1]    A06/A07   FMC_HPC_DP2_M2C   AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------
# tx_data[2]    C02/C03   FMC_HPC_DP0_C2M   AK10/AK9  tx_data[0]  GTXE2_CHANNEL_X0Y0
# tx_data[0]    A22/A23   FMC_HPC_DP1_C2M   AK6/AK5   tx_data[1]  GTXE2_CHANNEL_X0Y1
# tx_data[3]    A26/A27   FMC_HPC_DP2_C2M   AJ4/AJ3   tx_data[2]  GTXE2_CHANNEL_X0Y2
# tx_data[1]    A30/A31   FMC_HPC_DP3_C2M   AK2/AK1   tx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------


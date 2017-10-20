
# fmcomms11

set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## H07  FMC_HPC_LA02_P          
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## H08  FMC_HPC_LA02_N          
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## G09  FMC_HPC_LA03_P          
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## G10  FMC_HPC_LA03_N          

set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports usr_clk_p]      ; ## G06  FMC_HPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports usr_clk_n]      ; ## G07  FMC_HPC_LA00_CC_N       
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_p]       ; ## H10  FMC_HPC_LA04_P          
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sysref_n]       ; ## H11  FMC_HPC_LA04_N          

set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9625]               ; ## C11  FMC_HPC_LA06_N          
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9162]               ; ## G12  FMC_HPC_LA08_P          
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9508]               ; ## H14  FMC_HPC_LA07_N          
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_csn_adl5240]              ; ## C10  FMC_HPC_LA06_P          
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_csn_adf4355]              ; ## D12  FMC_HPC_LA05_N          
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_csn_hmc1119]              ; ## D11  FMC_HPC_LA05_P          
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## C14  FMC_HPC_LA10_P          
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## C15  FMC_HPC_LA10_N          
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## H13  FMC_HPC_LA07_P          

set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports adf4355_muxout]               ; ## D14  FMC_HPC_LA09_P             
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports ad9162_txen]                  ; ## G13  FMC_HPC_LA08_N             
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports ad9625_irq]                   ; ## D15  FMC_HPC_LA09_N             
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports ad9162_irq]                   ; ## H16  FMC_HPC_LA11_P             

# clocks

create_clock -name tx_ref_clk   -period  6.40 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  6.40 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  3.20 [get_pins i_system_wrapper/system_i/axi_fmcomms11_xcvr_tx_bufg/U0/BUFG_O]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/axi_fmcomms11_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports tx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports tx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AA8 } [get_ports rx_ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P (IBUFDS_GTE2_X0Y2)
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports rx_ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N (IBUFDS_GTE2_X0Y2)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms11_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[0]    C06/C07 FMC_HPC_DP0_M2C     AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[1]    A02/A03 FMC_HPC_DP1_M2C     AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[2]    A06/A07 FMC_HPC_DP2_M2C     AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[3]    A10/A11 FMC_HPC_DP3_M2C     AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# rx_data[5]    A14/A15 FMC_HPC_DP4_M2C     AH6/AH5   rx_data[4]  GTXE2_CHANNEL_X0Y4
# rx_data[7]    A18/A19 FMC_HPC_DP5_M2C     AG4/AG3   rx_data[5]  GTXE2_CHANNEL_X0Y5
# rx_data[6]    B16/B17 FMC_HPC_DP6_M2C     AF6/AF5   rx_data[6]  GTXE2_CHANNEL_X0Y6
# rx_data[4]    B12/B13 FMC_HPC_DP7_M2C     AD6/AD5   rx_data[7]  GTXE2_CHANNEL_X0Y7
# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
# tx_data[0]    C02/C03 FMC_HPC_DP0_C2M     AK10/AK9  tx_data[0]  GTXE2_CHANNEL_X0Y0
# tx_data[1]    A22/A23 FMC_HPC_DP1_C2M     AK6/AK5   tx_data[1]  GTXE2_CHANNEL_X0Y1
# tx_data[2]    A26/A27 FMC_HPC_DP2_C2M     AJ4/AJ3   tx_data[2]  GTXE2_CHANNEL_X0Y2
# tx_data[3]    A30/A31 FMC_HPC_DP3_C2M     AK2/AK1   tx_data[3]  GTXE2_CHANNEL_X0Y3
# tx_data[5]    A34/A35 FMC_HPC_DP4_C2M     AH2/AH1   tx_data[4]  GTXE2_CHANNEL_X0Y4
# tx_data[7]    A38/A39 FMC_HPC_DP5_C2M     AF2/AF1   tx_data[5]  GTXE2_CHANNEL_X0Y5
# tx_data[6]    B36/B37 FMC_HPC_DP6_C2M     AE4/AE3   tx_data[6]  GTXE2_CHANNEL_X0Y6
# tx_data[4]    B32/B33 FMC_HPC_DP7_C2M     AD2/AD1   tx_data[7]  GTXE2_CHANNEL_X0Y7
# -----------------------------------------------------------------------------------


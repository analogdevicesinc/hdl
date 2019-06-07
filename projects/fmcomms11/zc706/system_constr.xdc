
# fmcomms11

set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[0]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[0]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[1]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[1]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AH6 } [get_ports rx_data_p[4]]                                      ; ## A14  FMC_HPC_DP4_M2C_P
set_property  -dict {PACKAGE_PIN  AH5 } [get_ports rx_data_n[4]]                                      ; ## A15  FMC_HPC_DP4_M2C_N
set_property  -dict {PACKAGE_PIN  AG4 } [get_ports rx_data_p[5]]                                      ; ## A18  FMC_HPC_DP5_M2C_P
set_property  -dict {PACKAGE_PIN  AG3 } [get_ports rx_data_n[5]]                                      ; ## A19  FMC_HPC_DP5_M2C_N
set_property  -dict {PACKAGE_PIN  AF6 } [get_ports rx_data_p[6]]                                      ; ## B16  FMC_HPC_DP6_M2C_P
set_property  -dict {PACKAGE_PIN  AF5 } [get_ports rx_data_n[6]]                                      ; ## B17  FMC_HPC_DP6_M2C_N
set_property  -dict {PACKAGE_PIN  AD6 } [get_ports rx_data_p[7]]                                      ; ## B12  FMC_HPC_DP7_M2C_P
set_property  -dict {PACKAGE_PIN  AD5 } [get_ports rx_data_n[7]]                                      ; ## B13  FMC_HPC_DP7_M2C_N
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## H08  FMC_HPC_LA02_N

set_property  -dict {PACKAGE_PIN  AD10} [get_ports trx_ref_clk_p]                                     ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports trx_ref_clk_n]                                     ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AK10} [get_ports tx_data_p[0]]                                      ; ## C02  FMC_HPC_DP0_C2M_P
set_property  -dict {PACKAGE_PIN  AK9 } [get_ports tx_data_n[0]]                                      ; ## C03  FMC_HPC_DP0_C2M_N
set_property  -dict {PACKAGE_PIN  AK6 } [get_ports tx_data_p[1]]                                      ; ## A22  FMC_HPC_DP1_C2M_P
set_property  -dict {PACKAGE_PIN  AK5 } [get_ports tx_data_n[1]]                                      ; ## A23  FMC_HPC_DP1_C2M_N
set_property  -dict {PACKAGE_PIN  AJ4 } [get_ports tx_data_p[2]]                                      ; ## A26  FMC_HPC_DP2_C2M_P
set_property  -dict {PACKAGE_PIN  AJ3 } [get_ports tx_data_n[2]]                                      ; ## A27  FMC_HPC_DP2_C2M_N
set_property  -dict {PACKAGE_PIN  AK2 } [get_ports tx_data_p[3]]                                      ; ## A30  FMC_HPC_DP3_C2M_P
set_property  -dict {PACKAGE_PIN  AK1 } [get_ports tx_data_n[3]]                                      ; ## A31  FMC_HPC_DP3_C2M_N
set_property  -dict {PACKAGE_PIN  AH2 } [get_ports tx_data_p[4]]                                      ; ## A34  FMC_HPC_DP4_C2M_P
set_property  -dict {PACKAGE_PIN  AH1 } [get_ports tx_data_n[4]]                                      ; ## A35  FMC_HPC_DP4_C2M_N
set_property  -dict {PACKAGE_PIN  AF2 } [get_ports tx_data_p[5]]                                      ; ## A38  FMC_HPC_DP5_C2M_P
set_property  -dict {PACKAGE_PIN  AF1 } [get_ports tx_data_n[5]]                                      ; ## A39  FMC_HPC_DP5_C2M_N
set_property  -dict {PACKAGE_PIN  AE4 } [get_ports tx_data_p[6]]                                      ; ## B36  FMC_HPC_DP6_C2M_P
set_property  -dict {PACKAGE_PIN  AE3 } [get_ports tx_data_n[6]]                                      ; ## B37  FMC_HPC_DP6_C2M_N
set_property  -dict {PACKAGE_PIN  AD2 } [get_ports tx_data_p[7]]                                      ; ## B32  FMC_HPC_DP7_C2M_P
set_property  -dict {PACKAGE_PIN  AD1 } [get_ports tx_data_n[7]]                                      ; ## B33  FMC_HPC_DP7_C2M_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports usr_clk_p]      ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports usr_clk_n]      ; ## B21  FMC_HPC_GBTCLK1_M2C_N

set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9625]               ; ## C11  FMC_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9162]               ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports spi_csn_ad9508]               ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_csn_adl5240]              ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports spi_csn_adf4355]              ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports spi_csn_hmc1119]              ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## H13  FMC_HPC_LA07_P

set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports adf4355_muxout]               ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports ad9162_txen]                  ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports ad9625_irq]                   ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports ad9162_irq]                   ; ## H16  FMC_HPC_LA11_P

# clocks

create_clock -name rx_ref_clk   -period  8 [get_ports trx_ref_clk_p]
create_clock -name tx_div_clk   -period  4 [get_pins i_system_wrapper/system_i/util_fmcomms11_xcvr/inst/i_xch_0/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  8 [get_pins i_system_wrapper/system_i/util_fmcomms11_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]

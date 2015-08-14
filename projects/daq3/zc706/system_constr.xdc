
set_property  -dict {PACKAGE_PIN  AA8 } [get_ports rx_ref_clk_p]                                      ; ## B20  FMC_HPC_GBTCLK1_M2C_P     
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports rx_ref_clk_n]                                      ; ## B21  FMC_HPC_GBTCLK1_M2C_N     
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[0]]                                      ; ## A10  FMC_HPC_DP3_M2C_P         
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[0]]                                      ; ## A11  FMC_HPC_DP3_M2C_N         
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[1]]                                      ; ## C06  FMC_HPC_DP0_M2C_P         
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[1]]                                      ; ## C07  FMC_HPC_DP0_M2C_N         
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P         
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N         
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[3]]                                      ; ## A02  FMC_HPC_DP1_M2C_P         
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[3]]                                      ; ## A03  FMC_HPC_DP1_M2C_N         
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P         
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N         
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G09  FMC_HPC_LA03_P            
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G10  FMC_HPC_LA03_N            

set_property  -dict {PACKAGE_PIN  AD10} [get_ports tx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P     
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports tx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N     
set_property  -dict {PACKAGE_PIN  AK2 } [get_ports tx_data_p[0]]                                      ; ## A30  FMC_HPC_DP3_C2M_P  (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  AK1 } [get_ports tx_data_n[0]]                                      ; ## A31  FMC_HPC_DP3_C2M_N  (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  AK10} [get_ports tx_data_p[1]]                                      ; ## C02  FMC_HPC_DP0_C2M_P  (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  AK9 } [get_ports tx_data_n[1]]                                      ; ## C03  FMC_HPC_DP0_C2M_N  (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  AJ4 } [get_ports tx_data_p[2]]                                      ; ## A26  FMC_HPC_DP2_C2M_P  (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  AJ3 } [get_ports tx_data_n[2]]                                      ; ## A27  FMC_HPC_DP2_C2M_N  (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  AK6 } [get_ports tx_data_p[3]]                                      ; ## A22  FMC_HPC_DP1_C2M_P  (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  AK5 } [get_ports tx_data_n[3]]                                      ; ## A23  FMC_HPC_DP1_C2M_N  (tx_data_n[2])
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P            
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N            
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_p]    ; ## H10  FMC_HPC_LA04_P            
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_n]    ; ## H11  FMC_HPC_LA04_N            

set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P            
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                  ; ## C14  FMC_HPC_LA10_P            
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                  ; ## D15  FMC_HPC_LA09_N            
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D12  FMC_HPC_LA05_N            
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D14  FMC_HPC_LA09_P            
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## C11  FMC_HPC_LA06_N            

set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVDS_25}  [get_ports sysref_p]                     ; ## D17  FMC_HPC_LA13_P            
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVDS_25}  [get_ports sysref_n]                     ; ## D18  FMC_HPC_LA13_N            
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports dac_txen]                     ; ## G16  FMC_HPC_LA12_N            
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports adc_pd]                       ; ## C10  FMC_HPC_LA06_P            

set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports clkd_status[0]]               ; ## G12  FMC_HPC_LA08_P            
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports clkd_status[1]]               ; ## G13  FMC_HPC_LA08_N            
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports dac_irq]                      ; ## G15  FMC_HPC_LA12_P            
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P            
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N            

set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_p]         ; ## H13  FMC_HPC_LA07_P            
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_n]         ; ## H14  FMC_HPC_LA07_N            

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq3_gt/inst/g_lane_1[0].i_gt_channel_1/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq3_gt/inst/g_lane_1[0].i_gt_channel_1/i_gtxe2_channel/RXOUTCLK]


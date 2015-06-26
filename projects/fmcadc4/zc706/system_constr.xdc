
# fmcadc4

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P      
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N      
set_property  -dict {PACKAGE_PIN  AH6 } [get_ports rx_data_p[0]]                                      ; ## A14  FMC_HPC_DP4_M2C_P          
set_property  -dict {PACKAGE_PIN  AH5 } [get_ports rx_data_n[0]]                                      ; ## A15  FMC_HPC_DP4_M2C_N          
set_property  -dict {PACKAGE_PIN  AG4 } [get_ports rx_data_p[1]]                                      ; ## A18  FMC_HPC_DP5_M2C_P          
set_property  -dict {PACKAGE_PIN  AG3 } [get_ports rx_data_n[1]]                                      ; ## A19  FMC_HPC_DP5_M2C_N          
set_property  -dict {PACKAGE_PIN  AF6 } [get_ports rx_data_p[2]]                                      ; ## B16  FMC_HPC_DP6_M2C_P          
set_property  -dict {PACKAGE_PIN  AF5 } [get_ports rx_data_n[2]]                                      ; ## B17  FMC_HPC_DP6_M2C_N          
set_property  -dict {PACKAGE_PIN  AD6 } [get_ports rx_data_p[3]]                                      ; ## B12  FMC_HPC_DP7_M2C_P          
set_property  -dict {PACKAGE_PIN  AD5 } [get_ports rx_data_n[3]]                                      ; ## B13  FMC_HPC_DP7_M2C_N          
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[4]]                                      ; ## A10  FMC_HPC_DP3_M2C_P          
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[4]]                                      ; ## A11  FMC_HPC_DP3_M2C_N          
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[5]]                                      ; ## C06  FMC_HPC_DP0_M2C_P          
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[5]]                                      ; ## C07  FMC_HPC_DP0_M2C_N          
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[6]]                                      ; ## A06  FMC_HPC_DP2_M2C_P          
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[6]]                                      ; ## A07  FMC_HPC_DP2_M2C_N          
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[7]]                                      ; ## A02  FMC_HPC_DP1_M2C_P          
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[7]]                                      ; ## A03  FMC_HPC_DP1_M2C_N          
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVDS_25} [get_ports rx_sync_0_p]                   ; ## G15  FMC_HPC_LA12_P             
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVDS_25} [get_ports rx_sync_0_n]                   ; ## G16  FMC_HPC_LA12_N             
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_1_p]                   ; ## H10  FMC_HPC_LA04_P             
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_1_n]                   ; ## H11  FMC_HPC_LA04_N             
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## D08  FMC_HPC_LA01_CC_P          
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## D09  FMC_HPC_LA01_CC_N          

set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports ad9528_csn]                   ; ## G13  FMC_HPC_LA08_N             
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports ada4961_1a_csn]               ; ## G09  FMC_HPC_LA03_P             
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports ada4961_1b_csn]               ; ## G10  FMC_HPC_LA03_N             
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports ad9680_1_csn]                 ; ## H13  FMC_HPC_LA07_P             
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports ada4961_2a_csn]               ; ## C10  FMC_HPC_LA06_P             
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports ada4961_2b_csn]               ; ## C11  FMC_HPC_LA06_N             
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports ad9680_2_csn]                 ; ## H14  FMC_HPC_LA07_N             
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D18  FMC_HPC_LA13_N             
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D17  FMC_HPC_LA13_P             

set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports ad9528_rstn]                  ; ## D15  FMC_HPC_LA09_N             
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports ad9528_status]                ; ## D14  FMC_HPC_LA09_P             
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports ad9680_1_fda]                 ; ## C14  FMC_HPC_LA10_P             
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports ad9680_1_fdb]                 ; ## C15  FMC_HPC_LA10_N             
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports ad9680_2_fda]                 ; ## H16  FMC_HPC_LA11_P             
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports ad9680_2_fdb]                 ; ## H17  FMC_HPC_LA11_N             

# clocks

create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_fmcadc4_gt/inst/g_lane_1[0].i_gt_channel_1/i_gtxe2_channel/RXOUTCLK]


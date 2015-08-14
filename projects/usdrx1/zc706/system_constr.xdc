
# constraints
# ultrasound 

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p]                              ; ## D04  FMC_HPC_GBTCLK0_M2C_P      
set_property  -dict {PACKAGE_PIN  AD9}  [get_ports rx_ref_clk_n]                              ; ## D05  FMC_HPC_GBTCLK0_M2C_N      
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[0]]                              ; ## C06  FMC_HPC_DP0_M2C_P          
set_property  -dict {PACKAGE_PIN  AH9}  [get_ports rx_data_n[0]]                              ; ## C07  FMC_HPC_DP0_M2C_N          
set_property  -dict {PACKAGE_PIN  AJ8}  [get_ports rx_data_p[1]]                              ; ## A02  FMC_HPC_DP1_M2C_P          
set_property  -dict {PACKAGE_PIN  AJ7}  [get_ports rx_data_n[1]]                              ; ## A03  FMC_HPC_DP1_M2C_N          
set_property  -dict {PACKAGE_PIN  AG8}  [get_ports rx_data_p[2]]                              ; ## A06  FMC_HPC_DP2_M2C_P          
set_property  -dict {PACKAGE_PIN  AG7}  [get_ports rx_data_n[2]]                              ; ## A07  FMC_HPC_DP2_M2C_N          
set_property  -dict {PACKAGE_PIN  AE8}  [get_ports rx_data_p[3]]                              ; ## A10  FMC_HPC_DP3_M2C_P          
set_property  -dict {PACKAGE_PIN  AE7}  [get_ports rx_data_n[3]]                              ; ## A11  FMC_HPC_DP3_M2C_N          
set_property  -dict {PACKAGE_PIN  AH6}  [get_ports rx_data_p[4]]                              ; ## A14  FMC_HPC_DP4_M2C_P          
set_property  -dict {PACKAGE_PIN  AH5}  [get_ports rx_data_n[4]]                              ; ## A15  FMC_HPC_DP4_M2C_N          
set_property  -dict {PACKAGE_PIN  AG4}  [get_ports rx_data_p[5]]                              ; ## A18  FMC_HPC_DP5_M2C_P          
set_property  -dict {PACKAGE_PIN  AG3}  [get_ports rx_data_n[5]]                              ; ## A19  FMC_HPC_DP5_M2C_N          
set_property  -dict {PACKAGE_PIN  AF6}  [get_ports rx_data_p[6]]                              ; ## B16  FMC_HPC_DP6_M2C_P          
set_property  -dict {PACKAGE_PIN  AF5}  [get_ports rx_data_n[6]]                              ; ## B17  FMC_HPC_DP6_M2C_N          
set_property  -dict {PACKAGE_PIN  AD6}  [get_ports rx_data_p[7]]                              ; ## B12  FMC_HPC_DP7_M2C_P          
set_property  -dict {PACKAGE_PIN  AD5}  [get_ports rx_data_n[7]]                              ; ## B13  FMC_HPC_DP7_M2C_N          
set_property  -dict {PACKAGE_PIN  P25   IOSTANDARD LVDS_25} [get_ports rx_sysref_p]           ; ## D23  FMC_HPC_LA23_P             
set_property  -dict {PACKAGE_PIN  P26   IOSTANDARD LVDS_25} [get_ports rx_sysref_n]           ; ## D24  FMC_HPC_LA23_N             
set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVDS_25} [get_ports rx_sync_p]             ; ## D26  FMC_HPC_LA26_P             
set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVDS_25} [get_ports rx_sync_n]             ; ## D27  FMC_HPC_LA26_N             
#set_property  -dict {PACKAGE_PIN  V23   IOSTANDARD LVDS_25} [get_ports afe_mlo_p]             ; ## D20  FMC_HPC_LA17_CC_P          
#set_property  -dict {PACKAGE_PIN  W24   IOSTANDARD LVDS_25} [get_ports afe_mlo_n]             ; ## D21  FMC_HPC_LA17_CC_N          
set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVDS_25} [get_ports afe_rst_p]             ; ## G27  FMC_HPC_LA25_P             
set_property  -dict {PACKAGE_PIN  U29   IOSTANDARD LVDS_25} [get_ports afe_rst_n]             ; ## G28  FMC_HPC_LA25_N             
set_property  -dict {PACKAGE_PIN  T30   IOSTANDARD LVDS_25} [get_ports afe_trig_p]            ; ## H28  FMC_HPC_LA24_P             
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVDS_25} [get_ports afe_trig_n]            ; ## H29  FMC_HPC_LA24_N             

set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_clk]     ; ## C14  FMC_HPC_LA10_P             
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_mlo]     ; ## C15  FMC_HPC_LA10_N             
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_rst]     ; ## C18  FMC_HPC_LA14_P             
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_sync]    ; ## C19  FMC_HPC_LA14_N             
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_sysref]  ; ## C22  FMC_HPC_LA18_CC_P          
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25} [get_ports spi_fout_enb_trig]    ; ## C23  FMC_HPC_LA18_CC_N          
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_fout_clk]         ; ## C10  FMC_HPC_LA06_P             
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports spi_fout_sdio]        ; ## C11  FMC_HPC_LA06_N             

set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_afe_csn[0]]       ; ## D11  FMC_HPC_LA05_P             
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_afe_csn[1]]       ; ## D12  FMC_HPC_LA05_N             
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_afe_csn[2]]       ; ## D14  FMC_HPC_LA09_P             
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_afe_csn[3]]       ; ## D15  FMC_HPC_LA09_N             
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVCMOS25} [get_ports spi_afe_clk]          ; ## D08  FMC_HPC_LA01_CC_P          
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVCMOS25} [get_ports spi_afe_sdio]         ; ## D09  FMC_HPC_LA01_CC_N          

set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports spi_clk_csn]          ; ## G10  FMC_HPC_LA03_N             
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports spi_clk_clk]          ; ## G13  FMC_HPC_LA08_N             
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_clk_sdio]         ; ## G12  FMC_HPC_LA08_P             

set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports afe_pdn]              ; ## D17  FMC_HPC_LA13_P             
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports afe_stby]             ; ## D18  FMC_HPC_LA13_N             
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports clk_resetn]           ; ## G16  FMC_HPC_LA12_N             
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports clk_syncn]            ; ## G15  FMC_HPC_LA12_P             
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports clk_status]           ; ## G18  FMC_HPC_LA16_P             

set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports amp_disbn]            ; ## G19  FMC_HPC_LA16_N             
set_property  -dict {PACKAGE_PIN  U25   IOSTANDARD LVCMOS25} [get_ports prc_sck]              ; ## G21  FMC_HPC_LA20_P             
set_property  -dict {PACKAGE_PIN  V26   IOSTANDARD LVCMOS25} [get_ports prc_cnv]              ; ## G22  FMC_HPC_LA20_N             
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25} [get_ports prc_sdo_i]            ; ## G24  FMC_HPC_LA22_P             
set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25} [get_ports prc_sdo_q]            ; ## G25  FMC_HPC_LA22_N             

set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports dac_sleep]            ; ## G09  FMC_HPC_LA03_P             
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVCMOS25} [get_ports dac_data[0]]          ; ## H26  FMC_HPC_LA21_N             
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVCMOS25} [get_ports dac_data[1]]          ; ## H25  FMC_HPC_LA21_P             
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVCMOS25} [get_ports dac_data[2]]          ; ## H23  FMC_HPC_LA19_N             
set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVCMOS25} [get_ports dac_data[3]]          ; ## H22  FMC_HPC_LA19_P             
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVCMOS25} [get_ports dac_data[4]]          ; ## H20  FMC_HPC_LA15_N             
set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVCMOS25} [get_ports dac_data[5]]          ; ## H19  FMC_HPC_LA15_P             
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports dac_data[6]]          ; ## H17  FMC_HPC_LA11_N             
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports dac_data[7]]          ; ## H16  FMC_HPC_LA11_P             
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports dac_data[8]]          ; ## H14  FMC_HPC_LA07_N             
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports dac_data[9]]          ; ## H13  FMC_HPC_LA07_P             
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVCMOS25} [get_ports dac_data[10]]         ; ## H11  FMC_HPC_LA04_N             
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVCMOS25} [get_ports dac_data[11]]         ; ## H10  FMC_HPC_LA04_P             
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVCMOS25} [get_ports dac_data[12]]         ; ## H08  FMC_HPC_LA02_N             
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports dac_data[13]]         ; ## H07  FMC_HPC_LA02_P             

# clocks

create_clock -name rx_ref_clk   -period 12.50 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period 12.50 [get_nets i_system_wrapper/system_i/axi_usdrx1_gt_rx_clk]

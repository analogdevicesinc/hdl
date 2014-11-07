
# constraints

# ad9361 master 

set_property  -dict {PACKAGE_PIN  B19   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports ref_clk_p]             ; ## D20  FMC1_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  B20   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports ref_clk_n]             ; ## D21  FMC1_LPC_LA17_CC_N

set_property  -dict {PACKAGE_PIN  K19   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_0_p]         ; ## G06  FMC1_LPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  K20   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_0_n]         ; ## G07  FMC1_LPC_LA00_CC_N       
set_property  -dict {PACKAGE_PIN  N19   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_0_p]       ; ## D08  FMC1_LPC_LA01_CC_P       
set_property  -dict {PACKAGE_PIN  N20   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_0_n]       ; ## D09  FMC1_LPC_LA01_CC_N       
set_property  -dict {PACKAGE_PIN  L21   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[0]]     ; ## H07  FMC1_LPC_LA02_P          
set_property  -dict {PACKAGE_PIN  L22   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[0]]     ; ## H08  FMC1_LPC_LA02_N          
set_property  -dict {PACKAGE_PIN  J20   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[1]]     ; ## G09  FMC1_LPC_LA03_P          
set_property  -dict {PACKAGE_PIN  K21   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[1]]     ; ## G10  FMC1_LPC_LA03_N          
set_property  -dict {PACKAGE_PIN  M21   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[2]]     ; ## H10  FMC1_LPC_LA04_P          
set_property  -dict {PACKAGE_PIN  M22   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[2]]     ; ## H11  FMC1_LPC_LA04_N          
set_property  -dict {PACKAGE_PIN  N17   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[3]]     ; ## D11  FMC1_LPC_LA05_P          
set_property  -dict {PACKAGE_PIN  N18   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[3]]     ; ## D12  FMC1_LPC_LA05_N          
set_property  -dict {PACKAGE_PIN  J18   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[4]]     ; ## C10  FMC1_LPC_LA06_P          
set_property  -dict {PACKAGE_PIN  K18   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[4]]     ; ## C11  FMC1_LPC_LA06_N          
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[5]]     ; ## H13  FMC1_LPC_LA07_P          
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[5]]     ; ## H14  FMC1_LPC_LA07_N          
set_property  -dict {PACKAGE_PIN  J21   IOSTANDARD LVDS_25}   [get_ports tx_clk_out_0_p]                        ; ## G12  FMC1_LPC_LA08_P          
set_property  -dict {PACKAGE_PIN  J22   IOSTANDARD LVDS_25}   [get_ports tx_clk_out_0_n]                        ; ## G13  FMC1_LPC_LA08_N          
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVDS_25}   [get_ports tx_frame_out_0_p]                      ; ## D14  FMC1_LPC_LA09_P          
set_property  -dict {PACKAGE_PIN  M16   IOSTANDARD LVDS_25}   [get_ports tx_frame_out_0_n]                      ; ## D15  FMC1_LPC_LA09_N          
set_property  -dict {PACKAGE_PIN  L17   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[0]]                    ; ## C14  FMC1_LPC_LA10_P 
set_property  -dict {PACKAGE_PIN  M17   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[0]]                    ; ## C15  FMC1_LPC_LA10_N 
set_property  -dict {PACKAGE_PIN  R20   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[1]]                    ; ## H16  FMC1_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  R21   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[1]]                    ; ## H17  FMC1_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  N22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[2]]                    ; ## G15  FMC1_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  P22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[2]]                    ; ## G16  FMC1_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[3]]                    ; ## D17  FMC1_LPC_LA13_P 
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[3]]                    ; ## D18  FMC1_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  J16   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[4]]                    ; ## C18  FMC1_LPC_LA14_P         
set_property  -dict {PACKAGE_PIN  J17   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[4]]                    ; ## C19  FMC1_LPC_LA14_N         
set_property  -dict {PACKAGE_PIN  P20   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[5]]                    ; ## H19  FMC1_LPC_LA15_P         
set_property  -dict {PACKAGE_PIN  P21   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[5]]                    ; ## H20  FMC1_LPC_LA15_N 

set_property  -dict {PACKAGE_PIN  E19   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[0]]                      ; ## H22  FMC1_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  E20   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[1]]                      ; ## H23  FMC1_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  G20   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[2]]                      ; ## G21  FMC1_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  G21   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[3]]                      ; ## G22  FMC1_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[4]]                      ; ## H25  FMC1_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[5]]                      ; ## H26  FMC1_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[6]]                      ; ## G24  FMC1_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  F17   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[7]]                      ; ## G25  FMC1_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  G15   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[0]]                         ; ## D23  FMC1_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  G16   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[1]]                         ; ## D24  FMC1_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  A21   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[2]]                         ; ## H28  FMC1_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  A22   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[3]]                         ; ## H29  FMC1_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  C15   IOSTANDARD LVCMOS25}  [get_ports gpio_en_agc_0]                         ; ## G27  FMC1_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  D20   IOSTANDARD LVCMOS25}  [get_ports mcs_sync]                              ; ## C22  FMC1_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  C20   IOSTANDARD LVCMOS25}  [get_ports gpio_resetb_0]                         ; ## C23  FMC1_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS25}  [get_ports gpio_enable_0]                         ; ## G18  FMC1_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  P15   IOSTANDARD LVCMOS25}  [get_ports gpio_txnrx_0]                          ; ## G19  FMC1_LPC_LA16_N   
set_property  -dict {PACKAGE_PIN  C17   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_1_0]                        ; ## C26  FMC1_LPC_LA27_P            
set_property  -dict {PACKAGE_PIN  C18   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_2_0]                        ; ## C27  FMC1_LPC_LA27_N            
set_property  -dict {PACKAGE_PIN  F18   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_1_0]                        ; ## D26  FMC1_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  E18   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_2_0]                        ; ## D27  FMC1_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  D22   IOSTANDARD LVCMOS25}  [get_ports gpio_ad5355_rfen]                      ; ## H31  FMC1_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  B21   IOSTANDARD LVCMOS25}  [get_ports gpio_ad5355_lock]                      ; ## H37  FMC1_LPC_LA32_P

# spi

set_property  -dict {PACKAGE_PIN  B16   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad9361_0]         ; ## G30  FMC1_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  B17   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad9361_1]         ; ## G31  FMC1_LPC_LA29_N          
set_property  -dict {PACKAGE_PIN  E21   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad5355]           ; ## H34  FMC1_LPC_LA30_P
set_property  -dict {PACKAGE_PIN  D21   IOSTANDARD LVCMOS25}  [get_ports spi_clk]                               ; ## H35  FMC1_LPC_LA30_N          
set_property  -dict {PACKAGE_PIN  A17   IOSTANDARD LVCMOS25}  [get_ports spi_miso]                              ; ## G34  FMC1_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  A16   IOSTANDARD LVCMOS25}  [get_ports spi_mosi]                              ; ## G33  FMC1_LPC_LA31_P

# ad9361 slave    

set_property  -dict {PACKAGE_PIN  Y19   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_1_p]         ; ## G6   FMC2_LPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  AA19  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_1_n]         ; ## G7   FMC2_LPC_LA00_CC_N      
set_property  -dict {PACKAGE_PIN  W16   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_1_p]       ; ## D8   FMC2_LPC_LA01_CC_P      
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_1_n]       ; ## D9   FMC2_LPC_LA01_CC_N      
set_property  -dict {PACKAGE_PIN  V14   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[0]]     ; ## H7   FMC2_LPC_LA02_P          
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[0]]     ; ## H8   FMC2_LPC_LA02_N          
set_property  -dict {PACKAGE_PIN  AA16  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[1]]     ; ## G9   FMC2_LPC_LA03_P          
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[1]]     ; ## G10  FMC2_LPC_LA03_N          
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[2]]     ; ## H10  FMC2_LPC_LA04_P          
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[2]]     ; ## H11  FMC2_LPC_LA04_N          
set_property  -dict {PACKAGE_PIN  AB19  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[3]]     ; ## D11  FMC2_LPC_LA05_P          
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[3]]     ; ## D12  FMC2_LPC_LA05_N          
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[4]]     ; ## C10  FMC2_LPC_LA06_P          
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[4]]     ; ## C11  FMC2_LPC_LA06_N          
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[5]]     ; ## H13  FMC2_LPC_LA07_P          
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[5]]     ; ## H14  FMC2_LPC_LA07_N          
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_1_p]                        ; ## G12  FMC2_LPC_LA08_P          
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_1_n]                        ; ## G13  FMC2_LPC_LA08_N          
set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVDS_25}   [get_ports tx_frame_out_1_p]                      ; ## D14  FMC2_LPC_LA09_P          
set_property  -dict {PACKAGE_PIN  U16   IOSTANDARD LVDS_25}   [get_ports tx_frame_out_1_n]                      ; ## D15  FMC2_LPC_LA09_N          
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[0]]                    ; ## C14  FMC2_LPC_LA10_P 
set_property  -dict {PACKAGE_PIN  Y21   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[0]]                    ; ## C15  FMC2_LPC_LA10_N 
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[1]]                    ; ## H16  FMC2_LPC_LA11_P 
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[1]]                    ; ## H17  FMC2_LPC_LA11_N 
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[2]]                    ; ## G15  FMC2_LPC_LA12_P 
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[2]]                    ; ## G16  FMC2_LPC_LA12_N 
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[3]]                    ; ## D17  FMC2_LPC_LA13_P 
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[3]]                    ; ## D18  FMC2_LPC_LA13_N 
set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[4]]                    ; ## C18  FMC2_LPC_LA14_P          
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[4]]                    ; ## C19  FMC2_LPC_LA14_N          
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[5]]                    ; ## H19  FMC2_LPC_LA15_P          
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[5]]                    ; ## H20  FMC2_LPC_LA15_N  

set_property  -dict {PACKAGE_PIN  R6    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[0]]                      ; ## H22  FMC2_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  T6    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[1]]                      ; ## H23  FMC2_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  T4    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[2]]                      ; ## G21  FMC2_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[3]]                      ; ## G22  FMC2_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  V5    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[4]]                      ; ## H25  FMC2_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  V4    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[5]]                      ; ## H26  FMC2_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[6]]                      ; ## G24  FMC2_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[7]]                      ; ## G25  FMC2_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[0]]                         ; ## D23  FMC2_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  W12   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[1]]                         ; ## D24  FMC2_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  U6    IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[2]]                         ; ## H28  FMC2_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[3]]                         ; ## H29  FMC2_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS25}  [get_ports gpio_en_agc_1]                         ; ## G27  FMC2_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  AA11  IOSTANDARD LVCMOS25}  [get_ports gpio_resetb_1]                         ; ## G30  FMC2_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS25}  [get_ports gpio_enable_1]                         ; ## G18  FMC2_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS25}  [get_ports gpio_txnrx_1]                          ; ## G19  FMC2_LPC_LA16_N        
set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_3_1]                        ; ## C26  FMC2_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  AB1   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_4_1]                        ; ## C27  FMC2_LPC_LA27_N
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_3_1]                        ; ## D26  FMC2_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_4_1]                        ; ## D27  FMC2_LPC_LA26_N

# clocks

create_clock -name rx_0_clk       -period   5.00 [get_ports rx_clk_in_0_p]
create_clock -name rx_1_clk       -period   5.00 [get_ports rx_clk_in_1_p]
create_clock -name ad9361_clk     -period   5.00 [get_pins i_system_wrapper/system_i/axi_ad9361_0/clk]

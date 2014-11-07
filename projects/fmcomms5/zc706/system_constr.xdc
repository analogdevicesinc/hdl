
# constraints

# ad9361 master 

set_property  -dict {PACKAGE_PIN  V23   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports ref_clk_p]             ; ## D20  FMC_HPC_LA17_CC_P           
set_property  -dict {PACKAGE_PIN  W24   IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports ref_clk_n]             ; ## D21  FMC_HPC_LA17_CC_N           

set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_0_p]         ; ## G06  FMC_HPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_0_n]         ; ## G07  FMC_HPC_LA00_CC_N       
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_0_p]       ; ## D08  FMC_HPC_LA01_CC_P       
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_0_n]       ; ## D09  FMC_HPC_LA01_CC_N       
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[0]]     ; ## H07  FMC_HPC_LA02_P          
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[0]]     ; ## H08  FMC_HPC_LA02_N          
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[1]]     ; ## G09  FMC_HPC_LA03_P          
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[1]]     ; ## G10  FMC_HPC_LA03_N          
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[2]]     ; ## H10  FMC_HPC_LA04_P          
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[2]]     ; ## H11  FMC_HPC_LA04_N          
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[3]]     ; ## D11  FMC_HPC_LA05_P          
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[3]]     ; ## D12  FMC_HPC_LA05_N          
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[4]]     ; ## C10  FMC_HPC_LA06_P          
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[4]]     ; ## C11  FMC_HPC_LA06_N          
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_p[5]]     ; ## H13  FMC_HPC_LA07_P          
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_0_n[5]]     ; ## H14  FMC_HPC_LA07_N          
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_0_p]                        ; ## G12  FMC_HPC_LA08_P          
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_0_n]                        ; ## G13  FMC_HPC_LA08_N          
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVDS_25}   [get_ports tx_frame_out_0_p]                      ; ## D14  FMC_HPC_LA09_P          
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVDS_25}   [get_ports tx_frame_out_0_n]                      ; ## D15  FMC_HPC_LA09_N          
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[0]]                    ; ## C14  FMC_HPC_LA10_P          
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[0]]                    ; ## C15  FMC_HPC_LA10_N          
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[1]]                    ; ## H16  FMC_HPC_LA11_P          
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[1]]                    ; ## H17  FMC_HPC_LA11_N          
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[2]]                    ; ## G15  FMC_HPC_LA12_P          
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[2]]                    ; ## G16  FMC_HPC_LA12_N          
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[3]]                    ; ## D17  FMC_HPC_LA13_P          
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[3]]                    ; ## D18  FMC_HPC_LA13_N          
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[4]]                    ; ## C18  FMC_HPC_LA14_P          
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[4]]                    ; ## C19  FMC_HPC_LA14_N          
set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_p[5]]                    ; ## H19  FMC_HPC_LA15_P          
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVDS_25}   [get_ports tx_data_out_0_n[5]]                    ; ## H20  FMC_HPC_LA15_N          

set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[0]]                      ; ## H22  FMC_HPC_LA19_P            
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[1]]                      ; ## H23  FMC_HPC_LA19_N            
set_property  -dict {PACKAGE_PIN  U25   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[2]]                      ; ## G21  FMC_HPC_LA20_P            
set_property  -dict {PACKAGE_PIN  V26   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[3]]                      ; ## G22  FMC_HPC_LA20_N            
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[4]]                      ; ## H25  FMC_HPC_LA21_P            
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[5]]                      ; ## H26  FMC_HPC_LA21_N            
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[6]]                      ; ## G24  FMC_HPC_LA22_P            
set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25}  [get_ports gpio_status_0[7]]                      ; ## G25  FMC_HPC_LA22_N            
set_property  -dict {PACKAGE_PIN  P25   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[0]]                         ; ## D23  FMC_HPC_LA23_P            
set_property  -dict {PACKAGE_PIN  P26   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[1]]                         ; ## D24  FMC_HPC_LA23_N            
set_property  -dict {PACKAGE_PIN  T30   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[2]]                         ; ## H28  FMC_HPC_LA24_P            
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_0[3]]                         ; ## H29  FMC_HPC_LA24_N            
set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVCMOS25}  [get_ports gpio_en_agc_0]                         ; ## G27  FMC_HPC_LA25_P            
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25}  [get_ports mcs_sync]                              ; ## C22  FMC_HPC_LA18_CC_P         
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25}  [get_ports gpio_resetb_0]                         ; ## C23  FMC_HPC_LA18_CC_N         
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25}  [get_ports gpio_enable_0]                         ; ## G18  FMC_HPC_LA16_P            
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25}  [get_ports gpio_txnrx_0]                          ; ## G19  FMC_HPC_LA16_N            
set_property  -dict {PACKAGE_PIN  V28   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_1_0]                        ; ## C26  FMC_HPC_LA27_P            
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS25}  [get_ports gpio_debug_2_0]                        ; ## C27  FMC_HPC_LA27_N            
set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_1_0]                        ; ## D26  FMC_HPC_LA26_P            
set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_2_0]                        ; ## D27  FMC_HPC_LA26_N            
set_property  -dict {PACKAGE_PIN  P30   IOSTANDARD LVCMOS25}  [get_ports gpio_ad5355_rfen]                      ; ## H31  FMC_HPC_LA28_P            
set_property  -dict {PACKAGE_PIN  P21   IOSTANDARD LVCMOS25}  [get_ports gpio_ad5355_lock]                      ; ## H37  FMC_HPC_LA32_P            

# spi

set_property  -dict {PACKAGE_PIN  R25   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad9361_0]         ; ## G30  FMC_HPC_LA29_P              
set_property  -dict {PACKAGE_PIN  R26   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad9361_1]         ; ## G31  FMC_HPC_LA29_N              
set_property  -dict {PACKAGE_PIN  P23   IOSTANDARD LVCMOS25   PULLTYPE PULLUP} [get_ports spi_ad5355]           ; ## H34  FMC_HPC_LA30_P              
set_property  -dict {PACKAGE_PIN  P24   IOSTANDARD LVCMOS25}  [get_ports spi_clk]                               ; ## H35  FMC_HPC_LA30_N              
set_property  -dict {PACKAGE_PIN  N29   IOSTANDARD LVCMOS25}  [get_ports spi_mosi]                              ; ## G33  FMC_HPC_LA31_P              
set_property  -dict {PACKAGE_PIN  P29   IOSTANDARD LVCMOS25}  [get_ports spi_miso]                              ; ## G34  FMC_HPC_LA31_N              

# ad9361 slave    

set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_1_p]         ; ## G06  FMC_LPC_LA00_CC_P          
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_clk_in_1_n]         ; ## G07  FMC_LPC_LA00_CC_N          
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_1_p]       ; ## D08  FMC_LPC_LA01_CC_P          
set_property  -dict {PACKAGE_PIN  AG15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_frame_in_1_n]       ; ## D09  FMC_LPC_LA01_CC_N          
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[0]]     ; ## H07  FMC_LPC_LA02_P             
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[0]]     ; ## H08  FMC_LPC_LA02_N             
set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[1]]     ; ## G09  FMC_LPC_LA03_P             
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[1]]     ; ## G10  FMC_LPC_LA03_N             
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[2]]     ; ## H10  FMC_LPC_LA04_P             
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[2]]     ; ## H11  FMC_LPC_LA04_N             
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[3]]     ; ## D11  FMC_LPC_LA05_P             
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[3]]     ; ## D12  FMC_LPC_LA05_N             
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[4]]     ; ## C10  FMC_LPC_LA06_P             
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[4]]     ; ## C11  FMC_LPC_LA06_N             
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_p[5]]     ; ## H13  FMC_LPC_LA07_P             
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVDS_25    DIFF_TERM TRUE} [get_ports rx_data_in_1_n[5]]     ; ## H14  FMC_LPC_LA07_N             
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_1_p]                        ; ## G12  FMC_LPC_LA08_P             
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVDS_25}   [get_ports tx_clk_out_1_n]                        ; ## G13  FMC_LPC_LA08_N             
set_property  -dict {PACKAGE_PIN  AH14  IOSTANDARD LVDS_25}   [get_ports tx_frame_out_1_p]                      ; ## D14  FMC_LPC_LA09_P             
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVDS_25}   [get_ports tx_frame_out_1_n]                      ; ## D15  FMC_LPC_LA09_N             
set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[0]]                    ; ## C14  FMC_LPC_LA10_P             
set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[0]]                    ; ## C15  FMC_LPC_LA10_N             
set_property  -dict {PACKAGE_PIN  AJ16  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[1]]                    ; ## H16  FMC_LPC_LA11_P             
set_property  -dict {PACKAGE_PIN  AK16  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[1]]                    ; ## H17  FMC_LPC_LA11_N             
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[2]]                    ; ## G15  FMC_LPC_LA12_P             
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[2]]                    ; ## G16  FMC_LPC_LA12_N             
set_property  -dict {PACKAGE_PIN  AH17  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[3]]                    ; ## D17  FMC_LPC_LA13_P             
set_property  -dict {PACKAGE_PIN  AH16  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[3]]                    ; ## D18  FMC_LPC_LA13_N             
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[4]]                    ; ## C18  FMC_LPC_LA14_P             
set_property  -dict {PACKAGE_PIN  AF17  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[4]]                    ; ## C19  FMC_LPC_LA14_N             
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_p[5]]                    ; ## H19  FMC_LPC_LA15_P             
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVDS_25}   [get_ports tx_data_out_1_n[5]]                    ; ## H20  FMC_LPC_LA15_N             

set_property  -dict {PACKAGE_PIN  AH26  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[0]]                      ; ## H22  FMC_LPC_LA19_P             
set_property  -dict {PACKAGE_PIN  AH27  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[1]]                      ; ## H23  FMC_LPC_LA19_N             
set_property  -dict {PACKAGE_PIN  AG26  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[2]]                      ; ## G21  FMC_LPC_LA20_P             
set_property  -dict {PACKAGE_PIN  AG27  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[3]]                      ; ## G22  FMC_LPC_LA20_N             
set_property  -dict {PACKAGE_PIN  AH28  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[4]]                      ; ## H25  FMC_LPC_LA21_P             
set_property  -dict {PACKAGE_PIN  AH29  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[5]]                      ; ## H26  FMC_LPC_LA21_N             
set_property  -dict {PACKAGE_PIN  AK27  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[6]]                      ; ## G24  FMC_LPC_LA22_P             
set_property  -dict {PACKAGE_PIN  AK28  IOSTANDARD LVCMOS25}  [get_ports gpio_status_1[7]]                      ; ## G25  FMC_LPC_LA22_N             
set_property  -dict {PACKAGE_PIN  AJ26  IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[0]]                         ; ## D23  FMC_LPC_LA23_P             
set_property  -dict {PACKAGE_PIN  AK26  IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[1]]                         ; ## D24  FMC_LPC_LA23_N             
set_property  -dict {PACKAGE_PIN  AF30  IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[2]]                         ; ## H28  FMC_LPC_LA24_P             
set_property  -dict {PACKAGE_PIN  AG30  IOSTANDARD LVCMOS25}  [get_ports gpio_ctl_1[3]]                         ; ## H29  FMC_LPC_LA24_N             
set_property  -dict {PACKAGE_PIN  AF29  IOSTANDARD LVCMOS25}  [get_ports gpio_en_agc_1]                         ; ## G27  FMC_LPC_LA25_P             
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS25}  [get_ports gpio_resetb_1]                         ; ## G30  FMC_LPC_29_P         
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25}  [get_ports gpio_enable_1]                         ; ## G18  FMC_LPC_LA16_P             
set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS25}  [get_ports gpio_txnrx_1]                          ; ## G19  FMC_LPC_LA16_N                    
set_property  -dict {PACKAGE_PIN  AJ28  IOSTANDARD LVCMOS25}  [get_ports gpio_debug_3_1]                        ; ## C26  FMC_LPC_LA27_P             
set_property  -dict {PACKAGE_PIN  AJ29  IOSTANDARD LVCMOS25}  [get_ports gpio_debug_4_1]                        ; ## C27  FMC_LPC_LA27_N             
set_property  -dict {PACKAGE_PIN  AJ30  IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_3_1]                        ; ## D26  FMC_LPC_LA26_P             
set_property  -dict {PACKAGE_PIN  AK30  IOSTANDARD LVCMOS25}  [get_ports gpio_calsw_4_1]                        ; ## D27  FMC_LPC_LA26_N             

# clocks

create_clock -name rx_0_clk       -period   4.00 [get_ports rx_clk_in_0_p]
create_clock -name rx_1_clk       -period   4.00 [get_ports rx_clk_in_1_p]
create_clock -name ad9361_clk     -period   4.00 [get_pins i_system_wrapper/system_i/axi_ad9361_0/clk]

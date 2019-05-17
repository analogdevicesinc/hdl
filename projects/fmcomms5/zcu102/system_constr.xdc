
# constraints

# ad9361 master

set_property  -dict {PACKAGE_PIN  P11   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports ref_clk_p]             ; ## D20  FMC_HPC0_LA17_CC_P
set_property  -dict {PACKAGE_PIN  N11   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports ref_clk_n]             ; ## D21  FMC_HPC0_LA17_CC_N

set_property  -dict {PACKAGE_PIN  Y4    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_0_p]         ; ## G06  FMC_HPC0_LA00_CC_P
set_property  -dict {PACKAGE_PIN  Y3    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_0_n]         ; ## G07  FMC_HPC0_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_0_p]       ; ## D08  FMC_HPC0_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AC4   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_0_n]       ; ## D09  FMC_HPC0_LA01_CC_N
set_property  -dict {PACKAGE_PIN  V2    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[0]]     ; ## H07  FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  V1    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[0]]     ; ## H08  FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  Y2    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[1]]     ; ## G09  FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN  Y1    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[1]]     ; ## G10  FMC_HPC0_LA03_N
set_property  -dict {PACKAGE_PIN  AA2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[2]]     ; ## H10  FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[2]]     ; ## H11  FMC_HPC0_LA04_N
set_property  -dict {PACKAGE_PIN  AB3   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[3]]     ; ## D11  FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AC3   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[3]]     ; ## D12  FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN  AC2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[4]]     ; ## C10  FMC_HPC0_LA06_P
set_property  -dict {PACKAGE_PIN  AC1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[4]]     ; ## C11  FMC_HPC0_LA06_N
set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_p[5]]     ; ## H13  FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_0_n[5]]     ; ## H14  FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  V4    IOSTANDARD LVDS}   [get_ports tx_clk_out_0_p]                                ; ## G12  FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  V3    IOSTANDARD LVDS}   [get_ports tx_clk_out_0_n]                                ; ## G13  FMC_HPC0_LA08_N
set_property  -dict {PACKAGE_PIN  W2    IOSTANDARD LVDS}   [get_ports tx_frame_out_0_p]                              ; ## D14  FMC_HPC0_LA09_P
set_property  -dict {PACKAGE_PIN  W1    IOSTANDARD LVDS}   [get_ports tx_frame_out_0_n]                              ; ## D15  FMC_HPC0_LA09_N
set_property  -dict {PACKAGE_PIN  W5    IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[0]]                            ; ## C14  FMC_HPC0_LA10_P
set_property  -dict {PACKAGE_PIN  W4    IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[0]]                            ; ## C15  FMC_HPC0_LA10_N
set_property  -dict {PACKAGE_PIN  AB6   IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[1]]                            ; ## H16  FMC_HPC0_LA11_P
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[1]]                            ; ## H17  FMC_HPC0_LA11_N
set_property  -dict {PACKAGE_PIN  W7    IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[2]]                            ; ## G15  FMC_HPC0_LA12_P
set_property  -dict {PACKAGE_PIN  W6    IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[2]]                            ; ## G16  FMC_HPC0_LA12_N
set_property  -dict {PACKAGE_PIN  AB8   IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[3]]                            ; ## D17  FMC_HPC0_LA13_P
set_property  -dict {PACKAGE_PIN  AC8   IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[3]]                            ; ## D18  FMC_HPC0_LA13_N
set_property  -dict {PACKAGE_PIN  AC7   IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[4]]                            ; ## C18  FMC_HPC0_LA14_P
set_property  -dict {PACKAGE_PIN  AC6   IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[4]]                            ; ## C19  FMC_HPC0_LA14_N
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVDS}   [get_ports tx_data_out_0_p[5]]                            ; ## H19  FMC_HPC0_LA15_P
set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD LVDS}   [get_ports tx_data_out_0_n[5]]                            ; ## H20  FMC_HPC0_LA15_N

set_property  -dict {PACKAGE_PIN  L13   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[0]]                           ; ## H22  FMC_HPC0_LA19_P
set_property  -dict {PACKAGE_PIN  K13   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[1]]                           ; ## H23  FMC_HPC0_LA19_N
set_property  -dict {PACKAGE_PIN  N13   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[2]]                           ; ## G21  FMC_HPC0_LA20_P
set_property  -dict {PACKAGE_PIN  M13   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[3]]                           ; ## G22  FMC_HPC0_LA20_N
set_property  -dict {PACKAGE_PIN  P12   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[4]]                           ; ## H25  FMC_HPC0_LA21_P
set_property  -dict {PACKAGE_PIN  N12   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[5]]                           ; ## H26  FMC_HPC0_LA21_N
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[6]]                           ; ## G24  FMC_HPC0_LA22_P
set_property  -dict {PACKAGE_PIN  M14   IOSTANDARD LVCMOS18}  [get_ports gpio_status_0[7]]                           ; ## G25  FMC_HPC0_LA22_N
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_0[0]]                              ; ## D23  FMC_HPC0_LA23_P
set_property  -dict {PACKAGE_PIN  K16   IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_0[1]]                              ; ## D24  FMC_HPC0_LA23_N
set_property  -dict {PACKAGE_PIN  L12   IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_0[2]]                              ; ## H28  FMC_HPC0_LA24_P
set_property  -dict {PACKAGE_PIN  K12   IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_0[3]]                              ; ## H29  FMC_HPC0_LA24_N
set_property  -dict {PACKAGE_PIN  M11   IOSTANDARD LVCMOS18}  [get_ports gpio_en_agc_0]                              ; ## G27  FMC_HPC0_LA25_P
set_property  -dict {PACKAGE_PIN  N9    IOSTANDARD LVCMOS18}  [get_ports mcs_sync]                                   ; ## C22  FMC_HPC0_LA18_CC_P
set_property  -dict {PACKAGE_PIN  N8    IOSTANDARD LVCMOS18}  [get_ports gpio_resetb_0]                              ; ## C23  FMC_HPC0_LA18_CC_N
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD LVCMOS18}  [get_ports enable_0]                                   ; ## G18  FMC_HPC0_LA16_P
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS18}  [get_ports txnrx_0]                                    ; ## G19  FMC_HPC0_LA16_N
set_property  -dict {PACKAGE_PIN  M10   IOSTANDARD LVCMOS18}  [get_ports gpio_debug_1_0]                             ; ## C26  FMC_HPC0_LA27_P
set_property  -dict {PACKAGE_PIN  L10   IOSTANDARD LVCMOS18}  [get_ports gpio_debug_2_0]                             ; ## C27  FMC_HPC0_LA27_N
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS18}  [get_ports gpio_calsw_1_0]                             ; ## D26  FMC_HPC0_LA26_P
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18}  [get_ports gpio_calsw_2_0]                             ; ## D27  FMC_HPC0_LA26_N
set_property  -dict {PACKAGE_PIN  T7    IOSTANDARD LVCMOS18}  [get_ports gpio_ad5355_rfen]                           ; ## H31  FMC_HPC0_LA28_P
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS18}  [get_ports gpio_ad5355_lock]                           ; ## H37  FMC_HPC0_LA32_P

# spi

set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS18   PULLTYPE PULLUP} [get_ports spi_ad9361_0]              ; ## G30  FMC_HPC0_LA29_P
set_property  -dict {PACKAGE_PIN  U8    IOSTANDARD LVCMOS18   PULLTYPE PULLUP} [get_ports spi_ad9361_1]              ; ## G31  FMC_HPC0_LA29_N
set_property  -dict {PACKAGE_PIN  V6    IOSTANDARD LVCMOS18   PULLTYPE PULLUP} [get_ports spi_ad5355]                ; ## H34  FMC_HPC0_LA30_P
set_property  -dict {PACKAGE_PIN  U6    IOSTANDARD LVCMOS18}  [get_ports spi_clk]                                    ; ## H35  FMC_HPC0_LA30_N
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD LVCMOS18}  [get_ports spi_mosi]                                   ; ## G33  FMC_HPC0_LA31_P
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS18}  [get_ports spi_miso]                                   ; ## G34  FMC_HPC0_LA31_N

# ad9361 slave

set_property  -dict {PACKAGE_PIN  AE5   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_1_p]         ; ## G06  FMC_HPC1_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AF5   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_1_n]         ; ## G07  FMC_HPC1_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AJ6   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_1_p]       ; ## D08  FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AJ5   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_1_n]       ; ## D09  FMC_HPC1_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AD2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[0]]     ; ## H07  FMC_HPC1_LA02_P
set_property  -dict {PACKAGE_PIN  AD1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[0]]     ; ## H08  FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN  AH1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[1]]     ; ## G09  FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[1]]     ; ## G10  FMC_HPC1_LA03_N
set_property  -dict {PACKAGE_PIN  AF2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[2]]     ; ## H10  FMC_HPC1_LA04_P
set_property  -dict {PACKAGE_PIN  AF1   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[2]]     ; ## H11  FMC_HPC1_LA04_N
set_property  -dict {PACKAGE_PIN  AG3   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[3]]     ; ## D11  FMC_HPC1_LA05_P
set_property  -dict {PACKAGE_PIN  AH3   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[3]]     ; ## D12  FMC_HPC1_LA05_N
set_property  -dict {PACKAGE_PIN  AH2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[4]]     ; ## C10  FMC_HPC1_LA06_P
set_property  -dict {PACKAGE_PIN  AJ2   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[4]]     ; ## C11  FMC_HPC1_LA06_N
set_property  -dict {PACKAGE_PIN  AD4   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_p[5]]     ; ## H13  FMC_HPC1_LA07_P
set_property  -dict {PACKAGE_PIN  AE4   IOSTANDARD LVDS    DIFF_TERM_ADV TERM_100} [get_ports rx_data_in_1_n[5]]     ; ## H14  FMC_HPC1_LA07_N
set_property  -dict {PACKAGE_PIN  AE3   IOSTANDARD LVDS}   [get_ports tx_clk_out_1_p]                                ; ## G12  FMC_HPC1_LA08_P
set_property  -dict {PACKAGE_PIN  AF3   IOSTANDARD LVDS}   [get_ports tx_clk_out_1_n]                                ; ## G13  FMC_HPC1_LA08_N
set_property  -dict {PACKAGE_PIN  AE2   IOSTANDARD LVDS}   [get_ports tx_frame_out_1_p]                              ; ## D14  FMC_HPC1_LA09_P
set_property  -dict {PACKAGE_PIN  AE1   IOSTANDARD LVDS}   [get_ports tx_frame_out_1_n]                              ; ## D15  FMC_HPC1_LA09_N
set_property  -dict {PACKAGE_PIN  AH4   IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[0]]                            ; ## C14  FMC_HPC1_LA10_P
set_property  -dict {PACKAGE_PIN  AJ4   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[0]]                            ; ## C15  FMC_HPC1_LA10_N
set_property  -dict {PACKAGE_PIN  AE8   IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[1]]                            ; ## H16  FMC_HPC1_LA11_P
set_property  -dict {PACKAGE_PIN  AF8   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[1]]                            ; ## H17  FMC_HPC1_LA11_N
set_property  -dict {PACKAGE_PIN  AD7   IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[2]]                            ; ## G15  FMC_HPC1_LA12_P
set_property  -dict {PACKAGE_PIN  AD6   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[2]]                            ; ## G16  FMC_HPC1_LA12_N
set_property  -dict {PACKAGE_PIN  AG8   IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[3]]                            ; ## D17  FMC_HPC1_LA13_P
set_property  -dict {PACKAGE_PIN  AH8   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[3]]                            ; ## D18  FMC_HPC1_LA13_N
set_property  -dict {PACKAGE_PIN  AH7   IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[4]]                            ; ## C18  FMC_HPC1_LA14_P
set_property  -dict {PACKAGE_PIN  AH6   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[4]]                            ; ## C19  FMC_HPC1_LA14_N
set_property  -dict {PACKAGE_PIN  AD10  IOSTANDARD LVDS}   [get_ports tx_data_out_1_p[5]]                            ; ## H19  FMC_HPC1_LA15_P
set_property  -dict {PACKAGE_PIN  AE9   IOSTANDARD LVDS}   [get_ports tx_data_out_1_n[5]]                            ; ## H20  FMC_HPC1_LA15_N

set_property  -dict {PACKAGE_PIN  AA11  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[0]]                           ; ## H22  FMC_HPC1_LA19_P
set_property  -dict {PACKAGE_PIN  AA10  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[1]]                           ; ## H23  FMC_HPC1_LA19_N
set_property  -dict {PACKAGE_PIN  AB11  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[2]]                           ; ## G21  FMC_HPC1_LA20_P
set_property  -dict {PACKAGE_PIN  AB10  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[3]]                           ; ## G22  FMC_HPC1_LA20_N
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[4]]                           ; ## H25  FMC_HPC1_LA21_P
set_property  -dict {PACKAGE_PIN  AC11  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[5]]                           ; ## H26  FMC_HPC1_LA21_N
set_property  -dict {PACKAGE_PIN  AF11  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[6]]                           ; ## G24  FMC_HPC1_LA22_P
set_property  -dict {PACKAGE_PIN  AG11  IOSTANDARD LVCMOS18}  [get_ports gpio_status_1[7]]                           ; ## G25  FMC_HPC1_LA22_N
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_1[0]]                              ; ## D23  FMC_HPC1_LA23_P
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_1[1]]                              ; ## D24  FMC_HPC1_LA23_N
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_1[2]]                              ; ## H28  FMC_HPC1_LA24_P
set_property  -dict {PACKAGE_PIN  AH11  IOSTANDARD LVCMOS18}  [get_ports gpio_ctl_1[3]]                              ; ## H29  FMC_HPC1_LA24_N
set_property  -dict {PACKAGE_PIN  AE10  IOSTANDARD LVCMOS18}  [get_ports gpio_en_agc_1]                              ; ## G27  FMC_HPC1_LA25_P
set_property  -dict {PACKAGE_PIN  W12   IOSTANDARD LVCMOS18}  [get_ports gpio_resetb_1]                              ; ## G30  FMC_HPC1_LA29_P
set_property  -dict {PACKAGE_PIN  AG10  IOSTANDARD LVCMOS18}  [get_ports enable_1]                                   ; ## G18  FMC_HPC1_LA16_P
set_property  -dict {PACKAGE_PIN  AG9   IOSTANDARD LVCMOS18}  [get_ports txnrx_1]                                    ; ## G19  FMC_HPC1_LA16_N
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS18}  [get_ports gpio_debug_3_1]                             ; ## C26  FMC_HPC1_LA27_P
set_property  -dict {PACKAGE_PIN  T10   IOSTANDARD LVCMOS18}  [get_ports gpio_debug_4_1]                             ; ## C27  FMC_HPC1_LA27_N
set_property  -dict {PACKAGE_PIN  T12   IOSTANDARD LVCMOS18}  [get_ports gpio_calsw_3_1]                             ; ## D26  FMC_HPC1_LA26_P
set_property  -dict {PACKAGE_PIN  R12   IOSTANDARD LVCMOS18}  [get_ports gpio_calsw_4_1]                             ; ## D27  FMC_HPC1_LA26_N

# clocks

create_clock -name rx_0_clk       -period   4.00 [get_ports rx_clk_in_0_p]
create_clock -name rx_1_clk       -period   4.00 [get_ports rx_clk_in_1_p]
create_clock -name ref_clk        -period   4.00 [get_ports ref_clk_p]

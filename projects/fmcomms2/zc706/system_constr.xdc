
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_clk_in_p]        ; ## G6   FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_clk_in_n]        ; ## G7   FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_frame_in_p]      ; ## D8   FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AG15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_frame_in_n]      ; ## D9   FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]    ; ## H7   FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]    ; ## H8   FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]    ; ## G9   FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]    ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]    ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]    ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]    ; ## D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]    ; ## D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]    ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]    ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]    ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]    ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVDS_25} [get_ports tx_clk_out_p]                      ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVDS_25} [get_ports tx_clk_out_n]                      ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  AH14  IOSTANDARD LVDS_25} [get_ports tx_frame_out_p]                    ; ## D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVDS_25} [get_ports tx_frame_out_n]                    ; ## D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  AJ16  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[0]]                  ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  AK16  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[0]]                  ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[1]]                  ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[1]]                  ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  AH17  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[2]]                  ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  AH16  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[2]]                  ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[3]]                  ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[3]]                  ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[4]]                  ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  AF17  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[4]]                  ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVDS_25} [get_ports tx_data_out_p[5]]                  ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVDS_25} [get_ports tx_data_out_n[5]]                  ; ## H20  FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25} [get_ports enable]                           ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS25} [get_ports txnrx]                            ; ## G19  FMC_LPC_LA16_N
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS25} [get_ports tdd_sync]                         ; ## PMOD1_7_LS

set_property  -dict {PACKAGE_PIN  AG26  IOSTANDARD LVCMOS25} [get_ports gpio_status[0]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  AG27  IOSTANDARD LVCMOS25} [get_ports gpio_status[1]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  AH28  IOSTANDARD LVCMOS25} [get_ports gpio_status[2]]                   ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  AH29  IOSTANDARD LVCMOS25} [get_ports gpio_status[3]]                   ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  AK27  IOSTANDARD LVCMOS25} [get_ports gpio_status[4]]                   ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  AK28  IOSTANDARD LVCMOS25} [get_ports gpio_status[5]]                   ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  AJ26  IOSTANDARD LVCMOS25} [get_ports gpio_status[6]]                   ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  AK26  IOSTANDARD LVCMOS25} [get_ports gpio_status[7]]                   ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  AF30  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[0]]                      ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  AG30  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[1]]                      ; ## H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  AF29  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[2]]                      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  AG29  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[3]]                      ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  AH26  IOSTANDARD LVCMOS25} [get_ports gpio_en_agc]                      ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  AH27  IOSTANDARD LVCMOS25} [get_ports gpio_sync]                        ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  AD25  IOSTANDARD LVCMOS25} [get_ports gpio_resetb]                      ; ## H31  FMC_LPC_LA28_P

set_property  -dict {PACKAGE_PIN  AJ30  IOSTANDARD LVCMOS25  PULLTYPE PULLUP} [get_ports spi_csn]         ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  AK30  IOSTANDARD LVCMOS25} [get_ports spi_clk]                          ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  AJ28  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                         ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  AJ29  IOSTANDARD LVCMOS25} [get_ports spi_miso]                         ; ## C27  FMC_LPC_LA27_N

# spi pmod J58

set_property  -dict {PACKAGE_PIN  AJ21  IOSTANDARD LVCMOS25  PULLTYPE PULLUP} [get_ports spi_udc_csn_tx]  ; ## PMOD1_0_LS
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS25  PULLTYPE PULLUP} [get_ports spi_udc_csn_rx]  ; ## PMOD1_4_LS
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS25} [get_ports spi_udc_sclk]                     ; ## PMOD1_3_LS
set_property  -dict {PACKAGE_PIN  AK21  IOSTANDARD LVCMOS25} [get_ports spi_udc_data]                     ; ## PMOD1_1_LS

set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS25} [get_ports gpio_muxout_tx]                   ; ## PMOD1_2_LS
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS25} [get_ports gpio_muxout_rx]                   ; ## PMOD1_6_LS

# clocks

create_clock -name rx_clk       -period  4.00 [get_ports rx_clk_in_p]
create_clock -name ad9361_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_ad9361/clk]

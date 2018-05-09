
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  F17   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_p]           ; ## G06  FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  F16   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_n]           ; ## G07  FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_p]         ; ## D08  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_n]         ; ## D09  FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  L20   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]       ; ## H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  K20   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]       ; ## H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  K19   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]       ; ## G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  K18   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]       ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  L17   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]       ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]       ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  K17   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]       ; ## D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  J17   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]       ; ## D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]       ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  G19   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]       ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  J16   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]       ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]       ; ## H14  FMC_LPC_LA07_N

set_property  -dict {PACKAGE_PIN  E18   IOSTANDARD LVDS} [get_ports tx_clk_out_p]                         ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  E17   IOSTANDARD LVDS} [get_ports tx_clk_out_n]                         ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  H16   IOSTANDARD LVDS} [get_ports tx_frame_out_p]                       ; ## D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  G16   IOSTANDARD LVDS} [get_ports tx_frame_out_n]                       ; ## D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  A13   IOSTANDARD LVDS} [get_ports tx_data_out_p[0]]                     ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  A12   IOSTANDARD LVDS} [get_ports tx_data_out_n[0]]                     ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  G18   IOSTANDARD LVDS} [get_ports tx_data_out_p[1]]                     ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  F18   IOSTANDARD LVDS} [get_ports tx_data_out_n[1]]                     ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  G15   IOSTANDARD LVDS} [get_ports tx_data_out_p[2]]                     ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  F15   IOSTANDARD LVDS} [get_ports tx_data_out_n[2]]                     ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVDS} [get_ports tx_data_out_p[3]]                     ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVDS} [get_ports tx_data_out_n[3]]                     ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  C13   IOSTANDARD LVDS} [get_ports tx_data_out_p[4]]                     ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  C12   IOSTANDARD LVDS} [get_ports tx_data_out_n[4]]                     ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  D16   IOSTANDARD LVDS} [get_ports tx_data_out_p[5]]                     ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  C16   IOSTANDARD LVDS} [get_ports tx_data_out_n[5]]                     ; ## H20  FMC_LPC_LA15_N

set_property  -dict {PACKAGE_PIN  D17   IOSTANDARD LVCMOS18} [get_ports enable]                           ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  C17   IOSTANDARD LVCMOS18} [get_ports txnrx]                            ; ## G19  FMC_LPC_LA16_N

set_property  -dict {PACKAGE_PIN  F12   IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  E12   IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                   ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                   ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  H13   IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                   ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  H12   IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                   ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  B11   IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                   ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  A11   IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                   ; ## D24  FMC_LPC_LA23_N

set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                      ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  A6    IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                      ; ## H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  C7    IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  C6    IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                      ; ## G28  FMC_LPC_LA25_N

set_property  -dict {PACKAGE_PIN  D12   IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                      ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  C11   IOSTANDARD LVCMOS18} [get_ports gpio_sync]                        ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  M13   IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                      ; ## H31  FMC_LPC_LA28_P

set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]         ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  B8    IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  A7    IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## C27  FMC_LPC_LA27_N

# clocks

create_clock -name rx_clk       -period  4.00 [get_ports rx_clk_in_p]

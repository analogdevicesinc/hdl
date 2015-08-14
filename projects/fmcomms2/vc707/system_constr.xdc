
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  K39  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_p]        ; ## G6   FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  K40  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_n]        ; ## G7   FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  J40  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_p]      ; ## D8   FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_n]      ; ## D9   FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  P41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]    ; ## H7   FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  N41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]    ; ## H8   FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  M42  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]    ; ## G9   FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]    ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  H40  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]    ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  H41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]    ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  M41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]    ; ## D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  L41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]    ; ## D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  K42  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]    ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  J42  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]    ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  G41  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]    ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  G42  IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]    ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  M37  IOSTANDARD LVDS} [get_ports tx_clk_out_p]                      ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  M38  IOSTANDARD LVDS} [get_ports tx_clk_out_n]                      ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  R42  IOSTANDARD LVDS} [get_ports tx_frame_out_p]                    ; ## D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  P42  IOSTANDARD LVDS} [get_ports tx_frame_out_n]                    ; ## D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  F40  IOSTANDARD LVDS} [get_ports tx_data_out_p[0]]                  ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  F41  IOSTANDARD LVDS} [get_ports tx_data_out_n[0]]                  ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  R40  IOSTANDARD LVDS} [get_ports tx_data_out_p[1]]                  ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  P40  IOSTANDARD LVDS} [get_ports tx_data_out_n[1]]                  ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  H39  IOSTANDARD LVDS} [get_ports tx_data_out_p[2]]                  ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  G39  IOSTANDARD LVDS} [get_ports tx_data_out_n[2]]                  ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  N38  IOSTANDARD LVDS} [get_ports tx_data_out_p[3]]                  ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  M39  IOSTANDARD LVDS} [get_ports tx_data_out_n[3]]                  ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  N39  IOSTANDARD LVDS} [get_ports tx_data_out_p[4]]                  ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  N40  IOSTANDARD LVDS} [get_ports tx_data_out_n[4]]                  ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  M36  IOSTANDARD LVDS} [get_ports tx_data_out_p[5]]                  ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  L37  IOSTANDARD LVDS} [get_ports tx_data_out_n[5]]                  ; ## H20  FMC_LPC_LA15_N

set_property  -dict {PACKAGE_PIN  Y29  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  Y30  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  N28  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                   ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  N29  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                   ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  R28  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                   ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  P28  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                   ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  P30  IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                   ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  N31  IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                   ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  R30  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                      ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  P31  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                      ; ## H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  K29  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  K30  IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                      ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  W30  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                      ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  W31  IOSTANDARD LVCMOS18} [get_ports gpio_sync]                        ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  L29  IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                      ; ## H31  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  K37  IOSTANDARD LVCMOS18} [get_ports enable]                           ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  K38  IOSTANDARD LVCMOS18} [get_ports txnrx]                            ; ## G19  FMC_LPC_LA16_N

set_property  -dict {PACKAGE_PIN  J30  IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn_0]         ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  H30  IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  J31  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  H31  IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## C27  FMC_LPC_LA27_N

# clocks

create_clock -name rx_clk       -period  4 [get_ports rx_clk_in_p]
create_clock -name ad9361_clk   -period  4 [get_pins i_system_wrapper/system_i/axi_ad9361/clk]

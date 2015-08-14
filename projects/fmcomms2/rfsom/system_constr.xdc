
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  J14  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_clk_in_p]       ; ## IO_L12P_T1_MRCC_35
set_property  -dict {PACKAGE_PIN  H14  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_clk_in_n]       ; ## IO_L12N_T1_MRCC_35
set_property  -dict {PACKAGE_PIN  H13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_frame_in_p]     ; ## IO_L7P_T1_AD2P_35
set_property  -dict {PACKAGE_PIN  H12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_frame_in_n]     ; ## IO_L7N_T1_AD2N_35
set_property  -dict {PACKAGE_PIN  F12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]   ; ## IO_L1P_T0_AD0P_35
set_property  -dict {PACKAGE_PIN  E12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]   ; ## IO_L1N_T0_AD0N_35
set_property  -dict {PACKAGE_PIN  E10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]   ; ## IO_L2P_T0_AD8P_35
set_property  -dict {PACKAGE_PIN  D10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]   ; ## IO_L2N_T0_AD8N_35
set_property  -dict {PACKAGE_PIN  G10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]   ; ## IO_L3P_T0_DQS_AD1P_35
set_property  -dict {PACKAGE_PIN  F10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]   ; ## IO_L3N_T0_DQS_AD1N_35
set_property  -dict {PACKAGE_PIN  E11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]   ; ## IO_L4P_T0_35
set_property  -dict {PACKAGE_PIN  D11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]   ; ## IO_L4N_T0_35
set_property  -dict {PACKAGE_PIN  G12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]   ; ## IO_L5P_T0_AD9P_35
set_property  -dict {PACKAGE_PIN  G11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]   ; ## IO_L5N_T0_AD9N_35
set_property  -dict {PACKAGE_PIN  F13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]   ; ## IO_L6P_T0_35
set_property  -dict {PACKAGE_PIN  E13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]   ; ## IO_L6N_T0_VREF_35
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVDS}     [get_ports tx_clk_out_p]                      ; ## IO_L8P_T1_AD10P_35
set_property  -dict {PACKAGE_PIN  J13  IOSTANDARD LVDS}     [get_ports tx_clk_out_n]                      ; ## IO_L8N_T1_AD10N_35
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVDS}     [get_ports tx_frame_out_p]                    ; ## IO_L9P_T1_DQS_AD3P_35
set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVDS}     [get_ports tx_frame_out_n]                    ; ## IO_L9N_T1_DQS_AD3N_35
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVDS}     [get_ports tx_data_out_p[0]]                  ; ## IO_L13P_T2_MRCC_35
set_property  -dict {PACKAGE_PIN  D14  IOSTANDARD LVDS}     [get_ports tx_data_out_n[0]]                  ; ## IO_L13N_T2_MRCC_35
set_property  -dict {PACKAGE_PIN  F15  IOSTANDARD LVDS}     [get_ports tx_data_out_p[1]]                  ; ## IO_L14P_T2_AD4P_SRCC_35
set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVDS}     [get_ports tx_data_out_n[1]]                  ; ## IO_L14N_T2_AD4N_SRCC_35
set_property  -dict {PACKAGE_PIN  C17  IOSTANDARD LVDS}     [get_ports tx_data_out_p[2]]                  ; ## IO_L15P_T2_DQS_AD12P_35
set_property  -dict {PACKAGE_PIN  C16  IOSTANDARD LVDS}     [get_ports tx_data_out_n[2]]                  ; ## IO_L15N_T2_DQS_AD12N_35
set_property  -dict {PACKAGE_PIN  E16  IOSTANDARD LVDS}     [get_ports tx_data_out_p[3]]                  ; ## IO_L16P_T2_35
set_property  -dict {PACKAGE_PIN  D16  IOSTANDARD LVDS}     [get_ports tx_data_out_n[3]]                  ; ## IO_L16N_T2_35
set_property  -dict {PACKAGE_PIN  B16  IOSTANDARD LVDS}     [get_ports tx_data_out_p[4]]                  ; ## IO_L17P_T2_AD5P_35
set_property  -dict {PACKAGE_PIN  B15  IOSTANDARD LVDS}     [get_ports tx_data_out_n[4]]                  ; ## IO_L17N_T2_AD5N_35
set_property  -dict {PACKAGE_PIN  B17  IOSTANDARD LVDS}     [get_ports tx_data_out_p[5]]                  ; ## IO_L18P_T2_AD13P_35
set_property  -dict {PACKAGE_PIN  A17  IOSTANDARD LVDS}     [get_ports tx_data_out_n[5]]                  ; ## IO_L18N_T2_AD13N_35
set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS18} [get_ports enable]                            ; ## IO_L11P_T1_SRCC_35
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18} [get_ports txnrx]                             ; ## IO_L11N_T1_SRCC_35
set_property  -dict {PACKAGE_PIN  AA18 IOSTANDARD LVCMOS25} [get_ports tdd_sync]                          ; ## IO_L24_13_JX2_N

set_property  -dict {PACKAGE_PIN  D13  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                    ; ## IO_L19P_T3_35
set_property  -dict {PACKAGE_PIN  C13  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                    ; ## IO_L19N_T3_VREF_35
set_property  -dict {PACKAGE_PIN  C14  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                    ; ## IO_L20P_T3_AD6P_35
set_property  -dict {PACKAGE_PIN  B14  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                    ; ## IO_L20N_T3_AD6N_35
set_property  -dict {PACKAGE_PIN  A15  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                    ; ## IO_L21P_T3_DQS_AD14P_35
set_property  -dict {PACKAGE_PIN  A14  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                    ; ## IO_L21N_T3_DQS_AD14N_35
set_property  -dict {PACKAGE_PIN  C12  IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                    ; ## IO_L22P_T3_AD7P_35
set_property  -dict {PACKAGE_PIN  B12  IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                    ; ## IO_L22N_T3_AD7N_35
set_property  -dict {PACKAGE_PIN  C2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                       ; ## IO_L23P_T3_34
set_property  -dict {PACKAGE_PIN  B1   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                       ; ## IO_L23N_T3_34
set_property  -dict {PACKAGE_PIN  B2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                       ; ## IO_L24P_T3_34
set_property  -dict {PACKAGE_PIN  A2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                       ; ## IO_L24N_T3_34
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                       ; ## IO_L10P_T1_AD11P_35
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18} [get_ports gpio_sync]                         ; ## IO_L10N_T1_AD11N_35
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                       ; ## IO_0_VRN_35
set_property  -dict {PACKAGE_PIN  K11  IOSTANDARD LVCMOS18} [get_ports gpio_clksel]                       ; ## IO_0_VRN_34
set_property  -dict {PACKAGE_PIN  K10  IOSTANDARD LVCMOS18} [get_ports gpio_rfpwr_enable]                 ; ## IO_25_VRP_34

set_property  -dict {PACKAGE_PIN  C11  IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]          ; ## IO_L23P_T3_35
set_property  -dict {PACKAGE_PIN  B11  IOSTANDARD LVCMOS18} [get_ports spi_clk]                           ; ## IO_L23N_T3_35
set_property  -dict {PACKAGE_PIN  A13  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                          ; ## IO_L24P_T3_AD15P_35
set_property  -dict {PACKAGE_PIN  A12  IOSTANDARD LVCMOS18} [get_ports spi_miso]                          ; ## IO_L24N_T3_AD15N_35

# clocks

create_clock -name rx_clk       -period  4 [get_ports rx_clk_in_p]
create_clock -name ad9361_clk   -period  4 [get_pins i_system_wrapper/system_i/axi_ad9361/clk]

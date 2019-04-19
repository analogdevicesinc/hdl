
# constraints (pzsdr2.e)
# ad9361

set_property  -dict {PACKAGE_PIN  J14  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_clk_in_p]       ; ## IO_L12P_T1_MRCC_35           U1,J14,IO_L12_MRCC_35_DATA_CLK_P
set_property  -dict {PACKAGE_PIN  H14  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_clk_in_n]       ; ## IO_L12N_T1_MRCC_35           U1,H14,IO_L12_MRCC_35_DATA_CLK_N
set_property  -dict {PACKAGE_PIN  H13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_frame_in_p]     ; ## IO_L7P_T1_AD2P_35            U1,H13,IO_L07_35_RX_FRAME_P
set_property  -dict {PACKAGE_PIN  H12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_frame_in_n]     ; ## IO_L7N_T1_AD2N_35            U1,H12,IO_L07_35_RX_FRAME_N
set_property  -dict {PACKAGE_PIN  F12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]   ; ## IO_L1P_T0_AD0P_35            U1,F12,IO_L01_35_RX_D0_P
set_property  -dict {PACKAGE_PIN  E12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]   ; ## IO_L1N_T0_AD0N_35            U1,E12,IO_L01_35_RX_D0_N
set_property  -dict {PACKAGE_PIN  E10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]   ; ## IO_L2P_T0_AD8P_35            U1,E10,IO_L02_35_RX_D1_P
set_property  -dict {PACKAGE_PIN  D10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]   ; ## IO_L2N_T0_AD8N_35            U1,D10,IO_L02_35_RX_D1_N
set_property  -dict {PACKAGE_PIN  G10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]   ; ## IO_L3P_T0_DQS_AD1P_35        U1,G10,IO_L03_35_RX_D2_P
set_property  -dict {PACKAGE_PIN  F10  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]   ; ## IO_L3N_T0_DQS_AD1N_35        U1,F10,IO_L03_35_RX_D2_N
set_property  -dict {PACKAGE_PIN  E11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]   ; ## IO_L4P_T0_35                 U1,E11,IO_L04_35_RX_D3_P
set_property  -dict {PACKAGE_PIN  D11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]   ; ## IO_L4N_T0_35                 U1,D11,IO_L04_35_RX_D3_N
set_property  -dict {PACKAGE_PIN  G12  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]   ; ## IO_L5P_T0_AD9P_35            U1,G12,IO_L05_35_RX_D4_P
set_property  -dict {PACKAGE_PIN  G11  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]   ; ## IO_L5N_T0_AD9N_35            U1,G11,IO_L05_35_RX_D4_N
set_property  -dict {PACKAGE_PIN  F13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]   ; ## IO_L6P_T0_35                 U1,F13,IO_L06_35_RX_D5_P
set_property  -dict {PACKAGE_PIN  E13  IOSTANDARD LVDS      DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]   ; ## IO_L6N_T0_VREF_35            U1,E13,IO_L06_35_RX_D5_N
set_property  -dict {PACKAGE_PIN  K13  IOSTANDARD LVDS}     [get_ports tx_clk_out_p]                      ; ## IO_L8P_T1_AD10P_35           U1,K13,IO_L08_35_FB_CLK_P
set_property  -dict {PACKAGE_PIN  J13  IOSTANDARD LVDS}     [get_ports tx_clk_out_n]                      ; ## IO_L8N_T1_AD10N_35           U1,J13,IO_L08_35_FB_CLK_N
set_property  -dict {PACKAGE_PIN  K15  IOSTANDARD LVDS}     [get_ports tx_frame_out_p]                    ; ## IO_L9P_T1_DQS_AD3P_35        U1,K15,IO_L09_35_TX_FRAME_P
set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVDS}     [get_ports tx_frame_out_n]                    ; ## IO_L9N_T1_DQS_AD3N_35        U1,J15,IO_L09_35_TX_FRAME_N
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVDS}     [get_ports tx_data_out_p[0]]                  ; ## IO_L13P_T2_MRCC_35           U1,D15,IO_L13_35_TX_D0_P
set_property  -dict {PACKAGE_PIN  D14  IOSTANDARD LVDS}     [get_ports tx_data_out_n[0]]                  ; ## IO_L13N_T2_MRCC_35           U1,D14,IO_L13_35_TX_D0_N
set_property  -dict {PACKAGE_PIN  F15  IOSTANDARD LVDS}     [get_ports tx_data_out_p[1]]                  ; ## IO_L14P_T2_AD4P_SRCC_35      U1,F15,IO_L14_35_TX_D1_P
set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVDS}     [get_ports tx_data_out_n[1]]                  ; ## IO_L14N_T2_AD4N_SRCC_35      U1,E15,IO_L14_35_TX_D1_N
set_property  -dict {PACKAGE_PIN  C17  IOSTANDARD LVDS}     [get_ports tx_data_out_p[2]]                  ; ## IO_L15P_T2_DQS_AD12P_35      U1,C17,IO_L15_35_TX_D2_P
set_property  -dict {PACKAGE_PIN  C16  IOSTANDARD LVDS}     [get_ports tx_data_out_n[2]]                  ; ## IO_L15N_T2_DQS_AD12N_35      U1,C16,IO_L15_35_TX_D2_N
set_property  -dict {PACKAGE_PIN  E16  IOSTANDARD LVDS}     [get_ports tx_data_out_p[3]]                  ; ## IO_L16P_T2_35                U1,E16,IO_L16_35_TX_D3_P
set_property  -dict {PACKAGE_PIN  D16  IOSTANDARD LVDS}     [get_ports tx_data_out_n[3]]                  ; ## IO_L16N_T2_35                U1,D16,IO_L16_35_TX_D3_N
set_property  -dict {PACKAGE_PIN  B16  IOSTANDARD LVDS}     [get_ports tx_data_out_p[4]]                  ; ## IO_L17P_T2_AD5P_35           U1,B16,IO_L17_35_TX_D4_P
set_property  -dict {PACKAGE_PIN  B15  IOSTANDARD LVDS}     [get_ports tx_data_out_n[4]]                  ; ## IO_L17N_T2_AD5N_35           U1,B15,IO_L17_35_TX_D4_N
set_property  -dict {PACKAGE_PIN  B17  IOSTANDARD LVDS}     [get_ports tx_data_out_p[5]]                  ; ## IO_L18P_T2_AD13P_35          U1,B17,IO_L18_35_TX_D5_P
set_property  -dict {PACKAGE_PIN  A17  IOSTANDARD LVDS}     [get_ports tx_data_out_n[5]]                  ; ## IO_L18N_T2_AD13N_35          U1,A17,IO_L18_35_TX_D5_N

# clocks

create_clock -name rx_clk       -period  4 [get_ports rx_clk_in_p]


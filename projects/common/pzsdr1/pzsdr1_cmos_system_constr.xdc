
# constraints
# ad9361 (SWAP == 0x0)

set_property  -dict {PACKAGE_PIN  K17  IOSTANDARD LVCMOS25} [get_ports rx_clk_in]                         ; ## IO_L12P_T1_MRCC_35
set_property  -dict {PACKAGE_PIN  M19  IOSTANDARD LVCMOS25} [get_ports rx_frame_in]                       ; ## IO_L7P_T1_AD2P_35
set_property  -dict {PACKAGE_PIN  H17  IOSTANDARD LVCMOS25} [get_ports rx_data_in[0]]                     ; ## IO_L13N_T2_MRCC_35
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVCMOS25} [get_ports rx_data_in[1]]                     ; ## IO_L13P_T2_MRCC_35
set_property  -dict {PACKAGE_PIN  H18  IOSTANDARD LVCMOS25} [get_ports rx_data_in[2]]                     ; ## IO_L14N_T2_AD4N_SRCC_35
set_property  -dict {PACKAGE_PIN  J18  IOSTANDARD LVCMOS25} [get_ports rx_data_in[3]]                     ; ## IO_L14P_T2_AD4P_SRCC_35
set_property  -dict {PACKAGE_PIN  F20  IOSTANDARD LVCMOS25} [get_ports rx_data_in[4]]                     ; ## IO_L15N_T2_DQS_AD12N_35
set_property  -dict {PACKAGE_PIN  F19  IOSTANDARD LVCMOS25} [get_ports rx_data_in[5]]                     ; ## IO_L15P_T2_DQS_AD12P_35
set_property  -dict {PACKAGE_PIN  G18  IOSTANDARD LVCMOS25} [get_ports rx_data_in[6]]                     ; ## IO_L16N_T2_35
set_property  -dict {PACKAGE_PIN  G17  IOSTANDARD LVCMOS25} [get_ports rx_data_in[7]]                     ; ## IO_L16P_T2_35
set_property  -dict {PACKAGE_PIN  H20  IOSTANDARD LVCMOS25} [get_ports rx_data_in[8]]                     ; ## IO_L17N_T2_AD5N_35
set_property  -dict {PACKAGE_PIN  J20  IOSTANDARD LVCMOS25} [get_ports rx_data_in[9]]                     ; ## IO_L17P_T2_AD5P_35
set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVCMOS25} [get_ports rx_data_in[10]]                    ; ## IO_L18N_T2_AD13N_35
set_property  -dict {PACKAGE_PIN  G19  IOSTANDARD LVCMOS25} [get_ports rx_data_in[11]]                    ; ## IO_L18P_T2_AD13P_35

set_property  -dict {PACKAGE_PIN  M17  IOSTANDARD LVCMOS25} [get_ports tx_clk_out]                        ; ## IO_L8P_T1_AD10P_35
set_property  -dict {PACKAGE_PIN  L19  IOSTANDARD LVCMOS25} [get_ports tx_frame_out]                      ; ## IO_L9P_T1_DQS_AD3P_35
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVCMOS25} [get_ports tx_data_out[0]]                    ; ## IO_L1N_T0_AD0N_35
set_property  -dict {PACKAGE_PIN  C20  IOSTANDARD LVCMOS25} [get_ports tx_data_out[1]]                    ; ## IO_L1P_T0_AD0P_35
set_property  -dict {PACKAGE_PIN  A20  IOSTANDARD LVCMOS25} [get_ports tx_data_out[2]]                    ; ## IO_L2N_T0_AD8N_35
set_property  -dict {PACKAGE_PIN  B19  IOSTANDARD LVCMOS25} [get_ports tx_data_out[3]]                    ; ## IO_L2P_T0_AD8P_35
set_property  -dict {PACKAGE_PIN  D18  IOSTANDARD LVCMOS25} [get_ports tx_data_out[4]]                    ; ## IO_L3N_T0_DQS_AD1N_35
set_property  -dict {PACKAGE_PIN  E17  IOSTANDARD LVCMOS25} [get_ports tx_data_out[5]]                    ; ## IO_L3P_T0_DQS_AD1P_35
set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVCMOS25} [get_ports tx_data_out[6]]                    ; ## IO_L4N_T0_35
set_property  -dict {PACKAGE_PIN  D19  IOSTANDARD LVCMOS25} [get_ports tx_data_out[7]]                    ; ## IO_L4P_T0_35
set_property  -dict {PACKAGE_PIN  E19  IOSTANDARD LVCMOS25} [get_ports tx_data_out[8]]                    ; ## IO_L5N_T0_AD9N_35
set_property  -dict {PACKAGE_PIN  E18  IOSTANDARD LVCMOS25} [get_ports tx_data_out[9]]                    ; ## IO_L5P_T0_AD9P_35
set_property  -dict {PACKAGE_PIN  F17  IOSTANDARD LVCMOS25} [get_ports tx_data_out[10]]                   ; ## IO_L6N_T0_VREF_35
set_property  -dict {PACKAGE_PIN  F16  IOSTANDARD LVCMOS25} [get_ports tx_data_out[11]]                   ; ## IO_L6P_T0_35

set_property  -dict {PACKAGE_PIN  M18  IOSTANDARD LVCMOS25} [get_ports tx_gnd[0]]                         ; ## IO_L8N_T1_AD10N_35
set_property  -dict {PACKAGE_PIN  L20  IOSTANDARD LVCMOS25} [get_ports tx_gnd[1]]                         ; ## IO_L9N_T1_DQS_AD3N_35

# clocks

create_clock -name rx_clk       -period  8 [get_ports rx_clk_in]
create_clock -name ad9361_clk   -period  8 [get_pins i_system_wrapper/system_i/axi_ad9361/clk]


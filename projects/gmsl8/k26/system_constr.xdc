# constraints

#max A

# pin # sch net          # conn  # fpga

#da3n A_DA3N/DD1N/A3C/D1C p5 d22 : T7
#da3p A_DA3P/DD1P/A3B/D1B p5 d21 : R7
#da2n A_DA2N/DD0N/A2B/D0B p5 b25 : T8
#da2p A_DA2P/DD0P/A2A/D0A p5 b24 : R8
#da1n A_DA1N/DC1N/A1C/C1C p5 c18 : V8
#da1p A_DA1P/DC1P/A1B/C1B p5 c17 : U8
#da0n A_DA0N/DC0N/A0B/C0B p5 d13 : V9
#da0p A_DA0P/DC0P/A0A/C0A p5 d12 : U9
#ckan A_CKAN/CKDN/A3A/D1A p5 d16 : Y8
#ckap A_CKAP/CKDP/A2C/D0C p5 d15 : W8

#db3n A_DB3N/DF1N/B3C/F1C p5 c15 : N8
#db3p A_DB3P/DF1P/B3B/F1B p5 c14 : N9
#db2n A_DB2N/DF0N/B2B/F0B p5 c21 : P6
#db2p A_DB2P/DF0P/B2A/F0A p5 c20 : P7
#db1n A_DB1N/DE1N/B1C/E1C p5 a18 : N6
#db1p A_DB1P/DE1P/B1B/E1B p5 a17 : N7
#db0n A_DB0N/DE0N/B0B/E0B p5 b22 : L5
#db0p A_DB0P/DE0P/B0A/E0A p5 b21 : M6
#ckbn A_CKBN/CKEN/B1A/E1A p5 b13 : L6
#ckbp A_CKBP/CKEP/B0C/E0C p5 b12 : L7

#max B

#da3n B_DA3N/DD1N/A3C/D1C p5 c12 : K3
#da3p B_DA3P/DD1P/A3B/D1B p5 c11 : K4
#da2n B_DA2N/DD0N/A2B/D0B p5 a15 : H3
#da2p B_DA2P/DD0P/A2A/D0A p5 a14 : H4
#da1n B_DA1N/DC1N/A1C/C1C p5 b16 : J2
#da1p B_DA1P/DC1P/A1B/C1B p5 b15 : K2
#da0n B_DA0N/DC0N/A0B/C0B p5 a21 : H1
#da0p B_DA0P/DC0P/A0A/C0A p5 a20 : J1
#ckan B_CKAN/CKDN/A3A/D1A p5 b19 : K1
#ckap B_CKAP/CKDP/A2C/D0C p5 b18 : L1


#db3n B_DB3N/DF1N/B3C/F1C p5 a27 : H8
#db3p B_DB3P/DF1P/B3B/F1B p5 a26 : H9
#db2n B_DB2N/DF0N/B2B/F0B p5 c24 : J9
#db2p B_DB2P/DF0P/B2A/F0A p5 c23 : K9
#db1n B_DB1N/DE1N/B1C/E1C p5 d25 : K7
#db1p B_DB1P/DE1P/B1B/E1B p5 d24 : K8
#db0n B_DB0N/DE0N/B0B/E0B p5 a24 : H7
#db0p B_DB0P/DE0P/B0A/E0A p5 a23 : J7
#ckbn B_CKBN/CKEN/B1A/E1A p5 a12 : J4
#ckbp B_CKBP/CKEP/B0C/E0C p5 a11 : J5

### MIPIA0
#set_property -dict {PACKAGE_PIN T7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[3]]; # Bank 65 VCCO - som240_2_a44 - IO_L5N_50U_N9_AD14N_65
#set_property -dict {PACKAGE_PIN R7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[3]]; # Bank 65 VCCO - som240_2_a44 - IO_L5P_T0U_N8_AD14P_65
#set_property -dict {PACKAGE_PIN T8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[2]]; # Bank 65 VCCO - som240_2_a44 - IO_L4N_T0U_N7_DBC_AD7N_65
#set_property -dict {PACKAGE_PIN R8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[2]]; # Bank 65 VCCO - som240_2_a44 - IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
#set_property -dict {PACKAGE_PIN V8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
#set_property -dict {PACKAGE_PIN U8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
#set_property -dict {PACKAGE_PIN V9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
#set_property -dict {PACKAGE_PIN U9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
#set_property -dict {PACKAGE_PIN Y8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_n]; # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
#set_property -dict {PACKAGE_PIN W8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65

### MIPIA1
#set_property -dict {PACKAGE_PIN K3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[3]];  # Bank 65 VCCO - som240_2_a44 - IO_L11N_T1U_N9_GC_65
#set_property -dict {PACKAGE_PIN K4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[3]];  # Bank 65 VCCO - som240_2_a44 - IO_L11P_T1U_N8_GC_65
#set_property -dict {PACKAGE_PIN H3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[2]];  # Bank 65 VCCO - som240_2_a44 - IO_L10N_T1U_N7_QBC_AD4N_65
#set_property -dict {PACKAGE_PIN H4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[2]];  # Bank 65 VCCO - som240_2_a44 - IO_L10P_T1U_N6_QBC_AD4P_65
#set_property -dict {PACKAGE_PIN J2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9N_T1L_N5_AD12N_65
#set_property -dict {PACKAGE_PIN K2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9P_T1L_N4_AD12P_65
#set_property -dict {PACKAGE_PIN H1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8N_T1L_N3_AD5N_65
#set_property -dict {PACKAGE_PIN J1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8P_T1L_N2_AD5P_65
#set_property -dict {PACKAGE_PIN K1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L7N_T1L_N1_QBC_AD13N_65
#set_property -dict {PACKAGE_PIN L1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L7P_T1L_N0_QBC_AD13P_65

## MIPIB0
set_property -dict {PACKAGE_PIN N8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[3]]; # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN N9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[3]]; # Bank 65 VCCO - som240_2_a44 - IO_L17P_T2U_N8_AD10P_65
set_property -dict {PACKAGE_PIN P6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[2]]; # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN P7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[2]]; # Bank 65 VCCO - som240_2_a44 - IO_L16P_T2U_N6_QBC_AD3P_65
set_property -dict {PACKAGE_PIN N6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[1]]; # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN N7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L15P_T2L_N4_AD11P_65
set_property -dict {PACKAGE_PIN L5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[0]]; # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN M6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L14P_T2L_N2_GC_65
set_property -dict {PACKAGE_PIN L6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_n]; # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN L7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L13P_T2L_N0_GC_QBC_65

## MIPIB1
set_property -dict {PACKAGE_PIN H8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[3]];  # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN H9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[3]];  # Bank 65 VCCO - som240_2_a44 - IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property -dict {PACKAGE_PIN J9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[2]];  # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN K9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[2]];  # Bank 65 VCCO - som240_2_a44 - IO_L23P_T3U_N8_I2C_SCLK_65
set_property -dict {PACKAGE_PIN K7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[1]];  # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN K8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L22P_T3U_N6_DBC_AD0P_65
set_property -dict {PACKAGE_PIN H7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[0]];  # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN J7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L21P_T3L_N4_AD8P_65
set_property -dict {PACKAGE_PIN J4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_n];  # Bank 65 VCCO - som240_2_a44 -
set_property -dict {PACKAGE_PIN J5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L19P_T3L_N0_DBC_AD9P_65

# ETH
set_property PACKAGE_PIN Y6 [get_ports sfp_ref_clk_p] ;# p5 c3
set_property PACKAGE_PIN Y5 [get_ports sfp_ref_clk_n] ;# p5 c4
#create_clock -period 6.400 -name gt_ref_clk [get_ports sfp_ref_clk_p]

set_property PACKAGE_PIN T2 [get_ports sfp_rx_p] ;# p5 b1
set_property PACKAGE_PIN T1 [get_ports sfp_rx_n] ;# p5 b2
set_property PACKAGE_PIN R4 [get_ports sfp_tx_p] ;# p5 b5
set_property PACKAGE_PIN R3 [get_ports sfp_tx_n] ;# p5 b6

#
# VCCO_HDA B13 SOM1
set_property -dict {PACKAGE_PIN F11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[0]]    ;# p3 a15 
set_property -dict {PACKAGE_PIN J12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[1]]    ;# p3 a16
set_property -dict {PACKAGE_PIN H12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[2]]    ;# p3 a17
set_property -dict {PACKAGE_PIN J10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[3]]    ;# p3 b16
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS33} [get_ports crr_gpio[4]]    ;# p3 b17
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[5]]    ;# p3 b18
set_property -dict {PACKAGE_PIN H11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[6]]    ;# p3 c18
set_property -dict {PACKAGE_PIN G10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[7]]    ;# p3 c19
set_property -dict {PACKAGE_PIN F12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[8]]    ;# p3 c20
set_property -dict {PACKAGE_PIN G11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[9]]    ;# p3 d16
set_property -dict {PACKAGE_PIN F10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[10]]   ;# p3 d17
set_property -dict {PACKAGE_PIN J11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[11]]   ;# p3 d18

set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS18} [get_ports led_gpio]       ;# p5 b53
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS18} [get_ports btn_gpio]       ;# p5 c52

# VCCO_HPA D1 SOM1
set_property -dict {PACKAGE_PIN A2   IOSTANDARD LVCMOS18} [get_ports ad9545_miso]    ;# p3 a3 
set_property -dict {PACKAGE_PIN A1   IOSTANDARD LVCMOS18} [get_ports ad9545_sclk]    ;# p3 a4
set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVCMOS18} [get_ports ad9545_mosi]    ;# p3 b4
set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVCMOS18} [get_ports ad9545_cs]      ;# p3 b5
set_property -dict {PACKAGE_PIN B3   IOSTANDARD LVCMOS18} [get_ports ad9545_resetb]  ;# p3 b7

;# VCCO_HDA
set_property -dict {PACKAGE_PIN E10  IOSTANDARD LVCMOS33} [get_ports uart_rxd]       ;# p3 d20
set_property -dict {PACKAGE_PIN D10  IOSTANDARD LVCMOS33} [get_ports uart_txd]       ;# p3 d21

set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18} [get_ports tca_i2c_scl]    ;# p5 d49
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18} [get_ports tca_i2c_sda]    ;# p5 d50
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports tca_i2c_rstn]   ;# p3 c51

set_property -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS18} [get_ports en_i2c_alt]     ;# p5 a54

# max gpios; bank 43 1v8
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS18} [get_ports a_gmsl_pwdnb]   ;# p5 b44 
set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp0]    ;# p5 a46
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp1]    ;# p5 a47
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp2]    ;# p5 a48
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp3]    ;# p5 b45
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp4]    ;# p5 b46
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp5]    ;# p5 c46
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp6]    ;# p5 c47
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp7]    ;# p5 d45
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp8]    ;# p5 d44
                                                                                     
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_pwdnb]   ;# p5 b48
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp0]    ;# p5 a50
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp1]    ;# p5 a51
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp2]    ;# p5 a52
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp3]    ;# p5 b49
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp4]    ;# p5 b50
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp5]    ;# p5 c48       
set_property -dict {PACKAGE_PIN AD12 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp6]    ;# p5 c50
set_property -dict {PACKAGE_PIN AH10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp7]    ;# p5 d48
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp8]    ;# p5 d46

set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports sfp_tx_disable] ;# p5 b52

set_property -dict {PACKAGE_PIN C3   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_0_p] ;# p3 a6
set_property -dict {PACKAGE_PIN C2   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_0_n] ;# p3 a7
set_property -dict {PACKAGE_PIN C1   IOSTANDARD LVCMOS18} [get_ports refclk_0]                        ;# p3 b1

set_property -dict {PACKAGE_PIN E5   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_1_p] ;# p3 b10
set_property -dict {PACKAGE_PIN D5   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_1_n] ;# p3 b11
set_property -dict {PACKAGE_PIN A3   IOSTANDARD LVCMOS18} [get_ports refclk_1]                        ;# p3 b8

set_property -dict {PACKAGE_PIN D7   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_2_p] ;# p3 c12
set_property -dict {PACKAGE_PIN D6   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_2_n] ;# p3 c13
set_property -dict {PACKAGE_PIN A12  IOSTANDARD LVCMOS33} [get_ports refclk_2]                        ;# p3 c24

set_property -dict {PACKAGE_PIN A10  IOSTANDARD LVCMOS33} [get_ports fan_pwm]                         ;# p3 c23
set_property -dict {PACKAGE_PIN B11  IOSTANDARD LVCMOS33} [get_ports fan_tach1]                       ;# p3 c22
#set_property -dict {PACKAGE_PIN A12  IOSTANDARD LVCMOS33} [get_ports fan_tach2] ;# p3 c24

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design];

# constraints

## MIPIB0
set_property -dict {PACKAGE_PIN T7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[3]]; # Bank 65 VCCO - som240_2_a44 - IO_L5N_50U_N9_AD14N_65
set_property -dict {PACKAGE_PIN R7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[3]]; # Bank 65 VCCO - som240_2_a44 - IO_L5P_T0U_N8_AD14P_65
set_property -dict {PACKAGE_PIN T8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[2]]; # Bank 65 VCCO - som240_2_a44 - IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN R8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[2]]; # Bank 65 VCCO - som240_2_a44 - IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
set_property -dict {PACKAGE_PIN V8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN U8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
set_property -dict {PACKAGE_PIN V9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
set_property -dict {PACKAGE_PIN U9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_n]; # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
set_property -dict {PACKAGE_PIN W8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65

## MIPIB1
set_property -dict {PACKAGE_PIN K3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[3]];  # Bank 65 VCCO - som240_2_a44 - IO_L11N_T1U_N9_GC_65
set_property -dict {PACKAGE_PIN K4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[3]];  # Bank 65 VCCO - som240_2_a44 - IO_L11P_T1U_N8_GC_65
set_property -dict {PACKAGE_PIN H3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[2]];  # Bank 65 VCCO - som240_2_a44 - IO_L10N_T1U_N7_QBC_AD4N_65
set_property -dict {PACKAGE_PIN H4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[2]];  # Bank 65 VCCO - som240_2_a44 - IO_L10P_T1U_N6_QBC_AD4P_65
set_property -dict {PACKAGE_PIN J2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9N_T1L_N5_AD12N_65
set_property -dict {PACKAGE_PIN K2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9P_T1L_N4_AD12P_65
set_property -dict {PACKAGE_PIN H1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8N_T1L_N3_AD5N_65
set_property -dict {PACKAGE_PIN J1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8P_T1L_N2_AD5P_65
set_property -dict {PACKAGE_PIN K1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L7N_T1L_N1_QBC_AD13N_65
set_property -dict {PACKAGE_PIN L1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L7P_T1L_N0_QBC_AD13P_65

# ETH
set_property PACKAGE_PIN Y6 [get_ports sfp_ref_clk_p]
#create_clock -period 6.400 -name gt_ref_clk [get_ports sfp_ref_clk_p]

set_property PACKAGE_PIN T2 [get_ports sfp_rx_p]
set_property PACKAGE_PIN T1 [get_ports sfp_rx_n]
set_property PACKAGE_PIN R4 [get_ports sfp_tx_p]
set_property PACKAGE_PIN R3 [get_ports sfp_tx_n]

#
set_property -dict {PACKAGE_PIN F11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[0]] ;# VCCO_HDA B13 SOM1
set_property -dict {PACKAGE_PIN J12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[1]]
set_property -dict {PACKAGE_PIN H12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[2]]
set_property -dict {PACKAGE_PIN J10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[3]]
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS33} [get_ports crr_gpio[4]]
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[5]]
set_property -dict {PACKAGE_PIN H11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[6]]
set_property -dict {PACKAGE_PIN G10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[7]]
set_property -dict {PACKAGE_PIN F12  IOSTANDARD LVCMOS33} [get_ports crr_gpio[8]]
set_property -dict {PACKAGE_PIN G11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[9]]
set_property -dict {PACKAGE_PIN F10  IOSTANDARD LVCMOS33} [get_ports crr_gpio[10]]
set_property -dict {PACKAGE_PIN J11  IOSTANDARD LVCMOS33} [get_ports crr_gpio[11]]

set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS18} [get_ports led_gpio]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS18} [get_ports btn_gpio]

set_property -dict {PACKAGE_PIN A2   IOSTANDARD LVCMOS18} [get_ports ad9545_miso] ;# VCCO_HPA D1 SOM1
set_property -dict {PACKAGE_PIN A1   IOSTANDARD LVCMOS18} [get_ports ad9545_sclk]
set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVCMOS18} [get_ports ad9545_mosi]
set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVCMOS18} [get_ports ad9545_cs]
set_property -dict {PACKAGE_PIN B3   IOSTANDARD LVCMOS18} [get_ports ad9545_resetb]

set_property -dict {PACKAGE_PIN E10  IOSTANDARD LVCMOS33} [get_ports uart_rxd] ;# VCCO_HDA
set_property -dict {PACKAGE_PIN D10  IOSTANDARD LVCMOS33} [get_ports uart_txd]

set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18} [get_ports tca_i2c_scl]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18} [get_ports tca_i2c_sda]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports tca_i2c_rstn]

# max gpios
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS18} [get_ports a_gmsl_pwdnb] ;#bank 43 1v8
set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp0]
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp1]
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp2]
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp3]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp4]
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS18} [get_ports a_gmsl_mfp5]

set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_pwdnb]
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp0]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp1]
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp2]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp3]
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp4]
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18} [get_ports b_gmsl_mfp5]

set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports sfp_tx_disable]

set_property -dict {PACKAGE_PIN C3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_0_p]
set_property -dict {PACKAGE_PIN C2  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}   [get_ports refclk_0_n]
#set_property -dict {PACKAGE_PIN C3   IOSTANDARD LVDS}     [get_ports refclk_0_p]
#set_property -dict {PACKAGE_PIN C2   IOSTANDARD LVDS}     [get_ports refclk_0_n]
set_property -dict {PACKAGE_PIN C1   IOSTANDARD LVCMOS18} [get_ports refclk_0]


set_property -dict {PACKAGE_PIN B11  IOSTANDARD LVCMOS33} [get_ports fan_tach1]
set_property -dict {PACKAGE_PIN A12  IOSTANDARD LVCMOS33} [get_ports fan_tach2]
set_property -dict {PACKAGE_PIN A10  IOSTANDARD LVCMOS33} [get_ports fan_pwm]

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design];
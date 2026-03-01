###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

### MIPIA0

set_property -dict {PACKAGE_PIN T7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[3]] ; # Bank 65 VCCO - som240_2_a44 - IO_L5N_50U_N9_AD14N_65
set_property -dict {PACKAGE_PIN R7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[3]] ; # Bank 65 VCCO - som240_2_a44 - IO_L5P_T0U_N8_AD14P_65
set_property -dict {PACKAGE_PIN T8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[2]] ; # Bank 65 VCCO - som240_2_a44 - IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN R8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[2]] ; # Bank 65 VCCO - som240_2_a44 - IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
set_property -dict {PACKAGE_PIN V8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[1]] ; # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN U8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[1]] ; # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
set_property -dict {PACKAGE_PIN V9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[0]] ; # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
set_property -dict {PACKAGE_PIN U9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[0]] ; # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_clk_n]     ; # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
set_property -dict {PACKAGE_PIN W8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_clk_p]     ; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65

### MIPIA1
set_property -dict {PACKAGE_PIN K3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_n[3]] ; # Bank 65 VCCO - som240_2_a44 - IO_L5N_50U_N9_AD14N_65
set_property -dict {PACKAGE_PIN K4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_p[3]] ; # Bank 65 VCCO - som240_2_a44 - IO_L5P_T0U_N8_AD14P_65
set_property -dict {PACKAGE_PIN H3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_n[2]] ; # Bank 65 VCCO - som240_2_a44 - IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN H4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_p[2]] ; # Bank 65 VCCO - som240_2_a44 - IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
set_property -dict {PACKAGE_PIN J2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_n[1]] ; # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN K2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_p[1]] ; # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
set_property -dict {PACKAGE_PIN H1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_n[0]] ; # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
set_property -dict {PACKAGE_PIN J1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_data_p[0]] ; # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN K1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_clk_n]     ; # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
set_property -dict {PACKAGE_PIN L1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_ch1_clk_p]     ; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65

# VCCO_HDA B13 SOM1
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS18} [get_ports led0_user] ; # p5 b53

# VCCO_HPA D1 SOM1
set_property -dict {PACKAGE_PIN A2   IOSTANDARD LVCMOS18} [get_ports ad9545_miso]   ; # p3 a3
set_property -dict {PACKAGE_PIN A1   IOSTANDARD LVCMOS18} [get_ports ad9545_sclk]   ; # p3 a4
set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVCMOS18} [get_ports ad9545_mosi]   ; # p3 b4
set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVCMOS18} [get_ports ad9545_cs]     ; # p3 b5
set_property -dict {PACKAGE_PIN B3   IOSTANDARD LVCMOS18} [get_ports ad9545_resetb] ; # p3 b7

# VCCO_HDA
set_property -dict {PACKAGE_PIN AH10 IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_i2c_sda] ; # p5
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_i2c_scl] ; # p5
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports sfp_i2c_rstn]            ; # p3 c51
set_property -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS18} [get_ports sfp_i2c_en]              ; # p5 a54
set_false_path -to [get_ports {sfp_i2c_sda sfp_i2c_scl}]
set_output_delay 0 [get_ports {sfp_i2c_sda sfp_i2c_scl}]
set_false_path -from [get_ports {sfp_i2c_sda sfp_i2c_scl}]
set_input_delay 0 [get_ports {sfp_i2c_sda sfp_i2c_scl}]

set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18 PULLUP true} [get_ports tca_i2c_scl] ; # p5 d49
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18 PULLUP true} [get_ports tca_i2c_sda] ; # p5 d50
set_false_path -to [get_ports {tca_i2c_sda tca_i2c_scl}]
set_output_delay 0 [get_ports {tca_i2c_sda tca_i2c_scl}]
set_false_path -from [get_ports {tca_i2c_sda tca_i2c_scl}]
set_input_delay 0 [get_ports {tca_i2c_sda tca_i2c_scl}]

# max gpios; bank 43 1v8
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports mfp_3_p1] ; # p5 b45
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports mfp_2_p1] ; # p5 a48
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports mfp_1_p1] ; # p5 a47
set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS18} [get_ports mfp_0_p1] ; # p5 a46
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports mfp_3_p2] ;
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS18} [get_ports mfp_2_p2] ;
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports mfp_1_p2] ;
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS18} [get_ports mfp_0_p2] ;

set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports sfp_tx_disable] ; # p5 b52
set_false_path -to [get_ports {sfp_tx_disable}]
set_output_delay 0 [get_ports {sfp_tx_disable}]

set_property -dict {PACKAGE_PIN C1   IOSTANDARD LVCMOS18} [get_ports ref_ad9545_pl] ; # p3 b1

set_property -dict {PACKAGE_PIN A10  IOSTANDARD LVCMOS33} [get_ports fan_pwm]  ; # p3 c23
set_property -dict {PACKAGE_PIN B11  IOSTANDARD LVCMOS33} [get_ports fan_tach] ; # p3 c22

# SFP+ Interface corundum
set_property PACKAGE_PIN Y6 [get_ports sfp_mgt_refclk_p] ; # p5 c3
set_property PACKAGE_PIN Y5 [get_ports sfp_mgt_refclk_n] ; # p5 c4
create_clock -period 6.400 -name gt_ref_clk [get_ports sfp_mgt_refclk_p]

set_property PACKAGE_PIN T2 [get_ports sfp_rx_p] ; # p5 b1
set_property PACKAGE_PIN T1 [get_ports sfp_rx_n] ; # p5 b2
set_property PACKAGE_PIN R4 [get_ports sfp_tx_p] ; # p5 b5
set_property PACKAGE_PIN R3 [get_ports sfp_tx_n] ; # p5 b6

create_clock -name spi0_clk  -period 40 [get_pins -hier */EMIOSPI0SCLKO]

####

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design];

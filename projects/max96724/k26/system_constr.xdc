# constraints

set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18 PULLUP true} [get_ports iic_scl_io]; # Bank  45 VCCO - som240_1_b13 - IO_L5P_HDGC_45
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18 PULLUP true} [get_ports iic_sda_io]; # Bank  45 VCCO - som240_1_b13 - IO_L5N_HDGC_45

set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS18} [get_ports iic_rstn]; # Bank  43 VCCO - som240_2_b59 - IO_L4P_AD8P_43

set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS18} [get_ports iic_alt_gmsl_deser]; # Bank  44 VCCO - som240_2_d59 - IO_L10P_AD10P_44

set_property -dict {PACKAGE_PIN T7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[3]]; # Bank  65 VCCO - som240_2_a44 - IO_L5N_T0U_N9_AD14N_65
set_property -dict {PACKAGE_PIN R7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[3]]; # Bank  65 VCCO - som240_2_a44 - IO_L5P_T0U_N8_AD14P_65
set_property -dict {PACKAGE_PIN T8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[2]]; # Bank  65 VCCO - som240_2_a44 - IO_L4N_T0U_N7_DBC_AD7N_65
set_property -dict {PACKAGE_PIN R8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[2]]; # Bank  65 VCCO - som240_2_a44 - IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65
set_property -dict {PACKAGE_PIN V8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[1]]; # Bank  65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN U8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[1]]; # Bank  65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
set_property -dict {PACKAGE_PIN V9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[0]]; # Bank  65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
set_property -dict {PACKAGE_PIN U9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[0]]; # Bank  65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_clk_n]; # Bank  65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
set_property -dict {PACKAGE_PIN W8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_clk_p]; # Bank  65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65
 
set_property -dict {PACKAGE_PIN K3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_n[3]]; # Bank  65 VCCO - som240_2_a44 - IO_L11N_T1U_N9_GC_65
set_property -dict {PACKAGE_PIN K4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_p[3]]; # Bank  65 VCCO - som240_2_a44 - IO_L11P_T1U_N8_GC_65
set_property -dict {PACKAGE_PIN H3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_n[2]]; # Bank  65 VCCO - som240_2_a44 - IO_L10N_T1U_N7_QBC_AD4N_65
set_property -dict {PACKAGE_PIN H4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_p[2]]; # Bank  65 VCCO - som240_2_a44 - IO_L10P_T1U_N6_QBC_AD4P_65
set_property -dict {PACKAGE_PIN J2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_n[1]]; # Bank  65 VCCO - som240_2_a44 - IO_L9N_T1L_N5_AD12N_65
set_property -dict {PACKAGE_PIN K2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_p[1]]; # Bank  65 VCCO - som240_2_a44 - IO_L9P_T1L_N4_AD12P_65
set_property -dict {PACKAGE_PIN H1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_n[0]]; # Bank  65 VCCO - som240_2_a44 - IO_L8N_T1L_N3_AD5N_65
set_property -dict {PACKAGE_PIN J1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_data_p[0]]; # Bank  65 VCCO - som240_2_a44 - IO_L8P_T1L_N2_AD5P_65
set_property -dict {PACKAGE_PIN K1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_clk_n]; # Bank  65 VCCO - som240_2_a44 - IO_L7N_T1L_N1_QBC_AD13N_65
set_property -dict {PACKAGE_PIN L1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_1_clk_p]; # Bank  65 VCCO - som240_2_a44 - IO_L7P_T1L_N0_QBC_AD13P_65

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports mfp_3_p1] ;# Bank  43 VCCO - som240_2_b59 - IO_L7N_HDGC_AD5N_43
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS18} [get_ports mfp_2_p1] ;# Bank  43 VCCO - som240_2_b59 - IO_L11P_AD1P_43
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS18} [get_ports mfp_1_p1] ;# Bank  43 VCCO - som240_2_b59 - IO_L10N_AD2N_43
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS18} [get_ports mfp_0_p1] ;# Bank  43 VCCO - som240_2_b59 - IO_L10P_AD2P_43
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports mfp_3_p2] ;# Bank  43 VCCO - som240_2_b59 - IO_L8P_HDGC_AD4P_43
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS18} [get_ports mfp_2_p2] ;# Bank  43 VCCO - som240_2_b59 - IO_L12N_AD0N_43
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports mfp_1_p2] ;# Bank  43 VCCO - som240_2_b59 - IO_L12P_AD0P_43
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS18} [get_ports mfp_0_p2] ;# Bank  43 VCCO - som240_2_b59 - IO_L11N_AD1N_43

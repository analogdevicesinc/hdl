# constraints

## MIPIB0
set_property -dict {PACKAGE_PIN V8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_65
set_property -dict {PACKAGE_PIN U8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[1]]; # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_65
set_property -dict {PACKAGE_PIN V9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_n[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_65
set_property -dict {PACKAGE_PIN U9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_data_p[0]]; # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_65
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_n]; # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_65
set_property -dict {PACKAGE_PIN W8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi1_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_65

## MIPIB1
set_property -dict {PACKAGE_PIN J2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9N_T1L_N5_AD12N_65
set_property -dict {PACKAGE_PIN K2 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9P_T1L_N4_AD12P_65
set_property -dict {PACKAGE_PIN H1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8N_T1L_N3_AD5N_65
set_property -dict {PACKAGE_PIN J1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8P_T1L_N2_AD5P_65
set_property -dict {PACKAGE_PIN K1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L7N_T1L_N1_QBC_AD13N_65
set_property -dict {PACKAGE_PIN L1 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi2_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L7P_T1L_N0_QBC_AD13P_65

## MIPIB2
set_property -dict {PACKAGE_PIN N6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L15N_T2L_N5_AD11N_65
set_property -dict {PACKAGE_PIN N7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L15P_T2L_N4_AD11P_65
set_property -dict {PACKAGE_PIN L5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L14N_T2L_N3_GC_65
set_property -dict {PACKAGE_PIN M6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L14P_T2L_N2_GC_65
set_property -dict {PACKAGE_PIN L6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L13N_T2L_N1_GC_QBC_65
set_property -dict {PACKAGE_PIN L7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi3_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L13P_T2L_N0_GC_QBC_65

## MIPIB3
set_property -dict {PACKAGE_PIN K7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L22N_T3U_N7_DBC_AD0N_65
set_property -dict {PACKAGE_PIN K8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L22P_T3U_N6_DBC_AD0P_65
set_property -dict {PACKAGE_PIN H7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L21N_T3L_N5_AD8N_65
set_property -dict {PACKAGE_PIN J7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L21P_T3L_N4_AD8P_65
set_property -dict {PACKAGE_PIN J4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L19N_T3L_N1_DBC_AD9N_65
set_property -dict {PACKAGE_PIN J5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi4_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L19P_T3L_N0_DBC_AD9P_65

## MIPIC0
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L3N_T0L_N5_AD15N_64
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L3P_T0L_N4_AD15P_64
set_property -dict {PACKAGE_PIN AE8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L2N_T0L_N3_64
set_property -dict {PACKAGE_PIN AE9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L2P_T0L_N2_64
set_property -dict {PACKAGE_PIN AD9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L1N_T0L_N1_DBC_64
set_property -dict {PACKAGE_PIN AC9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi5_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L1P_T0L_N0_DBC_64

## MIPIC1
set_property -dict {PACKAGE_PIN AH7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9N_T1L_N5_AD12N_64
set_property -dict {PACKAGE_PIN AH8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L9P_T1L_N4_AD12P_64
set_property -dict {PACKAGE_PIN AG8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8N_T1L_N3_AD5N_64
set_property -dict {PACKAGE_PIN AF8 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L8P_T1L_N2_AD5P_64
set_property -dict {PACKAGE_PIN AH9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L7N_T1L_N1_QBC_AD13N_64
set_property -dict {PACKAGE_PIN AG9 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi6_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L7P_T1L_N0_QBC_AD13P_64

## MIPIC2
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L15N_T2L_N5_AD11N_64
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L15P_T2L_N4_AD11P_64
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L14N_T2L_N3_GC_64
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L14P_T2L_N2_GC_64
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L13N_T2L_N1_GC_QBC_64
set_property -dict {PACKAGE_PIN AD5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi7_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L13P_T2L_N0_GC_QBC_64

## MIPIC3
set_property -dict {PACKAGE_PIN AF3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_data_n[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L21N_T3L_N5_AD8N_64
set_property -dict {PACKAGE_PIN AE3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_data_p[1]];  # Bank 65 VCCO - som240_2_a44 - IO_L21P_T3L_N4_AD8P_64
set_property -dict {PACKAGE_PIN AH3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_data_n[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L20N_T3L_N3_AD1N_64
set_property -dict {PACKAGE_PIN AG3 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_data_p[0]];  # Bank 65 VCCO - som240_2_a44 - IO_L20P_T3L_N2_AD1P_64
set_property -dict {PACKAGE_PIN AH4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_clk_n];  # Bank 65 VCCO - som240_2_a44 - IO_L19N_T3L_N1_DBC_AD9N_64
set_property -dict {PACKAGE_PIN AG4 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_csi8_clk_p]; # Bank 65 VCCO - som240_2_a44 - IO_L19P_T3L_N0_DBC_AD9P_64

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design];

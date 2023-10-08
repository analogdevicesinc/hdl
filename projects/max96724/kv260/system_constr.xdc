# constraints

set_property  -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 4}  [get_ports rpi_en]; # Bank  45 VCCO - som240_1_b13 - IO_L11P_AD9P_45

set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33 PULLUP true} [get_ports iic_scl_io]; # Bank  45 VCCO - som240_1_b13 - IO_L5P_HDGC_45
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33 PULLUP true} [get_ports iic_sda_io]; # Bank  45 VCCO - som240_1_b13 - IO_L5N_HDGC_45

set_property -dict {PACKAGE_PIN F6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[1]]; # Bank  66 VCCO - som240_1_d1 - IO_L15N_T2L_N5_AD11N_66 (som240_1_a10)
set_property -dict {PACKAGE_PIN G6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[1]]; # Bank  66 VCCO - som240_1_d1 - IO_L15P_T2L_N4_AD11P_66 (som240_1_a9)
set_property -dict {PACKAGE_PIN D5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_n[0]]; # Bank  66 VCCO - som240_1_d1 - IO_L14N_T2L_N3_GC_66 (som240_1_b11)
set_property -dict {PACKAGE_PIN E5 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_data_p[0]]; # Bank  66 VCCO - som240_1_d1 - IO_L14P_T2L_N2_GC_66 (som240_1_b10)
set_property -dict {PACKAGE_PIN D6 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_clk_n]; # Bank  66 VCCO - som240_1_d1 - IO_L13N_T2L_N1_GC_QBC_66 (som240_1_c13)
set_property -dict {PACKAGE_PIN D7 IOSTANDARD MIPI_DPHY_DCI DIFF_TERM_ADV TERM_100} [get_ports mipi_phy_if_0_clk_p]; # Bank  66 VCCO - som240_1_d1 - IO_L13P_T2L_N0_GC_QBC_66 (som240_1_c12)


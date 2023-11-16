set_property -dict {PACKAGE_PIN AJ2 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[0]];
set_property -dict {PACKAGE_PIN AH2 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[0]];
set_property -dict {PACKAGE_PIN AH3 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[1]];
set_property -dict {PACKAGE_PIN AG3 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[1]];
set_property -dict {PACKAGE_PIN AJ4 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[2]];
set_property -dict {PACKAGE_PIN AH4 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[2]];
set_property -dict {PACKAGE_PIN AE1 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_n[3]];
set_property -dict {PACKAGE_PIN AE2 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_data_p[3]];
set_property -dict {PACKAGE_PIN AJ5 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_clk_n];
set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD MIPI_DPHY_DCI   DIFF_TERM_ADV TERM_100} [get_ports mipi_ch0_clk_p];

# RX bitslice pins
set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVCMOS12        DATA_RATE DDR}          [get_ports bg3_pin6_nc_0];
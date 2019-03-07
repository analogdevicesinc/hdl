
# constraints (pzsdr2.e)
# ad9361

set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVDS DIFF_TERM 1} [get_ports rx_clk_in_p]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVDS DIFF_TERM 1} [get_ports rx_clk_in_n]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVDS DIFF_TERM 1} [get_ports rx_frame_in_p]
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVDS DIFF_TERM 1} [get_ports rx_frame_in_n]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[0]}]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[0]}]
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[1]}]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[1]}]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[2]}]
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[2]}]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[3]}]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[3]}]
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[4]}]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[4]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_p[5]}]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS DIFF_TERM 1} [get_ports {rx_data_in_n[5]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVDS} [get_ports tx_clk_out_p]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVDS} [get_ports tx_clk_out_n]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVDS} [get_ports tx_frame_out_p]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVDS} [get_ports tx_frame_out_n]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVDS} [get_ports {tx_data_out_p[0]}]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVDS} [get_ports {tx_data_out_n[0]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS} [get_ports {tx_data_out_p[1]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS} [get_ports {tx_data_out_n[1]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS} [get_ports {tx_data_out_p[2]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS} [get_ports {tx_data_out_n[2]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS} [get_ports {tx_data_out_p[3]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVDS} [get_ports {tx_data_out_n[3]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS} [get_ports {tx_data_out_p[4]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVDS} [get_ports {tx_data_out_n[4]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS} [get_ports {tx_data_out_p[5]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVDS} [get_ports {tx_data_out_n[5]}]

# clocks

create_clock -period 4.000 -name rx_clk [get_ports rx_clk_in_p]
create_clock -period 4.000 -name ad9361_clk [get_pins i_system_wrapper/system_i/axi_ad9361/clk]



set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS18} [get_ports rx_clk_in]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS18} [get_ports rx_frame_in]
set_property -dict {PACKAGE_PIN E12 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[0]}]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[1]}]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[2]}]
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[3]}]
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[4]}]
set_property -dict {PACKAGE_PIN G10 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[5]}]
set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[6]}]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[7]}]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[8]}]
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[9]}]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[10]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS18} [get_ports {rx_data_in[11]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS18} [get_ports tx_clk_out]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports tx_frame_out]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[0]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[1]}]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[2]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[3]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[4]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[5]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[6]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[7]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[8]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[9]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[10]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS18} [get_ports {tx_data_out[11]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS18} [get_ports {tx_gnd[0]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS18} [get_ports {tx_gnd[1]}]
###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints (pzsdr2.e)
# ad9361 (SWAP == 0x1)




# clocks

create_clock -period 8.000 -name rx_clk [get_ports rx_clk_in]

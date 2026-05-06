###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# RX/TX pins

# TX - 8 pairs of differential signals
set_property PACKAGE_PIN AE7 [get_ports pcie_tx_n[0]]; # PCIE_TX0_N K14 MGTHTXN3_225
set_property PACKAGE_PIN AE8 [get_ports pcie_tx_p[0]]; # PCIE_TX0_P K15 MGTHTXP3_225

set_property PACKAGE_PIN AF5 [get_ports pcie_tx_n[1]]; # PCIE_TX1_N J12 MGTHTXN2_225
set_property PACKAGE_PIN AF6 [get_ports pcie_tx_p[1]]; # PCIE_TX1_P J13 MGTHTXP2_225

set_property PACKAGE_PIN AG7 [get_ports pcie_tx_n[2]]; # PCIE_TX2_N G12 MGTHTXN1_225
set_property PACKAGE_PIN AG8 [get_ports pcie_tx_p[2]]; # PCIE_TX2_P G13 MGTHTXP1_225

set_property PACKAGE_PIN AH5 [get_ports pcie_tx_n[3]]; # PCIE_TX3_N K10 MGTHTXN0_225
set_property PACKAGE_PIN AH6 [get_ports pcie_tx_p[3]]; # PCIE_TX3_P K11 MGTHTXP0_225

set_property PACKAGE_PIN AJ7 [get_ports pcie_tx_n[4]]; # PCIE_TX4_N J8 MGTHTXN3_224
set_property PACKAGE_PIN AJ8 [get_ports pcie_tx_p[4]]; # PCIE_TX4_P J9 MGTHTXP3_224

set_property PACKAGE_PIN AK5 [get_ports pcie_tx_n[5]]; # PCIE_TX5_N G8 MGTHTXN2_224
set_property PACKAGE_PIN AK6 [get_ports pcie_tx_p[5]]; # PCIE_TX5_P G9 MGTHTXP2_224

set_property PACKAGE_PIN AL7 [get_ports pcie_tx_n[6]]; # PCIE_TX6_N K6 MGTHTXN1_224
set_property PACKAGE_PIN AL8 [get_ports pcie_tx_p[6]]; # PCIE_TX6_P K7 MGTHTXP1_224

set_property PACKAGE_PIN AM5 [get_ports pcie_tx_n[7]]; # PCIE_TX7_N J4 MGTHTXN0_224
set_property PACKAGE_PIN AM6 [get_ports pcie_tx_p[7]]; # PCIE_TX7_P J5 MGTHTXP0_224

# RX - 8 pairs of differential signals
set_property PACKAGE_PIN AE3 [get_ports pcie_rx_n[0]]; # PCIE_RX0_N F14 MGTHRXN3_225
set_property PACKAGE_PIN AE4 [get_ports pcie_rx_p[0]]; # PCIE_RX0_P F15 MGTHRXP3_225

set_property PACKAGE_PIN AF1 [get_ports pcie_rx_n[1]]; # PCIE_RX1_N E12 MGTHRXN2_225
set_property PACKAGE_PIN AF2 [get_ports pcie_rx_p[1]]; # PCIE_RX1_P E13 MGTHRXP2_225

set_property PACKAGE_PIN AG3 [get_ports pcie_rx_n[2]]; # PCIE_RX2_N H10 MGTHRXN1_225
set_property PACKAGE_PIN AG4 [get_ports pcie_rx_p[2]]; # PCIE_RX2_P H11 MGTHRXP1_225

set_property PACKAGE_PIN AH1 [get_ports pcie_rx_n[3]]; # PCIE_RX3_N F10 MGTHRXN0_225
set_property PACKAGE_PIN AH2 [get_ports pcie_rx_p[3]]; # PCIE_RX3_P F11 MGTHRXP0_225

set_property PACKAGE_PIN AJ3 [get_ports pcie_rx_n[4]]; # PCIE_RX4_N E8 MGTHRXN3_224
set_property PACKAGE_PIN AJ4 [get_ports pcie_rx_p[4]]; # PCIE_RX4_P E9 MGTHRXP3_224

set_property PACKAGE_PIN AK1 [get_ports pcie_rx_n[5]]; # PCIE_RX5_N H6 MGTHRXN2_224
set_property PACKAGE_PIN AK2 [get_ports pcie_rx_p[5]]; # PCIE_RX5_P H7 MGTHRXP2_224

set_property PACKAGE_PIN AL3 [get_ports pcie_rx_n[6]]; # PCIE_RX6_N F6 MGTHRXN1_224
set_property PACKAGE_PIN AL4 [get_ports pcie_rx_p[6]]; # PCIE_RX6_P F7 MGTHRXP1_224

set_property PACKAGE_PIN AM1 [get_ports pcie_rx_n[7]]; # PCIE_RX7_N G4 MGTHRXN0_224
set_property PACKAGE_PIN AM2 [get_ports pcie_rx_p[7]]; # PCIE_RX7_P G5 MGTHRXP0_224

# CLK
set_property PACKAGE_PIN AH9  [get_ports pcie_clk_n]; # PCIE_CLK_QO_N K2 MGTREFCLK0N_224
set_property PACKAGE_PIN AH10 [get_ports pcie_clk_p]; # PCIE_CLK_QO_P K3 MGTREFCLK0P_224

# RSTN
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS18 PULLUP true} [get_ports pcie_perstn]; #PCIE_PERST H2 IO_T3U_N12_PERSTN0_65

# Reference clock of 100 MHz
create_clock -name pcie_ref_clk -period 10.00 [get_ports pcie_clk_p]

# PERST is asynchronous
set_false_path -from [get_ports pcie_perstn]
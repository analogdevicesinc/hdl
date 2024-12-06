###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# U145 QSFP+ Module
set_property -dict  {PACKAGE_PIN  L5} [get_ports qsfp_tx_p[0]]
set_property -dict  {PACKAGE_PIN  L4} [get_ports qsfp_tx_n[0]]
set_property -dict  {PACKAGE_PIN  T2} [get_ports qsfp_rx_p[0]]
set_property -dict  {PACKAGE_PIN  T1} [get_ports qsfp_rx_n[0]]

set_property -dict  {PACKAGE_PIN  K7} [get_ports qsfp_tx_p[1]]
set_property -dict  {PACKAGE_PIN  K6} [get_ports qsfp_tx_n[1]]
set_property -dict  {PACKAGE_PIN  R4} [get_ports qsfp_rx_p[1]]
set_property -dict  {PACKAGE_PIN  R3} [get_ports qsfp_rx_n[1]]

set_property -dict  {PACKAGE_PIN  J5} [get_ports qsfp_tx_p[2]]
set_property -dict  {PACKAGE_PIN  J4} [get_ports qsfp_tx_n[2]]
set_property -dict  {PACKAGE_PIN  P2} [get_ports qsfp_rx_p[2]]
set_property -dict  {PACKAGE_PIN  P1} [get_ports qsfp_rx_n[2]]

set_property -dict  {PACKAGE_PIN  H7} [get_ports qsfp_tx_p[3]]
set_property -dict  {PACKAGE_PIN  H6} [get_ports qsfp_tx_n[3]]
set_property -dict  {PACKAGE_PIN  M2} [get_ports qsfp_rx_p[3]]
set_property -dict  {PACKAGE_PIN  M1} [get_ports qsfp_rx_n[3]]

# REF clock
set_property -dict  {PACKAGE_PIN  R9} [get_ports qsfp_mgt_refclk_p]
set_property -dict  {PACKAGE_PIN  R8} [get_ports qsfp_mgt_refclk_n]

set_property -dict {LOC AM21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell]
set_property -dict {LOC BA22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl]
set_property -dict {LOC AL21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_modprsl]
set_property -dict {LOC AP21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_intl]
set_property -dict {LOC AN21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode]

# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name qsfp_mgt_refclk_0 [get_ports qsfp_mgt_refclk_0_p]

set_false_path -to [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_output_delay 0 [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_false_path -from [get_ports {qsfp_modprsl qsfp_intl}]
set_input_delay 0 [get_ports {qsfp_modprsl qsfp_intl}]

# QSPI flash
set_property -dict {LOC AM19 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[0]}]
set_property -dict {LOC AM18 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[1]}]
set_property -dict {LOC AN20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[2]}]
set_property -dict {LOC AP20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[3]}]
set_property -dict {LOC BF16 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_cs}]

set_false_path -to [get_ports {qspi1_dq[*] qspi1_cs}]
set_output_delay 0 [get_ports {qspi1_dq[*] qspi1_cs}]
set_false_path -from [get_ports {qspi1_dq}]
set_input_delay 0 [get_ports {qspi1_dq}]

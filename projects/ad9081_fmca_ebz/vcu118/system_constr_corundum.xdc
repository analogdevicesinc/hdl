###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# U145 QSFP+ Module QSFP1
# set_property -dict {PACKAGE_PIN Y2} [get_ports {qsfp_rx_p[0]}]
# set_property -dict {PACKAGE_PIN Y1} [get_ports {qsfp_rx_n[0]}]
# set_property -dict {PACKAGE_PIN V7} [get_ports {qsfp_tx_p[0]}]
# set_property -dict {PACKAGE_PIN V6} [get_ports {qsfp_tx_n[0]}]
# set_property -dict {PACKAGE_PIN W4} [get_ports {qsfp_rx_p[1]}]
# set_property -dict {PACKAGE_PIN W3} [get_ports {qsfp_rx_n[1]}]
# set_property -dict {PACKAGE_PIN T7} [get_ports {qsfp_tx_p[1]}]
# set_property -dict {PACKAGE_PIN T6} [get_ports {qsfp_tx_n[1]}]
# set_property -dict {PACKAGE_PIN V2} [get_ports {qsfp_rx_p[2]}]
# set_property -dict {PACKAGE_PIN V1} [get_ports {qsfp_rx_n[2]}]
# set_property -dict {PACKAGE_PIN P7} [get_ports {qsfp_tx_p[2]}]
# set_property -dict {PACKAGE_PIN P6} [get_ports {qsfp_tx_n[2]}]
# set_property -dict {PACKAGE_PIN U4} [get_ports {qsfp_rx_p[3]}]
# set_property -dict {PACKAGE_PIN U3} [get_ports {qsfp_rx_n[3]}]
# set_property -dict {PACKAGE_PIN M7} [get_ports {qsfp_tx_p[3]}]
# set_property -dict {PACKAGE_PIN M6} [get_ports {qsfp_tx_n[3]}]

# set_property -dict {PACKAGE_PIN AN23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell]
# set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl]
# set_property -dict {PACKAGE_PIN AT24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode]
# set_property -dict {PACKAGE_PIN AN24 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_modprsl]
# set_property -dict {PACKAGE_PIN AT21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_intl]

# U145 QSFP+ Module QSFP2
set_property -dict {PACKAGE_PIN T2} [get_ports {qsfp_rx_p[0]}]
set_property -dict {PACKAGE_PIN T1} [get_ports {qsfp_rx_n[0]}]
set_property -dict {PACKAGE_PIN L5} [get_ports {qsfp_tx_p[0]}]
set_property -dict {PACKAGE_PIN L4} [get_ports {qsfp_tx_n[0]}]
set_property -dict {PACKAGE_PIN R4} [get_ports {qsfp_rx_p[1]}]
set_property -dict {PACKAGE_PIN R3} [get_ports {qsfp_rx_n[1]}]
set_property -dict {PACKAGE_PIN K7} [get_ports {qsfp_tx_p[1]}]
set_property -dict {PACKAGE_PIN K6} [get_ports {qsfp_tx_n[1]}]
set_property -dict {PACKAGE_PIN P2} [get_ports {qsfp_rx_p[2]}]
set_property -dict {PACKAGE_PIN P1} [get_ports {qsfp_rx_n[2]}]
set_property -dict {PACKAGE_PIN J5} [get_ports {qsfp_tx_p[2]}]
set_property -dict {PACKAGE_PIN J4} [get_ports {qsfp_tx_n[2]}]
set_property -dict {PACKAGE_PIN M2} [get_ports {qsfp_rx_p[3]}]
set_property -dict {PACKAGE_PIN M1} [get_ports {qsfp_rx_n[3]}]
set_property -dict {PACKAGE_PIN H7} [get_ports {qsfp_tx_p[3]}]
set_property -dict {PACKAGE_PIN H6} [get_ports {qsfp_tx_n[3]}]

set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell]
set_property -dict {PACKAGE_PIN BA22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl]
set_property -dict {PACKAGE_PIN AN21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode]
set_property -dict {PACKAGE_PIN AL21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_modprsl]
set_property -dict {PACKAGE_PIN AP21 IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports qsfp_intl]

# REF clock
set_property -dict {PACKAGE_PIN W9} [get_ports qsfp_mgt_refclk_p]
set_property -dict {PACKAGE_PIN W8} [get_ports qsfp_mgt_refclk_n]

# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name qsfp_mgt_refclk [get_ports qsfp_mgt_refclk_p]

set_false_path -to [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_output_delay 0.000 [get_ports {qsfp_modsell qsfp_resetl qsfp_lpmode}]
set_false_path -from [get_ports {qsfp_modprsl qsfp_intl}]
set_input_delay 0.000 [get_ports {qsfp_modprsl qsfp_intl}]

# QSPI flash
set_property -dict {PACKAGE_PIN AM19 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[0]}]
set_property -dict {PACKAGE_PIN AM18 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[1]}]
set_property -dict {PACKAGE_PIN AN20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[2]}]
set_property -dict {PACKAGE_PIN AP20 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports {qspi1_dq[3]}]
set_property -dict {PACKAGE_PIN BF16 IOSTANDARD LVCMOS18 DRIVE 12} [get_ports qspi1_cs]

set_false_path -to [get_ports {{qspi1_dq[*]} qspi1_cs}]
set_output_delay 0.000 [get_ports {{qspi1_dq[*]} qspi1_cs}]
set_false_path -from [get_ports qspi1_dq]
set_input_delay 0.000 [get_ports qspi1_dq]

set_property LOC CMACE4_X0Y7 [get_cells -hierarchical -filter {NAME =~ */qsfp[0].qsfp_cmac_inst/cmac_inst/inst/i_cmac_usplus_top/* && REF_NAME==CMACE4}]

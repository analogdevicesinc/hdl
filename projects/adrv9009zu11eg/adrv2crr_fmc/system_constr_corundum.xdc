###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN  AJ16 IOSTANDARD LVCMOS18} [get_ports qsfp_led[0]] ;
set_property -dict {PACKAGE_PIN  AH16 IOSTANDARD LVCMOS18} [get_ports qsfp_led[1]] ;
set_property -dict {PACKAGE_PIN  AJ12 IOSTANDARD LVCMOS18} [get_ports qsfp_led[2]] ;
set_property -dict {PACKAGE_PIN  AK12 IOSTANDARD LVCMOS18} [get_ports qsfp_led[3]] ;

set_property -dict {PACKAGE_PIN  AU11 IOSTANDARD LVCMOS18 } [get_ports qsfp_resetl  ] ;
set_property -dict {PACKAGE_PIN  AL12 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_modprsl ] ;
set_property -dict {PACKAGE_PIN  AW14 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_intl    ] ;
set_property -dict {PACKAGE_PIN  AV11 IOSTANDARD LVCMOS18 } [get_ports qsfp_lpmode  ] ;


set_property PACKAGE_PIN AD2   [get_ports qsfp_rx_p[0] ] ;
set_property PACKAGE_PIN AD1   [get_ports qsfp_rx_n[0] ] ;

set_property PACKAGE_PIN AC4   [get_ports qsfp_rx_p[1] ] ;
set_property PACKAGE_PIN AC3   [get_ports qsfp_rx_n[1] ] ;

set_property PACKAGE_PIN AB2   [get_ports qsfp_rx_p[2] ] ;
set_property PACKAGE_PIN AB1   [get_ports qsfp_rx_n[2] ] ;

set_property PACKAGE_PIN AA4   [get_ports qsfp_rx_p[3] ] ;
set_property PACKAGE_PIN AA3   [get_ports qsfp_rx_n[3] ] ;

set_property PACKAGE_PIN AD6   [get_ports qsfp_tx_p[0] ] ;
set_property PACKAGE_PIN AD5   [get_ports qsfp_tx_n[0] ] ;

set_property PACKAGE_PIN AC8   [get_ports qsfp_tx_p[1] ] ;
set_property PACKAGE_PIN AC7   [get_ports qsfp_tx_n[1] ] ;

set_property PACKAGE_PIN AB6   [get_ports qsfp_tx_p[2] ] ;
set_property PACKAGE_PIN AB5   [get_ports qsfp_tx_n[2] ] ;

set_property PACKAGE_PIN AA8   [get_ports qsfp_tx_p[3] ] ;
set_property PACKAGE_PIN AA7   [get_ports qsfp_tx_n[3] ] ;

set_property PACKAGE_PIN AD10  [get_ports qsfp_mgt_refclk_p ] ;
set_property PACKAGE_PIN AD9   [get_ports qsfp_mgt_refclk_n ] ;


# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name gt_ref_clk [get_ports qsfp_mgt_refclk_p]
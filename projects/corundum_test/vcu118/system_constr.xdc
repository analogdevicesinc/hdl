###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# U145 QSFP+ Module
set_property -dict {LOC Y2  } [get_ports {qsfp_rx_p[0]}] ;# MGTYRXP0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC Y1  } [get_ports {qsfp_rx_n[0]}] ;# MGTYRXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V7  } [get_ports {qsfp_tx_p[0]}] ;# MGTYTXP0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V6  } [get_ports {qsfp_tx_n[0]}] ;# MGTYTXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC W4  } [get_ports {qsfp_rx_p[1]}] ;# MGTYRXP1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC W3  } [get_ports {qsfp_rx_n[1]}] ;# MGTYRXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC T7  } [get_ports {qsfp_tx_p[1]}] ;# MGTYTXP1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC T6  } [get_ports {qsfp_tx_n[1]}] ;# MGTYTXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V2  } [get_ports {qsfp_rx_p[2]}] ;# MGTYRXP2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC V1  } [get_ports {qsfp_rx_n[2]}] ;# MGTYRXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC P7  } [get_ports {qsfp_tx_p[2]}] ;# MGTYTXP2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC P6  } [get_ports {qsfp_tx_n[2]}] ;# MGTYTXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC U4  } [get_ports {qsfp_rx_p[3]}] ;# MGTYRXP3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC U3  } [get_ports {qsfp_rx_n[3]}] ;# MGTYRXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M7  } [get_ports {qsfp_tx_p[3]}] ;# MGTYTXP3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M6  } [get_ports {qsfp_tx_n[3]}] ;# MGTYTXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12

# REF clock
set_property -dict {LOC W9  } [get_ports qsfp_mgt_refclk_p] ;# MGTREFCLK0P_231 from U38.4
set_property -dict {LOC W8  } [get_ports qsfp_mgt_refclk_n] ;# MGTREFCLK0N_231 from U38.5

set_property -dict {LOC AM21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_modsell]
set_property -dict {LOC BA22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_resetl]
set_property -dict {LOC AL21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_modprsl]
set_property -dict {LOC AP21 IOSTANDARD LVCMOS18 PULLUP true} [get_ports qsfp_intl]
set_property -dict {LOC AN21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports qsfp_lpmode]

# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name qsfp_mgt_refclk [get_ports qsfp_mgt_refclk_p]

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

# CMACs
set_property LOC CMACE4_X0Y7 [get_cells -hierarchical -filter {NAME =~ qsfp1_cmac_inst/cmac_inst/inst/i_cmac_usplus_top/* && REF_NAME==CMACE4}]

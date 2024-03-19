###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

if {![info exists RESOLUTION_16_18N]} {
  set RESOLUTION_16_18N $::env(RESOLUTION_16_18N)
}

# clocks

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports ref_clk_p]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports ref_clk_n]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25} [get_ports clk_p]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25} [get_ports clk_n]

# cnv

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25} [get_ports cnv_p]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25} [get_ports cnv_n]

# dco, da

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d_p]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d_n]

# control signals
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports en0_fmc]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports en1_fmc]

switch $RESOLUTION_16_18N {
  0 {

    set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports en2_fmc]
    set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports en3_fmc]
  }
  1 {

    set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpga_pll_cnv_p]
    set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpga_pll_cnv_n]

    set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports pll_sync_fmc]
  }
}

# 166.66 MHz clock

create_clock -period 6.000 -name dco       [get_ports dco_p]
create_clock -period 6.000 -name out_clock [get_ports clk_p]

set input_clock         dco;      # Name of input clock
set input_clock_period  6.000;    # Period of input clock
set dv_bre              2.000;    # Data valid before the rising clock edge
set dv_are              2.000;    # Data valid after the rising clock edge
set input_ports         d_p;      # List of input ports

# Input Delay Constraint
set_input_delay -clock $input_clock -max [expr $input_clock_period - $dv_bre] [get_ports $input_ports];
set_input_delay -clock $input_clock -min $dv_are                              [get_ports $input_ports];

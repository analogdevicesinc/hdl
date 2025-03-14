###############################################################################
## Copyright (C) 2022-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25} [get_ports clk_p];             ## G06 FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25} [get_ports clk_n];             ## G07 FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25} [get_ports cnv_p];             ## D08 FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25} [get_ports cnv_n];             ## D09 FMC_LPC_LA01_CC_N

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]; ## H04 FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]; ## H05 FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d_p];   ## H07 FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d_n];   ## H08 FMC_LPC_LA02_N

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports en0_fmc];          ## G09 FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports en1_fmc];          ## G10 FMC_LPC_LA03_N

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

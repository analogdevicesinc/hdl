###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad7960_fmcz
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
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports en2_fmc]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports en3_fmc]

# 120MHz clock

create_clock -period 8.000 -name dco       [get_ports dco_p]
create_clock -period 8.000 -name out_clock [get_ports clk_p]

# Input Delay Constraint

set_input_delay -clock [get_clocks dco] -clock_fall -max  1.000 [get_ports d_p]
set_input_delay -clock [get_clocks dco] -clock_fall -min -1.000 [get_ports d_p]

# clock uncertainty

set_clock_uncertainty -setup -from [get_clocks out_clock] -to [get_clocks dco] 5.000

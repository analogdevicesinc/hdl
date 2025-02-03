###############################################################################
## Copyright (C) 2018-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports adc_clk]  ; ## G6  FMC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports adc_data] ; ## G7  FMC_LA00_CC_N

set input_clock mmcm_clk_0_s
set input_clock_period  20.000;    # Period of input clock
set dv_bre              10.000;    # Data valid before the rising clock edge
set dv_are              3.000
set input_ports adc_data
set_input_delay -clock $input_clock -max [expr $input_clock_period - $dv_bre] [get_ports $input_ports];
set_input_delay -clock $input_clock -min $dv_are                              [get_ports $input_ports];

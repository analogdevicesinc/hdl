###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVDS_25} [get_ports adc_clk_p]  ; ## G6  FMC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVDS_25} [get_ports adc_clk_n]  ; ## G7  FMC_LA00_CC_N
set_property -dict {PACKAGE_PIN N19  IOSTANDARD LVDS_25} [get_ports adc_data_p] ; ## D8  FMC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20  IOSTANDARD LVDS_25} [get_ports adc_data_n] ; ## D9  FMC_LA01_CC_N

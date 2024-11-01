###############################################################################
## Copyright (C) 2018-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25} [get_ports adc_clk]  ; ## G6  FMC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25} [get_ports adc_data] ; ## G7  FMC_LA00_CC_N

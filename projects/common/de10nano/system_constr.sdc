###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

create_clock -period "20.000 ns"  -name sys_clk_50mhz      [get_ports {sys_clk}]
create_clock -period "16.666 ns"  -name usb_clk_60mhz      [get_ports {usb1_clk}]

derive_pll_clocks
derive_clock_uncertainty

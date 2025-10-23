###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9740 clk interface
set_property -dict {PACKAGE_PIN L18 IOSTANDARD TMDS_33} [get_ports ad9740_clk_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD TMDS_33} [get_ports ad9740_clk_n]

# ad9744 interface
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[13]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[12]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[11]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[10]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[9]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[8]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[7]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[6]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[5]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[4]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[3]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[2]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[1]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports {ad9740_data[0]}]

# adf4351 interface
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports adf4351_csn]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports adf4351_clk]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports adf4351_mosi]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports adf4351_ce]

# clocks
create_clock -period 4.761 -name ad9740_clk [get_ports ad9740_clk_p]
set_input_delay -clock [get_clocks ad9740_clk] 5.000 [get_ports ad9740_clk_p]


# REMOVE THIS LINE - Don't set input_delay on clock ports:
# set_input_delay -clock [get_clocks ad9740_clk] 5.000 [get_ports ad9740_clk_p]

# ADD: Output delay constraints for data pins
# AD9740 datasheet specs: tDS (setup) = 1.5ns, tDH (hold) = 0.5ns

##  set_output_delay -clock ad9740_clk -max 1.5 [get_ports ad9740_data[*]]
##  set_output_delay -clock ad9740_clk -min -0.5 [get_ports ad9740_data[*]]

# Optional: If you want to model clock output delay
##  set_output_delay -clock ad9740_clk -max 1.5 [get_ports ad9740_clk_p]
##  set_output_delay -clock ad9740_clk -min -0.5 [get_ports ad9740_clk_p]






# Reconfigure the pins from Bank 34 and Bank 35 to use LVCMOS33 since VADJ must be set to 3.3V

# otg

# gpio (switches, leds and such)






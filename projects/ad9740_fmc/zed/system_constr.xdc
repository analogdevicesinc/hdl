###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9740 clk interface
set_property -dict {PACKAGE_PIN L18 IOSTANDARD TMDS_33} [get_ports ad9740_clk_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD TMDS_33} [get_ports ad9740_clk_n]

# ad9740 data interface
# Force IOB placement with FAST slew rate for output registers
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[13]}]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[12]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[11]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[10]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[9]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[8]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[7]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[6]}]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[5]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[4]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[3]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[2]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[1]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports {ad9740_data[0]}]

# adf4351 interface
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports adf4351_csn]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports adf4351_clk]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports adf4351_mosi]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports adf4351_ce]

# clocks
create_clock -period 4.761 -name ad9740_clk [get_ports ad9740_clk_p]

# Output delay constraints for data pins
# AD9744 datasheet specs (Table 3, Page 5): tS (setup) = 2.0ns, tH (hold) = 1.5ns
set_output_delay -clock ad9740_clk -max 2.0 [get_ports ad9740_data[*]]
set_output_delay -clock ad9740_clk -min -1.5 [get_ports ad9740_data[*]]

# Multicycle path constraint
# Due to the clock architecture where AD9744 receives clock directly from ADF4351 while
# FPGA sees the same clock after IBUFDS+BUFG delays (~5.1ns), the data path takes longer
# than one clock period. Data arrives at ~8.6ns but needs to be sampled at edge 2 (~9.5ns).
# Allow 3 cycles for setup to ensure positive slack
set_multicycle_path -setup 3 -to [get_ports ad9740_data[*]]
set_multicycle_path -hold 2 -to [get_ports ad9740_data[*]]

# Note: IOB placement is enforced via (* IOB = "TRUE" *) attribute in axi_ad974x_channel.v
# This ensures dac_data registers are packed into IOBs for minimal routing delay






# Reconfigure the pins from Bank 34 and Bank 35 to use LVCMOS33 since VADJ must be set to 3.3V

# otg

# gpio (switches, leds and such)






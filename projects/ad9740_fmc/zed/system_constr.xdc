###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9740 clk interface
set_property -dict {PACKAGE_PIN L18 IOSTANDARD TMDS_33} [get_ports ad9740_clk_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD TMDS_33} [get_ports ad9740_clk_n]

# adf4351 interface
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports adf4351_csn]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports adf4351_clk]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports adf4351_mosi]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports adf4351_ce]

# clocks
create_clock -period 4.761 -name ad9740_clk [get_ports ad9740_clk_p]

# Output delay constraints for data pins
# AD9744 datasheet specs (Table 3, Page 5): tS (setup) = 2.0ns, tH (hold) = 1.5ns
set_output_delay -clock ad9740_clk -max 2.000 [get_ports {ad9740_data[*]}]
set_output_delay -clock ad9740_clk -min -1.500 [get_ports {ad9740_data[*]}]

# Multicycle path constraint
# Due to the clock architecture where AD9744 receives clock directly from ADF4351 while
# FPGA sees the same clock after IBUFDS+BUFG delays (~5.1ns), the data path takes longer
# than one clock period. Data arrives at ~8.6ns but needs to be sampled at edge 2 (~9.5ns).
# Allow 3 cycles for setup to ensure positive slack
set_multicycle_path -setup -to [get_ports {ad9740_data[*]}] 3
set_multicycle_path -hold -to [get_ports {ad9740_data[*]}] 2


###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
# hdmi

set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports hdmi_out_clk]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_vsync]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_hsync]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data_e]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[0]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[1]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[2]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[3]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[4]}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[5]}]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[6]}]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[7]}]
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[8]}]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[9]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[10]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[11]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[12]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[13]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[14]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {hdmi_data[15]}]

# spdif

set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports spdif]

# i2s

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports i2s_sdata_out]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports i2s_sdata_in]

# iic

set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property PACKAGE_PIN AA18 [get_ports {iic_mux_scl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[1]}]
set_property PACKAGE_PIN Y16 [get_ports {iic_mux_sda[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[1]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[1]}]
set_property PACKAGE_PIN AB4 [get_ports {iic_mux_scl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_scl[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_scl[0]}]
set_property PACKAGE_PIN AB5 [get_ports {iic_mux_sda[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_mux_sda[0]}]
set_property PULLTYPE PULLUP [get_ports {iic_mux_sda[0]}]

# otg

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[1]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[2]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[3]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[4]}]
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[5]}]
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[6]}]
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[7]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[8]}]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[9]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[10]}]
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[11]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[12]}]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[13]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[14]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[15]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[16]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[17]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[18]}]
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[19]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[20]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[21]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[22]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[23]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[24]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_a[25]}]

set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports led]

set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_b[0]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_b[1]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_b[2]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_b[3]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {gpio_bd_b[4]}]

# Define SPI clock
create_clock -period 40.000 -name spi0_clk [get_pins -hier */EMIOSPI0SCLKO]
create_clock -period 40.000 -name spi1_clk [get_pins -hier */EMIOSPI1SCLKO]




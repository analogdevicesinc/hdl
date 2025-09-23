###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9740 clk interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD TMDS_33} [get_ports ad9740_clk_p]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD TMDS_33} [get_ports ad9740_clk_n]

# adf4351 interface

set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports adf4351_ce]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports adf4351_clk]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports adf4351_csn]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports adf4351_mosi]

# ad9740 data interface

set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[0]]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[1]]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[2]]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[3]]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[4]]
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[5]]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[6]]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[7]]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[8]]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[9]]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[10]]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[11]]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[12]]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33 IOB TRUE SLEW FAST DRIVE 12} [get_ports ad9740_data[13]]

# clocks

create_clock -period 4.761 -name ad9740_clk [get_ports ad9740_clk_p]

# Output delay constraints for data pins
# AD9744 datasheet specs (Table 3, Page 5): tS (setup) = 2.0ns, tH (hold) = 1.5ns

set_output_delay -clock ad9740_clk -max 2.000 [get_ports ad9740_data[*]]
set_output_delay -clock ad9740_clk -min -1.500 [get_ports ad9740_data[*]]

# Multicycle path constraint
# Due to the clock architecture where AD9744 receives clock directly from ADF4351 while
# FPGA sees the same clock after IBUFDS+BUFG delays (~5.1ns), the data path takes longer
# than one clock period. Data arrives at ~8.6ns but needs to be sampled at edge 2 (~9.5ns).
# Allow 3 cycles for setup to ensure positive slack

set_multicycle_path -setup -to [get_ports ad9740_data[*]] 3
set_multicycle_path -hold -to [get_ports ad9740_data[*]] 2

# hdmi

set_property -dict {PACKAGE_PIN W18  IOSTANDARD LVCMOS33	 } [get_ports hdmi_out_clk]
set_property -dict {PACKAGE_PIN W17  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_vsync]
set_property -dict {PACKAGE_PIN V17  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_hsync]
set_property -dict {PACKAGE_PIN U16  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data_e]
set_property -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[0]]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[1]]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[2]]
set_property -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[3]]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[4]]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[5]]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[6]]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[7]]
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[8]]
set_property -dict {PACKAGE_PIN Y15  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[9]]
set_property -dict {PACKAGE_PIN W13  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[10]]
set_property -dict {PACKAGE_PIN W15  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[11]]
set_property -dict {PACKAGE_PIN V15  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[12]]
set_property -dict {PACKAGE_PIN U17  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[13]]
set_property -dict {PACKAGE_PIN V14  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[14]]
set_property -dict {PACKAGE_PIN V13  IOSTANDARD LVCMOS33 IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports spdif]

# i2s

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN Y6  IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN Y8  IOSTANDARD LVCMOS33} [get_ports i2s_sdata_out]
set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS33} [get_ports i2s_sdata_in]

# iic

set_property -dict {PACKAGE_PIN R7   IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property -dict {PACKAGE_PIN U7   IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[1]]
set_property -dict {PACKAGE_PIN Y16  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[1]]
set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[0]]
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[0]]

# otg

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property -dict {PACKAGE_PIN P16  IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]  ; ## BTNC
set_property -dict {PACKAGE_PIN R16  IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]  ; ## BTND
set_property -dict {PACKAGE_PIN N15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]  ; ## BTNL
set_property -dict {PACKAGE_PIN R18  IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]  ; ## BTNR
set_property -dict {PACKAGE_PIN T18  IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]  ; ## BTNU
set_property -dict {PACKAGE_PIN U10  IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]  ; ## OLED-DC
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]   ; ## OLED-RES
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]] ; ## OLED-SCLK
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]] ; ## OLED-SDIN
set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]  ; ## OLED-VBAT
set_property -dict {PACKAGE_PIN U12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]] ; ## OLED-VDD

set_property -dict {PACKAGE_PIN F22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[11]] ; ## SW0
set_property -dict {PACKAGE_PIN G22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[12]] ; ## SW1
set_property -dict {PACKAGE_PIN H22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[13]] ; ## SW2
set_property -dict {PACKAGE_PIN F21  IOSTANDARD LVCMOS33} [get_ports gpio_bd[14]] ; ## SW3
set_property -dict {PACKAGE_PIN H19  IOSTANDARD LVCMOS33} [get_ports gpio_bd[15]] ; ## SW4
set_property -dict {PACKAGE_PIN H18  IOSTANDARD LVCMOS33} [get_ports gpio_bd[16]] ; ## SW5
set_property -dict {PACKAGE_PIN H17  IOSTANDARD LVCMOS33} [get_ports gpio_bd[17]] ; ## SW6
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[18]] ; ## SW7

set_property -dict {PACKAGE_PIN T22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]] ; ## LD0
set_property -dict {PACKAGE_PIN T21  IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]] ; ## LD1
set_property -dict {PACKAGE_PIN U22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]] ; ## LD2
set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]] ; ## LD3
set_property -dict {PACKAGE_PIN V22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]] ; ## LD4
set_property -dict {PACKAGE_PIN W22  IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]] ; ## LD5
set_property -dict {PACKAGE_PIN U19  IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]] ; ## LD6
set_property -dict {PACKAGE_PIN U14  IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]] ; ## LD7

set_property -dict {PACKAGE_PIN H15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]] ; ## XADC-GIO0
set_property -dict {PACKAGE_PIN R15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]] ; ## XADC-GIO1
set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]] ; ## XADC-GIO2
set_property -dict {PACKAGE_PIN J15  IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]] ; ## XADC-GIO3

set_property -dict {PACKAGE_PIN G17  IOSTANDARD LVCMOS33} [get_ports gpio_bd[31]] ; ## OTG-RESETN

# Define SPI clock

create_clock -name spi0_clk -period 40 [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk -period 40 [get_pins -hier */EMIOSPI1SCLKO]

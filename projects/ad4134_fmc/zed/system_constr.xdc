###############################################################################
## Copyright (C) 2023, 2025  Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad4134 SPI configuration interface
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS18} [get_ports ad4134_spi_sdi];         ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS18} [get_ports ad4134_spi_sdo];         ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports ad4134_spi_sclk];        ## FMC_LPC_LA01_P_CC
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports ad4134_spi_cs] ;         ## FMC_LPC_LA05_P

# ad4134 data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_dclk];   ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_din[0]]; ## FMC_LPC_LA00_N_CC
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_din[1]]; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_din[2]]; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad4134_din[3]]; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports ad4134_odr];             ## FMC_LPC_LA00_P_CC

# ad4134 GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports ad4134_resetn];          ## FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports ad4134_pdn];             ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS18} [get_ports ad4134_mode];            ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio0];           ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio1];           ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio2];           ## FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio3];           ## FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio4];           ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio5];           ## FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio6];           ## FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS18} [get_ports ad4134_gpio7];           ## FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS18} [get_ports ad4134_pinbspi];         ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS18} [get_ports ad4134_dclkio];          ## FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports ad4134_dclk_mode];       ## FMC_LPC_LA14_N

# Zedboard common xdc
# set IOSTANDARD according to VADJ 1.8V

# hdmi

set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS33}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  U16   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AA16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  V14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVCMOS33} [get_ports spdif]

# i2s

set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  AA6   IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD LVCMOS33} [get_ports i2s_sdata_out]
set_property  -dict {PACKAGE_PIN  AA7   IOSTANDARD LVCMOS33} [get_ports i2s_sdata_in]

# iic

set_property  -dict {PACKAGE_PIN  R7    IOSTANDARD LVCMOS33} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD LVCMOS33} [get_ports iic_sda]
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[1]]
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[1]]
set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_scl[0]]
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports iic_mux_sda[0]]

# otg

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS18} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS18} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

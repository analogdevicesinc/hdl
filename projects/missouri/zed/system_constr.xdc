###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Zedboard base constraints

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


## Missouri constraints

# FMC SPI

set_property -dict {PACKAGE_PIN P18      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[0]]           ; ## FMC_LA02_N
set_property -dict {PACKAGE_PIN M22      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[1]]           ; ## FMC_LA04_N
set_property -dict {PACKAGE_PIN T17      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[2]]           ; ## FMC_LA07_N
set_property -dict {PACKAGE_PIN N18      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[3]]           ; ## FMC_LA11_N
set_property -dict {PACKAGE_PIN P21      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[4]]           ; ## FMC_LA12_N
set_property -dict {PACKAGE_PIN J17      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[5]]           ; ## FMC_LA15_N
set_property -dict {PACKAGE_PIN K21      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[6]]           ; ## FMC_LA16_N
set_property -dict {PACKAGE_PIN G16      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[7]]           ; ## FMC_LA19_N
set_property -dict {PACKAGE_PIN A19      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[8]]           ; ## FMC_LA24_N
# set_property -dict {PACKAGE_PIN C22      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[9]]           ; ## FMC_LA25_N
# set_property -dict {PACKAGE_PIN B22      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[10]]           ; ## FMC_LA33_N
# set_property -dict {PACKAGE_PIN B21      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[11]]           ; ## FMC_LA33_P
set_property -dict {PACKAGE_PIN B22      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[9]]           ; ## FMC_LA33_N
set_property -dict {PACKAGE_PIN B21      IOSTANDARD LVCMOS18} [get_ports fmc_spi_cs_n[10]]           ; ## FMC_LA33_P
set_property -dict {PACKAGE_PIN T16      IOSTANDARD LVCMOS18} [get_ports fmc_spi_miso]           ; ## FMC_LA07_P
set_property -dict {PACKAGE_PIN N17      IOSTANDARD LVCMOS18} [get_ports fmc_spi_mosi]           ; ## FMC_LA11_P
set_property -dict {PACKAGE_PIN D20      IOSTANDARD LVCMOS18} [get_ports fmc_spi_sck]           ; ## FMC_LA18_CC_P

# FMC I2C

set_property -dict {PACKAGE_PIN M19      IOSTANDARD LVCMOS18} [get_ports fmc_i2c_scl]           ; ## FMC_LA00_CC_P
set_property -dict {PACKAGE_PIN J22      IOSTANDARD LVCMOS18} [get_ports fmc_i2c_sda]           ; ## FMC_LA08_N

# FMC GPIO

set_property -dict {PACKAGE_PIN M20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[0]]           ; ## FMC_LA00_CC_N
set_property -dict {PACKAGE_PIN N20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[1]]           ; ## FMC_LA01_CC_N
set_property -dict {PACKAGE_PIN N19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[2]]           ; ## FMC_LA01_CC_P
set_property -dict {PACKAGE_PIN P17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[3]]           ; ## FMC_LA02_P
set_property -dict {PACKAGE_PIN P22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[4]]           ; ## FMC_LA03_N
set_property -dict {PACKAGE_PIN N22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[5]]           ; ## FMC_LA03_P
set_property -dict {PACKAGE_PIN M21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[6]]           ; ## FMC_LA04_P
set_property -dict {PACKAGE_PIN K18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[7]]           ; ## FMC_LA05_N
set_property -dict {PACKAGE_PIN J18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[8]]           ; ## FMC_LA05_P
set_property -dict {PACKAGE_PIN L22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[9]]           ; ## FMC_LA06_N
set_property -dict {PACKAGE_PIN L21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[10]]           ; ## FMC_LA06_P
set_property -dict {PACKAGE_PIN J21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[11]]           ; ## FMC_LA08_P
set_property -dict {PACKAGE_PIN R21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[12]]           ; ## FMC_LA09_N
set_property -dict {PACKAGE_PIN R20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[13]]           ; ## FMC_LA09_P
set_property -dict {PACKAGE_PIN T19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[14]]           ; ## FMC_LA10_N
set_property -dict {PACKAGE_PIN R19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[15]]           ; ## FMC_LA10_P
set_property -dict {PACKAGE_PIN P20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[16]]           ; ## FMC_LA12_P
set_property -dict {PACKAGE_PIN M17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[17]]           ; ## FMC_LA13_N
set_property -dict {PACKAGE_PIN L17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[18]]           ; ## FMC_LA13_P
set_property -dict {PACKAGE_PIN K20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[19]]           ; ## FMC_LA14_N
set_property -dict {PACKAGE_PIN K19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[20]]           ; ## FMC_LA14_P
set_property -dict {PACKAGE_PIN J16      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[21]]           ; ## FMC_LA15_P
set_property -dict {PACKAGE_PIN J20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[22]]           ; ## FMC_LA16_P
set_property -dict {PACKAGE_PIN B20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[23]]           ; ## FMC_LA17_CC_N
set_property -dict {PACKAGE_PIN B19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[24]]           ; ## FMC_LA17_CC_P
set_property -dict {PACKAGE_PIN C20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[25]]           ; ## FMC_LA18_CC_N
set_property -dict {PACKAGE_PIN G15      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[26]]           ; ## FMC_LA19_P
set_property -dict {PACKAGE_PIN G21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[27]]           ; ## FMC_LA20_N
set_property -dict {PACKAGE_PIN G20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[28]]           ; ## FMC_LA20_P
set_property -dict {PACKAGE_PIN E20      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[29]]           ; ## FMC_LA21_N
set_property -dict {PACKAGE_PIN E19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[30]]           ; ## FMC_LA21_P
set_property -dict {PACKAGE_PIN F19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[31]]           ; ## FMC_LA22_N
set_property -dict {PACKAGE_PIN G19      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[32]]           ; ## FMC_LA22_P
set_property -dict {PACKAGE_PIN D15      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[33]]           ; ## FMC_LA23_N
set_property -dict {PACKAGE_PIN E15      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[34]]           ; ## FMC_LA23_P
set_property -dict {PACKAGE_PIN A18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[35]]           ; ## FMC_LA24_P
set_property -dict {PACKAGE_PIN D22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[36]]           ; ## FMC_LA25_P
set_property -dict {PACKAGE_PIN E18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[37]]           ; ## FMC_LA26_N
set_property -dict {PACKAGE_PIN F18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[38]]           ; ## FMC_LA26_P
set_property -dict {PACKAGE_PIN D21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[39]]           ; ## FMC_LA27_N
set_property -dict {PACKAGE_PIN E21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[40]]           ; ## FMC_LA27_P
set_property -dict {PACKAGE_PIN A17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[41]]           ; ## FMC_LA28_N
set_property -dict {PACKAGE_PIN A16      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[42]]           ; ## FMC_LA28_P
set_property -dict {PACKAGE_PIN C18      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[43]]           ; ## FMC_LA29_N
set_property -dict {PACKAGE_PIN C17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[44]]           ; ## FMC_LA29_P
set_property -dict {PACKAGE_PIN B15      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[45]]           ; ## FMC_LA30_N
set_property -dict {PACKAGE_PIN C15      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[46]]           ; ## FMC_LA30_P
set_property -dict {PACKAGE_PIN B16      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[47]]           ; ## FMC_LA31_P
set_property -dict {PACKAGE_PIN B17      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[48]]           ; ## FMC_LA31_N
set_property -dict {PACKAGE_PIN A22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[49]]           ; ## FMC_LA32_N
set_property -dict {PACKAGE_PIN A21      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[50]]           ; ## FMC_LA32_P

# CS_1355_8909 (FMC_LA25_N, G28) mapped to a GPIO
set_property -dict {PACKAGE_PIN C22      IOSTANDARD LVCMOS18} [get_ports fmc_gpio_o[51]]           ; ## FMC_LA25_N

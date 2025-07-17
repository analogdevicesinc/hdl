###############################################################################
## Copyright (C) 2019-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN L18  IOSTANDARD LVCMOS33}  [get_ports clk_in]              ; ## H04  FMC_LPC_CLK0_M2C_P IO_L12P_T1_MRCC_34
set_property  -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS33}  [get_ports ready_in]            ; ## G06  FMC_LPC_LA00_CC_P  IO_L13P_T2_MRCC_34
set_property  -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS33}  [get_ports data_in[0]]          ; ## G07  FMC_LPC_LA00_CC_N  IO_L13N_T2_MRCC_34
set_property  -dict {PACKAGE_PIN L22  IOSTANDARD LVCMOS33}  [get_ports data_in[1]]          ; ## C11  FMC_LPC_LA06_N     IO_L10N_T1_34
set_property  -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS33}  [get_ports data_in[2]]          ; ## H07  FMC_LPC_LA02_P     IO_L20P_T3_34
set_property  -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS33}  [get_ports data_in[3]]          ; ## H08  FMC_LPC_LA02_N     IO_L20N_T3_34
set_property  -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS33}  [get_ports data_in[4]]          ; ## G12  FMC_LPC_LA08_P     IO_L8P_T1_34
set_property  -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS33}  [get_ports data_in[5]]          ; ## G13  FMC_LPC_LA08_N     IO_L8N_T1_34
set_property  -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS33}  [get_ports data_in[6]]          ; ## D14  FMC_LPC_LA09_P     IO_L17P_T2_34
set_property  -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS33}  [get_ports data_in[7]]          ; ## D15  FMC_LPC_LA09_N     IO_L17N_T2_34
set_property  -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS33}  [get_ports spi_csn]             ; ## D11  FMC_LPC_LA05_P     IO_L7P_T1_34
set_property  -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS33}  [get_ports spi_clk]             ; ## D08  FMC_LPC_LA01_CC_P  IO_L14P_T2_SRCC_34
set_property  -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS33}  [get_ports spi_mosi]            ; ## H11  FMC_LPC_LA04_N     IO_L15N_T2_DQS_34
set_property  -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS33}  [get_ports spi_miso]            ; ## G09  FMC_LPC_LA03_P     IO_L16P_T2_34
set_property  -dict {PACKAGE_PIN T19  IOSTANDARD LVCMOS33}  [get_ports gpio_0_mode_0]       ; ## C15  FMC_LPC_LA10_N     IO_L22N_T3_34
set_property  -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS33}  [get_ports gpio_1_mode_1]       ; ## H13  FMC_LPC_LA07_P     IO_L21P_T3_DQS_34
set_property  -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS33}  [get_ports gpio_2_mode_2]       ; ## H14  FMC_LPC_LA07_N     IO_L21N_T3_DQS_34
set_property  -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS33}  [get_ports gpio_3_mode_3]       ; ## H16  FMC_LPC_LA11_P     IO_L5P_T0_34
set_property  -dict {PACKAGE_PIN R19  IOSTANDARD LVCMOS33}  [get_ports gpio_4_filter]       ; ## C14  FMC_LPC_LA10_P     IO_L22P_T3_34
set_property  -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS33}  [get_ports reset_n]             ; ## C10  FMC_LPC_LA06_P     IO_L10P_T1_34
set_property  -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS33}  [get_ports start_n]             ; ## G10  FMC_LPC_LA03_N     IO_L16N_T2_34
set_property  -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS33}  [get_ports mclk]                ; ## D09  FMC_LPC_LA01_CC_N  IO_L14N_T2_SRCC_34

create_clock -name adc_clk -period 20 [get_ports clk_in]

# Zedboard common xdc
# set IOSTANDARD according to VADJ 3.3V

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

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS33} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS33} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS33} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS33} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

# Define SPI clock

create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

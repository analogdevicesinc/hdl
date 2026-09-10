###############################################################################
## Copyright (C) 2019-2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# EMG 088756 Rev b, sheet 19 (FMC) → Zedboard FMC LPC (Bank 34/35, VADJ=1.8V)
# Connector P23, ASP-134604-01.  Schematic net names are given in the comments.

# ad4134 SPI configuration interface

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS18} [get_ports emg_spi_sdo];         ## G9  FMC_LPC_LA03_P    IO_L16P_T2_34         SDO_ADC
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS18} [get_ports emg_spi_sdi];         ## H11 FMC_LPC_LA04_N    IO_L15N_T2_DQS_34     SDI_ADC
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports emg_spi_sclk];        ## D8  FMC_LPC_LA01_P_CC IO_L14P_T2_SRCC_34    SCLK_ADC
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports emg_spi_cs[0]];       ## D11 FMC_LPC_LA05_P    IO_L7P_T1_34          CS_ADC1
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports emg_spi_cs[1]];       ## D12 FMC_LPC_LA05_N    IO_L7N_T1_34          CS_ADC2

# ad4134 data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_dclk];   ## H4  FMC_LPC_CLK0_M2C_P IO_L12P_T1_MRCC_34   DCLK
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[0]]; ## G7  FMC_LPC_LA00_N_CC  IO_L13N_T2_MRCC_34   DOUT0_1
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[1]]; ## C11 FMC_LPC_LA06_N     IO_L10N_T1_34        DOUT1_1
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[2]]; ## H7  FMC_LPC_LA02_P     IO_L20P_T3_34        DOUT2_1
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[3]]; ## H8  FMC_LPC_LA02_N     IO_L20N_T3_34        DOUT3_1
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[4]]; ## G12 FMC_LPC_LA08_P     IO_L8P_T1_34         DOUT0_2
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[5]]; ## G13 FMC_LPC_LA08_N     IO_L8N_T1_34         DOUT1_2
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[6]]; ## D14 FMC_LPC_LA09_P     IO_L17P_T2_34        DOUT2_2
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports emg_din[7]]; ## D15 FMC_LPC_LA09_N     IO_L17N_T2_34        DOUT3_2
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports emg_odr];             ## G6 FMC_LPC_LA00_P_CC   IO_L13P_T2_MRCC_34   ODR

# Sheet 19 shorts DCLK to CLK0_M2C_N through R140 (0R, fitted) and ODR to LA33_N
# through R157 (0R, fitted), in addition to the two pins constrained above.
# Both DCLK and ODR are FPGA outputs here, so driving the second pin as well would
# put two FPGA drivers on one board net through a 0R link.  Left unconstrained -
# the pins stay unused and the board net is driven from one end only.
# Enable one of the pairs below only if the matching 0R is removed on the board.
#
# set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS18} [get_ports emg_dclk_n];        ## FMC_LPC_CLK0_M2C_N DCLK  via R140
# set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS18} [get_ports emg_odr_n];         ## FMC_LPC_LA33_N     ODR   via R157

# ad4134 GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports emg_resetn[0]];       ## G18 FMC_LPC_LA16_P  IO_L9P_T1_DQS_34     RESETB_1
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports emg_resetn[1]];       ## G19 FMC_LPC_LA16_N  IO_L9N_T1_DQS_34     RESETB_2
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports emg_pdn[0]];          ## H13 FMC_LPC_LA07_P  IO_L21P_T3_DQS_34    PDNB_1
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports emg_pdn[1]];          ## H14 FMC_LPC_LA07_N  IO_L21N_T3_DQS_34    PDNB_2
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS18} [get_ports emg_mode[0]];         ## H10 FMC_LPC_LA04_P  IO_L15P_T2_DQS_34    MODE_1
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS18} [get_ports emg_mode[1]];         ## G10 FMC_LPC_LA03_N  IO_L16N_T2_34        MODE_2
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports emg_gpio[0]];         ## C14 FMC_LPC_LA10_P  IO_L22P_T3_34        DCLKRATE0/GPIO0
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports emg_gpio[1]];         ## C15 FMC_LPC_LA10_N  IO_L22N_T3_34        DCLKRATE1/GPIO1
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS18} [get_ports emg_gpio[2]];         ## H16 FMC_LPC_LA11_P  IO_L5P_T0_34         DCLKRATE2/GPIO2
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS18} [get_ports emg_gpio[3]];         ## H17 FMC_LPC_LA11_N  IO_L5N_T0_34         PWRMODE/GPIO3
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS18} [get_ports emg_gpio[4]];         ## G15 FMC_LPC_LA12_P  IO_L18P_T2_34        FILTER0/GPIO4
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS18} [get_ports emg_gpio[5]];         ## G16 FMC_LPC_LA12_N  IO_L18N_T2_34        FILTER1/GPIO5
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS18} [get_ports emg_gpio[6]];         ## D17 FMC_LPC_LA13_P  IO_L4P_T0_34         FRAME0/GPIO6
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS18} [get_ports emg_gpio[7]];         ## D18 FMC_LPC_LA13_N  IO_L4N_T0_34         FRAME1/GPIO7
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS18} [get_ports emg_pinbspi];         ## C10 FMC_LPC_LA06_P  IO_L10P_T1_34        PINB/SPI
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports emg_dclkmode];        ## C19 FMC_LPC_LA14_N  IO_L11N_T1_SRCC_34   DEC1/DCLKMODE

# ad4134 reference clock (not used by default)
 
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS18} [get_ports emg_sdpclk];          ## D9  FMC_LPC_LA01_N_CC IO_L14N_T2_SRCC_34 SDPCLK

# amplifier SPI interface (Bank 35)

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[0]];     ## H22 FMC_LPC_LA19_P IO_L4P_T0_35               CS_AMP0_O
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[1]];     ## H23 FMC_LPC_LA19_N IO_L4N_T0_35               CS_AMP1_O
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[2]];     ## H25 FMC_LPC_LA21_P IO_L21P_T3_DQS_AD14P_35    CS_AMP2_O
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[3]];     ## H26 FMC_LPC_LA21_N IO_L21N_T3_DQS_AD14N_35    CS_AMP3_O
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[4]];     ## H28 FMC_LPC_LA24_P IO_L10P_T1_AD11P_35        CS_AMP4_O
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[5]];     ## H29 FMC_LPC_LA24_N IO_L10N_T1_AD11N_35        CS_AMP5_O
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[6]];     ## H31 FMC_LPC_LA28_P IO_L9P_T1_DQS_AD3P_35      CS_AMP6_O
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS18} [get_ports emg_amp_cs[7]];     ## H32 FMC_LPC_LA28_N IO_L9N_T1_DQS_AD3N_35      CS_AMP7_O
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS18} [get_ports emg_amp_sdi];       ## H34 FMC_LPC_LA30_P IO_L7P_T1_AD2P_35          SDI_AMP_O
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS18} [get_ports emg_amp_sdo];       ## H35 FMC_LPC_LA30_N IO_L7N_T1_AD2N_35          SDO_AMP_O
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS18} [get_ports emg_amp_sclk];      ## H37 FMC_LPC_LA32_P IO_L15P_T2_DQS_AD12P_35    SCLK_AMP_O

# channel enables CH4..CH7 (Bank 35) - new on 088756 Rev b

set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS18} [get_ports emg_ch_en[0]];      ## C22 FMC_LPC_LA18_P_CC  IO_L14P_T2_AD4P_SRCC_35  CH4_EN_O
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS18} [get_ports emg_ch_en[1]];      ## C23 FMC_LPC_LA18_N_CC  IO_L14N_T2_AD4N_SRCC_35  CH5_EN_O
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS18} [get_ports emg_ch_en[2]];      ## C26 FMC_LPC_LA27_P     IO_L17P_T2_AD5P_35       CH6_EN_O
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS18} [get_ports emg_ch_en[3]];      ## C27 FMC_LPC_LA27_N     IO_L17N_T2_AD5N_35       CH7_EN_O

# SW phase 2 (AD5940 / MAX30011) - pins reserved, no controller in the block design yet.
# Held idle in system_top.v so the nets are defined and the routing is proven.

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS18} [get_ports emg_ad5940_cs];     ## G30 FMC_LPC_LA29_P  IO_L11P_T1_SRCC_35     CS_AD5940_O
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS18} [get_ports emg_ad5940_sclk];   ## G31 FMC_LPC_LA29_N  IO_L11N_T1_SRCC_35     SCLK_AD5940_O
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS18} [get_ports emg_ad5940_sdi];    ## G33 FMC_LPC_LA31_P  IO_L8P_T1_AD10P_35     SDI_AD5940_O
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS18} [get_ports emg_ad5940_sdo];    ## G34 FMC_LPC_LA31_N  IO_L8N_T1_AD10N_35     SDO_AD5940_O

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS18} [get_ports emg_max30011_cs];   ## D23 FMC_LPC_LA23_P  IO_L3P_T0_DQS_AD1P_35  CS_MAX30011
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS18} [get_ports emg_max30011_sdo];  ## D24 FMC_LPC_LA23_N  IO_L3N_T0_DQS_AD1N_35  SDO_MAX30011
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS18} [get_ports emg_max30011_sdi];  ## D26 FMC_LPC_LA26_P  IO_L5P_T0_AD9P_35      SDI_MAX30011
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS18} [get_ports emg_max30011_sclk]; ## D27 FMC_LPC_LA26_N  IO_L5N_T0_AD9N_35      SCLK_MAX30011

# set IOSTANDARD according to VADJ 1.8V

# constraints
# hdmi

set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS18}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  U16   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AA16  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  V14   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVCMOS18  IOB TRUE} [get_ports hdmi_data[15]]

# spdif

set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVCMOS18} [get_ports spdif]

# i2s

set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD LVCMOS18} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  AA6   IOSTANDARD LVCMOS18} [get_ports i2s_bclk]
set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]
set_property  -dict {PACKAGE_PIN  AA7   IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]

# iic

set_property  -dict {PACKAGE_PIN  R7    IOSTANDARD LVCMOS18} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  U7    IOSTANDARD LVCMOS18} [get_ports iic_sda]
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_mux_scl[1]]
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_mux_sda[1]]
set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_mux_scl[0]]
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_mux_sda[0]]

# otg

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS18} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS18} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS18} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS18} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS18} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS18} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS18} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS18} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS18} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS18} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS18} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS18} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

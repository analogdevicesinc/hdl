###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports dds_pdclk]        ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports dds_d[0]]         ; ## G30  FMC_LPC_LA29_P
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25} [get_ports dds_d[1]]         ; ## G31  FMC_LPC_LA29_N
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports dds_d[2]]         ; ## G09  FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports dds_d[3]]         ; ## G10  FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports dds_d[4]]         ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports dds_d[5]]         ; ## H11  FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports dds_d[6]]         ; ## D11  FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports dds_d[7]]         ; ## D12  FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports dds_d[8]]         ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports dds_d[9]]         ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports dds_d[10]]        ; ## H31  FMC_LPC_LA28_P
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS25} [get_ports dds_d[11]]        ; ## H32  FMC_LPC_LA28_N
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports dds_d[12]]        ; ## G12  FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports dds_d[13]]        ; ## G13  FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports dds_d[14]]        ; ## D14  FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports dds_d[15]]        ; ## D15  FMC_LPC_LA09_N

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports dds_sync_clk]     ; ## D20  FMC_LPC_LA17_CC_P
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS25} [get_ports dds_csb]          ; ## H37  FMC_LPC_LA32_P
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS25} [get_ports dds_drctrl]       ; ## H35  FMC_LPC_LA30_N
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports dds_drhold]       ; ## G18  FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports dds_drover]       ; ## G19  FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS25} [get_ports dds_ext_pwr_dwn]  ; ## H23  FMC_LPC_LA19_N
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports dds_f[0]]         ; ## D09  FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports dds_f[1]]         ; ## G07  FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports dds_io_reset]     ; ## H26  FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS25} [get_ports dds_io_update]    ; ## H34  FMC_LPC_LA30_P
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports dds_main_reset]   ; ## H38  FMC_LPC_LA32_N
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports dds_osk]          ; ## G34  FMC_LPC_LA31_N
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports dds_profile0]     ; ## C14  FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports dds_profile1]     ; ## C15  FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS25} [get_ports dds_profile2]     ; ## H29  FMC_LPC_LA24_N
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports dds_ram_swp_ovr]  ; ## H25  FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports dds_txenable]     ; ## D08  FMC_LPC_LA01_CC_P

# pll control
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports pll_le]           ; ## D21  FMC_LPC_LA17_CC_N
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25} [get_ports pll_ce]           ; ## G36  FMC_LPC_LA33_P

# attenuator control
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports att_le]           ; ## C18  FMC_LPC_LA14_P
# miso att is used to cascade atenuators, in this case it can be used for debug
#set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports spi_miso_att]    ; ## C19  FMC_LPC_LA14_N

#ADC interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_dco_p]; ## H04  FMC_LPC_CLK0_M2C_P  CHA_DCO_P
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_dco_n]; ## H05  FMC_LPC_CLK0_M2C_N  CHA_DCO_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_da_p];  ## H07  FMC_LPC_LA02_P      CHA_DA_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_da_n];  ## H08  FMC_LPC_LA02_N      CHA_DA_N

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_dco_p]; ## G02  FMC_LPC_CLK1_M2C_P  CHB_DCO_P
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_dco_n]; ## G03  FMC_LPC_CLK1_M2C_N  CHB_DCO_N
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_da_p];  ## G21  FMC_LPC_LA20_P      DDS_PDCLK
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_da_n];  ## G22  FMC_LPC_LA20_N      DDS_F1

set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS25} [get_ports adca_gpio1_fmc];        ## C27  FMC_LPC_LA27_N      CHA_GPIO1_FMC
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports adca_gp0_dir];          ## H16  FMC_LPC_LA11_P      CHA_GP0_DIR
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports adca_gp1_dir];          ## C23  FMC_LPC_LA18_CC_N   CHA_GP1_DIR

set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports adcb_gpio1_fmc];        ## H28  FMC_LPC_LA24_P      CHB_GPIO1_FMC

set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_csn];       ## G27  FMC_LPC_LA25_P      CHA_CS_N_SRC
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_sclk];      ## H14  FMC_LPC_LA07_N      CHA_SCLK_SRC

set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_mosi];      ## G28  FMC_LPC_LA25_N      CHA_SDIO_SRC
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_miso];      ## H13  FMC_LPC_LA07_P      CHA_GPIO0_FMC - default SDO

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_csn];       ## G24  FMC_LPC_LA22_P      CHB_CS_N_SRC
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_sclk];      ## G25  FMC_LPC_LA22_N      CHB_SCLK_SRC

set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_mosi];      ## D23  FMC_LPC_LA23_P      CHB_SDIO_SRC
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_miso];      ## D24  FMC_LPC_LA23_N      CHB_GPIO0_FMC

set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25} [get_ports ad9508_sync];           ## C26  FMC_LPC_LA27_P      AD9508_SYNC/CNVEN

set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25} [get_ports ad9508_csn];            ## D27  FMC_LPC_LA26_N      CS1_0
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports syncb];                 ## C22  FMC_LPC_LA18_CC_P

set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_sclk];   ## D18  FMC_LPC_LA13_N      SCLK1
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_miso];   ## D17  FMC_LPC_LA13_P      SDO_1
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_mosi];   ## D26  FMC_LPC_LA26_P      SDIN1

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports en_psu];                ## H19  FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwrgd];                 ## H20  FMC_LPC_LA15_N
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pd_v33b];               ## H22  FMC_LPC_LA19_P
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS25} [get_ports en_ifvga];              ## G33  FMC_LPC_LA31_P - ???????

# SPI interface
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports spi_clk];               ## H17  FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports spi_miso];              ## G16  FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports spi_mosi];              ## G15  FMC_LPC_LA12_P

# zed overwrite system constraints

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

set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS25} [get_ports otg_vbusoc]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

create_clock -name sync_clk       -period  8 [get_ports dds_sync_clk]
create_clock -name pd_clk         -period  4 [get_ports dds_pdclk]

create_clock -period 2.500 -name dco_clk  [get_ports adca_dco_p]
create_clock -period 2.500 -name dco_clk1 [get_ports adcb_dco_p]

##by default IOB is TRUE and this register is not being driven by any IO element

set_property IOB FALSE [get_cells -hierarchical -regexp {.*ad4080_a_spi.*IO0_I_REG$}];
set_property IOB FALSE [get_cells -hierarchical -regexp {.*ad4080_b_spi.*IO0_I_REG$}];

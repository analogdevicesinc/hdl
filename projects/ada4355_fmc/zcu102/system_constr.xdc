###############################################################################
## Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_p];    ## H4 FMC_CLK0_M2C_P IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_n];    ## H5 FMC_CLK0_M2C_N IO_L12N_T1_MRCC_34

set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_p];     ## G9 FMC_LA03_P IO_L16P_T2_34
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_n];     ## G10 FMC_LA03_N IO_L16N_T2_34

set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_p];     ## H10 FMC_LA04_P IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_n];     ## H11 FMC_LA04_N IO_L15N_T2_DQS_34

#set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVDS DIFF_TERM 1} [get_ports frame_clock_p];     ## G2  FMC_CLK1_M2C_P IO_L12P_T1_MRCC_35
#set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVDS DIFF_TERM 1} [get_ports frame_clock_n];     ## G3 FMC_CLK1_M2C_N IO_L12N_T1_MRCC_35

set_property -dict {PACKAGE_PIN Y4 IOSTANDARD LVDS DIFF_TERM 1} [get_ports frame_clock_p];     ## G2  FMC_CLK1_M2C_P IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN Y3 IOSTANDARD LVDS DIFF_TERM 1} [get_ports frame_clock_n];     ## G3 FMC_CLK1_M2C_N IO_L12N_T1_MRCC_35

set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS18} [get_ports fsel];           ## H25 FMC_LA21_P IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS18} [get_ports gain_sel0];      ## G21 FMC_LA20_P IO_L22P_T3_AD7P_35
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS18} [get_ports gain_sel1];      ## G22 FMC_LA20_N IO_L22N_T3_AD7N_35
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS18} [get_ports gain_sel2];      ## H29 FMC_LA24_N IO_L10N_T1_AD11N_35
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS18} [get_ports gpio_1p8vd_en];  ## G16 FMC_LA12_N IO_L18N_T2_34
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports gpio_1p8va_en];  ## D23 FMC_LA23_P IO_L3P_T0_DQS_AD1P_35

set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS18} [get_ports csb_apd_pot];    ## G12 FMC_LA08_P IO_L8P_T1_34
set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVCMOS18} [get_ports csb_ld_pot];     ## G15 FMC_LA12_P IO_L18P_T2_34
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports sclk_pot];       ## D9 FMC_LA01_CC_N IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS18} [get_ports mosi_pot];       ## H14 FMC_LA07_N IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS18} [get_ports miso_pot];       ## H13 FMC_LA07_P IO_L21P_T3_DQS_34

set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS18} [get_ports ada4355_csn];          ## G13 FMC_LA08_N IO_L8N_T1_34
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS18} [get_ports ada4355_sclk];         ## D8  FMC_LA01_CC_P IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18} [get_ports ada4355_mosi];         ## H7 FMC_LA02_P IO_L20P_T3_34
set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS18} [get_ports ada4355_miso];         ## H8 FMC_LA02_N IO_L20N_T3_34

#set_property -dict {PACKAGE_PIN P12 IOSTANDARD LVCMOS33} [get_ports fsel];           ## H25 FMC_LA21_P IO_L21P_T3_DQS_AD14P_35
#set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports gain_sel0];      ## G21 FMC_LA20_P IO_L22P_T3_AD7P_35
#set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports gain_sel1];      ## G22 FMC_LA20_N IO_L22N_T3_AD7N_35
#set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports gain_sel2];      ## H29 FMC_LA24_N IO_L10N_T1_AD11N_35
#set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS33} [get_ports gpio_1p8vd_en];  ## G16 FMC_LA12_N IO_L18N_T2_34
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports gpio_1p8va_en];  ## D23 FMC_LA23_P IO_L3P_T0_DQS_AD1P_35
#
#set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS25} [get_ports csb_apd_pot];    ## G12 FMC_LA08_P IO_L8P_T1_34
#set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVCMOS25} [get_ports csb_ld_pot];     ## G15 FMC_LA12_P IO_L18P_T2_34
#set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS25} [get_ports sclk_pot];       ## D9 FMC_LA01_CC_N IO_L14N_T2_SRCC_34
#set_property -dict {PACKAGE_PIN U4  IOSTANDARD LVCMOS25} [get_ports mosi_pot];       ## H14 FMC_LA07_N IO_L21N_T3_DQS_34
#set_property -dict {PACKAGE_PIN U5  IOSTANDARD LVCMOS25} [get_ports miso_pot];       ## H13 FMC_LA07_P IO_L21P_T3_DQS_34
#
#set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS18} [get_ports ada4355_csn];          ## G13 FMC_LA08_N IO_L8N_T1_34
#set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS18} [get_ports ada4355_sclk];         ## D8  FMC_LA01_CC_P IO_L14P_T2_SRCC_34
#set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18} [get_ports ada4355_mosi];         ## H7 FMC_LA02_P IO_L20P_T3_34
#set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS18} [get_ports ada4355_miso];         ## H8 FMC_LA02_N IO_L20N_T3_34


# clocks

create_clock -period 2.500 -name dco_clk  [get_ports dco_p]
#create_clock -period 25.00 -name ref_clk  [get_ports clk_p]
#create_clock -period 10.00 -name fpga_clk [get_ports fpgaclk_p]

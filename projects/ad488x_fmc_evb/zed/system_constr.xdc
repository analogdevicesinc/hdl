###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_dco_p];       ## H4   FMC_CLK0_M2C_P IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_dco_n];       ## H5   FMC_CLK0_M2C_N IO_L12N_T1_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_da_p];        ## H7   FMC_LA02_P     IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_da_n];        ## H8   FMC_LA02_N     IO_L20N_T3_34
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_db_p];        ## G9   FMC_LA03_P     IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adca_db_n];        ## G10  FMC_LA03_N     IO_L16N_T2_34

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_dco_p];       ## G2   FMC_CLK1_M2C_P IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_dco_n];       ## G3   FMC_CLK1_M2C_N IO_L12N_T1_MRCC_35
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_da_p];        ## G21  FMC_LA20_P     IO_L22P_T3_AD7P_35
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_da_n];        ## G22  FMC_LA20_N     IO_L22N_T3_AD7N_35
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_db_p];        ## H25  FMC_LA21_P     IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adcb_db_n];        ## H26  FMC_LA21_N     IO_L21N_T3_DQS_AD14N_35

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adca_clk_p];      ## D8    LA01_CC_P      IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adca_clk_n];      ## D9    LA01_CC_N      IO_L14N_T2_SRCC_34

set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adcb_clk_p];      ## G30   FMC_LA29_P     IO_L11P_T1_SRCC_35
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adcb_clk_n];      ## G31   FMC_LA29_N     IO_L11N_T1_SRCC_35

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adca_cnv_in_p];   ## G6   FMC_LA00_CC_P  IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adca_cnv_in_n];   ## G7   FMC_LA00_CC_N  IO_L13N_T2_MRCC_34

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adcb_cnv_in_p];   ## D20   FMC_LA17_CC_P  IO_L13P_T2_MRCC_35
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25  DIFF_TERM 1} [get_ports adcb_cnv_in_n];   ## D21   FMC_LA17_CC_N  IO_L13N_T2_MRCC_35

set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports adca_gpio1_fmc];      ## C11 FMC_LA06_N IO_L10N_T1_34
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports adca_gpio2_fmc];      ## D14 FMC_LA09_P IO_L17P_T2_34
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports adca_gpio3_fmc];      ## D15 FMC_LA09_N IO_L17N_T2_34
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports adca_gp0_dir];        ## H16 FMC_LA11_P IO_L5P_T0_34
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports adca_gp1_dir];        ## C15 FMC_LA10_N IO_L22N_T3_34
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports adca_gp2_dir];        ## G15 FMC_LA12_P IO_L18P_T2_34
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports adca_gp3_dir];        ## H17 FMC_LA11_N IO_L5N_T0_34

set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports adcb_gpio1_fmc];      ## H28 FMC_LA24_P IO_L10P_T1_AD11P_35
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS25} [get_ports adcb_gpio2_fmc];      ## H29 FMC_LA24_N IO_L10N_T1_AD11N_35
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS25} [get_ports adcb_gpio3_fmc];      ## G27 FMC_LA25_P IO_L16P_T2_35
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS25} [get_ports adcb_gp0_dir];        ## G28 FMC_LA25_N IO_L16N_T2_35
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports adcb_gp1_dir];        ## D26 FMC_LA26_P IO_L5P_T0_AD9P_35
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25} [get_ports adcb_gp2_dir];        ## D27 FMC_LA26_N IO_L5N_T0_AD9N_35
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25} [get_ports adcb_gp3_dir];        ## C26 FMC_LA27_P IO_L17P_T2_AD5P_35

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports en_psu];              ## H19 FMC_LA15_P IO_L2P_T0_34
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwrgd];               ## H20 FMC_LA15_N IO_L2N_T0_34
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pd_v33b];             ## H22 FMC_LA19_P IO_L4P_T0_35
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports osc_en];              ## G16 FMC_LA12_N IO_L18N_T2_34

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_csn];     ## G12 FMC_LA08_P IO_L8P_T1_34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_sclk];    ## H14 FMC_LA07_N IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_mosi];    ## G13 FMC_LA08_N IO_L8N_T1_34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports adca_ad4080_miso];    ## H13 FMC_LA07_P IO_L21P_T3_DQS_34

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_csn];     ## G24 FMC_LA22_P IO_L20P_T3_AD6P_35
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_sclk];    ## G25 FMC_LA22_N IO_L20N_T3_AD6N_35
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_mosi];    ## D23 FMC_LA23_P IO_L3P_T0_DQS_AD1P_35
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25} [get_ports adcb_ad4080_miso];    ## D24 FMC_LA23_N IO_L3N_T0_DQS_AD1N_35

set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports ad9508_csn];          ## C19 FMC_LA14_N IO_L11N_T1_SRCC_34
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports adf4350_csn];         ## C22 FMC_LA18_CC_P IO_L14P_T2_AD4P_SRCC_35
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_sclk]; ## D18 FMC_LA13_N IO_L4N_T0_34
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_miso]; ## D17 FMC_LA13_P IO_L4P_T0_34
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports ad9508_adf4350_mosi]; ## C18 FMC_LA14_P IO_L11P_T1_SRCC_34

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports adca_doc_fmc];        ## G18 FMC_LA16_P IO_L9P_T1_DQS_34
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports adca_dod_fmc];        ## G19 FMC_LA16_N IO_L9N_T1_DQS_34

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad9508_sync];         ## C10 FMC_LA06_P IO_L10P_T1_34
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports adf435x_lock];        ## C23 FMC_LA18_CC_N IO_L14N_T2_AD4N_SRCC_35

# clocks

create_clock -period 2.500 -name dco_clk  [get_ports adca_dco_p]
create_clock -period 2.500 -name ref_clk  [get_ports adca_clk_p]
create_clock -period 2.500 -name dco_clk1 [get_ports adcb_dco_p]
create_clock -period 2.500 -name ref_clk1 [get_ports adcb_clk_p]

##by default IOB is TRUE and this register is not being driven by any IO element

set_property IOB FALSE [get_cells -hierarchical -regexp {.*ad4080_b_spi.*IO0_I_REG$}];

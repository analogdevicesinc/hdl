###############################################################################
## Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]     ; ## H4  FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]     ; ## H5  FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpgaclk_p] ; ## G2  FMC_CLK1_M2C_P  IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports fpgaclk_n] ; ## G3  FMC_CLK1_M2C_N  IO_L12N_T1_MRCC_35

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_p]     ; ## D8  FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_n]     ; ## D9  FMC_LA01_CC_N   IO_L14N_T2_SRCC_34

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_p]      ; ## H7  FMC_LA02_P      IO_L20P_T3_34   
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports da_n]      ; ## H8  FMC_LA02_N      IO_L20N_T3_34  

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_p]      ; ## G9  FMC_LA03_P      IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports db_n]      ; ## G10 FMC_LA03_N      IO_L16N_T2_34 

set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports gpio0_fmc]            ; ## H13 FMC_LA07_P      IO_L21P_T3_DQS_34 
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports gpio1_fmc]            ; ## C11 FMC_LA06_N      IO_L10N_T1_34    
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports gpio2_fmc]            ; ## D14 FMC_LA09_P      IO_L17P_T2_34       
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports gpio3_fmc]            ; ## D15 FMC_LA09_N      IO_L17N_T2_34  
            
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports gp0_dir]              ; ## H16 FMC_LA11_P       IO_L5P_T0_34   
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports gp1_dir]              ; ## C15 FMC_LA10_N       IO_L22N_T3_34   
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports gp2_dir]              ; ## G15 FMC_LA12_P       IO_L18P_T2_34 
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports gp3_dir]              ; ## H17 FMC_LA11_N       IO_L5N_T0_34 

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25} [get_ports en_psu]               ; ## H19 FMC_LA15_P       IO_L2P_T0_34 
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25} [get_ports pwrgd]                ; ## H20 FMC_LA15_N       IO_L2N_T0_34  
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS25} [get_ports pd_v33b]              ; ## H22 FMC_LA19_P       IO_L4P_T0_35  
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports osc_en]               ; ## G16 FMC_LA12_N       IO_L18N_T2_34    

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports cs_n_src]             ; ## G12 FMC_LA08_P       IO_L8P_T1_34 
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports sdio_src]             ; ## G13 FMC_LA08_N       IO_L8N_T1_34   
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports sclk_src]             ; ## H14 FMC_LA07_N       IO_L21N_T3_DQS_34

set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports cs1_0]                ; ## C19 FMC_LA14_N       IO_L11N_T1_SRCC_34 
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS25} [get_ports cs1_1]                ; ## C22 FMC_LA18_CC_P    IO_L14P_T2_AD4P_SRCC_35  
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports sdo_1]                ; ## D17 FMC_LA13_P       IO_L4P_T0_34 
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports sclk1]                ; ## D18 FMC_LA13_N       IO_L4N_T0_34 
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports sdin1]                ; ## C18 FMC_LA14_P       IO_L11P_T1_SRCC_34  

set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports doa_fmc]              ; ## D20 FMC_LA17_CC_P    IO_L13P_T2_MRCC_35 
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports dob_fmc]              ; ## D21 FMC_LA17_CC_N    IO_L13N_T2_MRCC_35 
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports doc_fmc]              ; ## G18 FMC_LA16_P       IO_L9P_T1_DQS_34
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25} [get_ports dod_fmc]              ; ## G19 FMC_LA16_N       IO_L9N_T1_DQS_34

set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS25} [get_ports pbio[0]]              ; ## H23 FMC_LA19_N       IO_L4N_T0_35 
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports pbio[1]]              ; ## G21 FMC_LA20_P       IO_L22P_T3_AD7P_35  
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports pbio[2]]              ; ## G22 FMC_LA20_N       IO_L22N_T3_AD7N_35  
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports pbio[3]]              ; ## H25 FMC_LA21_P       IO_L21P_T3_DQS_AD14P_35 
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS25} [get_ports pbio[4]]              ; ## H26 FMC_LA21_N       IO_L21N_T3_DQS_AD14N_35
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports pbio[5]]              ; ## G24 FMC_LA22_P       IO_L20P_T3_AD6P_35 
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS25} [get_ports pbio[6]]              ; ## G25 FMC_LA22_N       IO_L20N_T3_AD6N_35 
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports pbio[7]]              ; ## D23 FMC_LA23_P       IO_L3P_T0_DQS_AD1P_35 
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS25} [get_ports pbio[8]]              ; ## D24 FMC_LA23_N       IO_L3N_T0_DQS_AD1N_35 

set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad9508_sync]          ; ## C10 FMC_LA06_P       IO_L10P_T1_34 
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports adf435x_lock]         ; ## C23 FMC_LA18_CC_N    IO_L14N_T2_AD4N_SRCC_35    

# clocks

create_clock -period 2.500 -name dco_clk [get_ports dco_p]

###############################################################################
## Copyright (C) 2020-2024 Alog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# ad408x_fmc_evb
# set_property -dict {PACKAGE_PIN      IOSTANDARD } [get_ports ]                             ; ##     The IO_L12_T1U...... comment is wrong for ZCU102                  
set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_p]       ; ## H4   FMC0_CLK0_M2C_P  IO_L12P_T1U_N10_GC_66
set_property -dict {PACKAGE_PIN AA6  IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_n]       ; ## H5   FMC0_CLK0_M2C_N  IO_L12N_T1U_N11_GC_66
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_p]        ; ## H7   FMC0_LA02_P      IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_n]        ; ## H8   FMC0_LA02_N      IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_p]        ; ## G9   FMC0_LA03_P      IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_n]        ; ## G10  FMC0_LA03_N      IO_L22N_T3U_N7_DBC_AD0N_66
##set_property -dict {PACKAGE_PIN T8   IOSTANDARD LVDS DIFF_TERM 1} [get_ports cnv_in_p]    ; ## G2   FMC0_CLK1_M2C_P  IO_L12P_T1U_N10_GC_67  /// Where did clk_in_p/n come from
##set_property -dict {PACKAGE_PIN R8   IOSTANDARD LVDS DIFF_TERM 1} [get_ports cnv_in_n]    ; ## G3   FMC0_CLK1_M2C_N  IO_L12N_T1U_N11_GC_67
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVDS DIFF_TERM 1} [get_ports fpgaclk_p]    ; ## G2  FMC_HPC0_CLK1_M2C_P     IO_L12P_T1_MRCC_35 //////
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVDS DIFF_TERM 1} [get_ports fpgaclk_n]    ; ##  G3 FMC_HPC0_CLK1_M2C_n     IO_L12N_T1_MRCC_35 //////
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVDS  DIFF_TERM 1} [get_ports clk_p]       ; ## D8  FMC_HPC0_LA01_CC_P      IO_L14P_T2_SRCC_34 ////// W
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVDS  DIFF_TERM 1} [get_ports clk_n]       ; ## D9   FMC_HPC0_LA01_CC_N      IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports gpio1_fmc]              ; ## C11  FMC0_LA06_N      IO_L19N_T3L_N1_DBC_AD9N_66
set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports gpio2_fmc]              ; ## D14  FMC0_LA09_P      IO_L24P_T3U_N10_66
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports gpio3_fmc]              ; ## D15  FMC0_LA09_N      IO_L24N_T3U_N11_66
set_property -dict {PACKAGE_PIN AB6  IOSTANDARD LVCMOS18} [get_ports gp0_dir]                ; ## H16  FMC0_LA11_P      IO_L10P_T1U_N6_QBC_AD4P_66
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVCMOS18} [get_ports gp1_dir]                ; ## C15  FMC0_LA10_N      IO_L15N_T2L_N5_AD11N_66
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18} [get_ports gp2_dir]                ; ## G15  FMC0_LA12_P      IO_L9P_T1L_N4_AD12P_66
set_property -dict {PACKAGE_PIN AB5  IOSTANDARD LVCMOS18} [get_ports gp3_dir]                ; ## H17  FMC0_LA11_N      IO_L10N_T1U_N7_QBC_AD4N_66
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS18} [get_ports en_psu]                 ; ## H19  FMC0_LA15_P      IO_L6P_T0U_N10_AD6P_66
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVCMOS18} [get_ports pwrgd]                  ; ## H20  FMC0_LA15_N      IO_L6N_T0U_N11_AD6N_66
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports pd_v33b]                ; ## H22  FMC0_LA19_P      IO_L23P_T3U_N8_67
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS18} [get_ports osc_en]                 ; ## G16  FMC0_LA12_N      IO_L9N_T1L_N5_AD12N_66
set_property -dict {PACKAGE_PIN V4   IOSTANDARD LVCMOS18} [get_ports ad4080_csn]             ; ## G12  FMC0_LA08_P      IO_L17P_T2U_N8_AD10P_66
set_property -dict {PACKAGE_PIN U4   IOSTANDARD LVCMOS18} [get_ports ad4080_sclk]            ; ## H14  FMC0_LA07_N      IO_L18N_T2U_N11_AD2N_66
set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVCMOS18} [get_ports ad4080_mosi]            ; ## G13  FMC0_LA08_N      IO_L17N_T2U_N9_AD10N_66
set_property -dict {PACKAGE_PIN U5   IOSTANDARD LVCMOS18} [get_ports ad4080_miso]            ; ## H13  FMC0_LA07_P      IO_L18P_T2U_N10_AD2P_66
set_property -dict {PACKAGE_PIN AC6  IOSTANDARD LVCMOS18} [get_ports ad9508_csn]             ; ## C19  FMC0_LA14_N      IO_L7N_T1L_N1_QBC_AD13N_66
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVCMOS18} [get_ports adf4350_csn]            ; ## C22  FMC0_LA18_CC_P   IO_L16P_T2U_N6_QBC_AD3P_67
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports ad9508_adf4350_sclk]    ; ## D18  FMC0_LA13_N      IO_L8N_T1L_N3_AD5N_66
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports ad9508_adf4350_miso]    ; ## D17  FMC0_LA13_P      IO_L8P_T1L_N2_AD5P_66
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVCMOS18} [get_ports ad9508_adf4350_mosi]    ; ## C18  FMC0_LA14_P      IO_L7P_T1L_N0_QBC_AD13P_66
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18} [get_ports doa_fmc]                ; ## H28  FMC0_LA24_P      IO_L18P_T2U_N10_AD2P_67
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18} [get_ports dob_fmc]                ; ## H29  FMC0_LA24_N      IO_L18N_T2U_N11_AD2N_67
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports doc_fmc]                ; ## G18  FMC0_LA16_P      IO_L5P_T0U_N8_AD14P_66
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports dod_fmc]                ; ## G19  FMC0_LA16_N      IO_L5N_T0U_N9_AD14N_66
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports ad9508_sync]            ; ## C10  FMC0_LA06_P      IO_L19P_T3L_N0_DBC_AD9P_66
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVCMOS18} [get_ports adf435x_lock]           ; ## C23  FMC0_LA18_CC_N   IO_L16N_T2U_N7_QBC_AD3N_67
#set_property SEVERITY {Warning} [get_drc_checks NSTD-1]                                      ; ## Warning: NSTD-1: Use of non-standard I/O Standard
#set_property SEVERITY {Warning} [get_drc_checks UCIO-1]                                      ; ## Warning: UCIO-1: I/O Standard - Unconstrained Input Only

# There was issues with the auto generated file - NA was appended to LVCMOS18 creating an invalid argument error, same with Diff_term (had no "1')
# clocks

create_clock -name dco_clk -period 2.500  [get_ports dco_p]
create_clock -name ref_clk -period 25.00  [get_ports clk_p]
create_clock -name fpga_clk -period 10.00  [get_ports fpgaclk_p]

# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[94]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[93]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[92]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[91]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[90]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[89]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[88]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[87]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[86]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[85]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[84]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[83]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[82]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[81]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[80]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[79]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[78]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[77]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[76]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[75]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[74]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[73]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[72]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[71]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[70]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[69]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[68]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[67]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[66]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[65]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[64]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[63]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[62]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[61]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[60]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[59]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[58]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[57]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[56]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[55]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[54]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[53]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[52]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[51]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[50]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[49]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[48]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[47]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[46]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[45]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[44]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[43]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[42]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[41]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[40]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[39]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[38]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[37]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[36]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[35]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[34]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[33]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[32]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[31]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[30]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[29]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[28]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[27]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[26]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[25]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[24]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[23]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[22]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[21]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[20]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[19]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[18]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[17]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[16]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[15]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[14]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[13]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[12]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[11]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[10]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[9]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[8]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[7]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[6]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[5]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[4]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[3]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[2]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[1]]
# set_property IOSTANDARD LVCMOS18 [get_ports gpio_bd_o[0]]
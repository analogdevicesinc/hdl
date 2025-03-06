###############################################################################
## Copyright (C) 2020-2024 Alog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################


# ad408x_fmc_evb
# set_property -dict {PACKAGE_PIN      IOSTANDARD } [get_ports ]                                  ; ##                       
set_property -dict {PACKAGE_PIN AA7  IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_p]               ; ## H4   FMC0_CLK0_M2C_P  IO_L12P_T1U_N10_GC_66
set_property -dict {PACKAGE_PIN AA6  IOSTANDARD LVDS DIFF_TERM 1} [get_ports dco_n]               ; ## H5   FMC0_CLK0_M2C_N  IO_L12N_T1U_N11_GC_66
set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_p]                ; ## H7   FMC0_LA02_P      IO_L23P_T3U_N8_66
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVDS DIFF_TERM 1} [get_ports da_n]                ; ## H8   FMC0_LA02_N      IO_L23N_T3U_N9_66
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_p]                ; ## G9   FMC0_LA03_P      IO_L22P_T3U_N6_DBC_AD0P_66
set_property -dict {PACKAGE_PIN Y1   IOSTANDARD LVDS DIFF_TERM 1} [get_ports db_n]                ; ## G10  FMC0_LA03_N      IO_L22N_T3U_N7_DBC_AD0N_66
set_property -dict {PACKAGE_PIN T8   IOSTANDARD LVDS DIFF_TERM 1} [get_ports cnv_in_p]            ; ## G2   FMC0_CLK1_M2C_P  IO_L12P_T1U_N10_GC_67
set_property -dict {PACKAGE_PIN R8   IOSTANDARD LVDS DIFF_TERM 1} [get_ports cnv_in_n]            ; ## G3   FMC0_CLK1_M2C_N  IO_L12N_T1U_N11_GC_67
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


# There was issues with the auto generated file - NA was appended to LVCMOS18 creating an invalid argument error, same with Diff_term (had no "1')
# clocks

create_clock -period 2.500 -name dco_clk  [get_ports dco_p]
create_clock -period 25.00 -name ref_clk  [get_ports clk_p]
create_clock -period 10.00 -name fpga_clk [get_ports fpgaclk_p]


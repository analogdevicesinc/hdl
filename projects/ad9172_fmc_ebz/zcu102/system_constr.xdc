
# ad9172 FMC signals

set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]   ; ## D08  FMC_HPC0_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_66_AB4 
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]   ; ## D09  FMC_HPC0_LA01_CC_N        IO_L16N_T2U_N7_QBC_AD3N_66_AC4 
set_property  -dict {PACKAGE_PIN  Y4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p] ; ## G06  FMC_HPC0_LA00_CC_P        IO_L13P_T2L_N0_GC_QBC_66_Y4 
set_property  -dict {PACKAGE_PIN  Y3  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n] ; ## G07  FMC_HPC0_LA00_CC_N        IO_L13N_T2L_N1_GC_QBC_66_Y3 

set_property  -dict {PACKAGE_PIN  AA1 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                    ; ## H11  FMC_HPC0_LA04_N           IO_L21N_T3L_N5_AD8N_66_AA1
set_property  -dict {PACKAGE_PIN  AB3 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                    ; ## D11  FMC_HPC0_LA05_P           IO_L20P_T3L_N2_AD1P_66_AB3
set_property  -dict {PACKAGE_PIN  AA2 IOSTANDARD LVCMOS18} [get_ports spi_miso]                       ; ## H10  FMC_HPC0_LA04_P           IO_L21P_T3L_N4_AD8P_66_AA2
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                       ; ## G10  FMC_HPC0_LA03_N           IO_L22N_T3U_N7_DBC_AD0N_66_Y1
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVCMOS18} [get_ports spi_clk]                        ; ## G09  FMC_HPC0_LA03_P           IO_L22P_T3U_N6_DBC_AD0P_66_Y2
set_property  -dict {PACKAGE_PIN  AC3 IOSTANDARD LVCMOS18} [get_ports spi_en_n]                       ; ## D12  FMC_HPC0_LA05_N           IO_L20N_T3L_N3_AD1N_66_AC3

set_property  -dict {PACKAGE_PIN  U5  IOSTANDARD LVCMOS18} [get_ports pe_ctrl]                        ; ## H13  FMC_HPC0_LA07_P           IO_L18P_T2U_N10_AD2P_66_U5 
set_property  -dict {PACKAGE_PIN  AC2 IOSTANDARD LVCMOS18} [get_ports txen_0]                         ; ## C10  FMC_HPC0_LA06_P           IO_L19P_T3L_N0_DBC_AD9P_66_AC2 
set_property  -dict {PACKAGE_PIN  AC1 IOSTANDARD LVCMOS18} [get_ports txen_1]                         ; ## C11  FMC_HPC0_LA06_N           IO_L19N_T3L_N1_DBC_AD9N_66_AC1 

set_property  -dict {PACKAGE_PIN  G8} [get_ports tx_ref_clk_p]                                        ; ## D04  FMC_HPC0_GBTCLK0_M2C_C_P  MGTREFCLK0P_229_G8 
set_property  -dict {PACKAGE_PIN  G7} [get_ports tx_ref_clk_n]                                        ; ## D05  FMC_HPC0_GBTCLK0_M2C_C_N  MGTREFCLK0N_229_G7

set_property  -dict {PACKAGE_PIN  P6} [get_ports tx_data_p[0]]                                        ; ## A38  FMC_HPC0_DP5_C2M_P        MGTHTXP1_228_P6
set_property  -dict {PACKAGE_PIN  P5} [get_ports tx_data_n[0]]                                        ; ## A39  FMC_HPC0_DP5_C2M_N        MGTHTXN1_228_P5
set_property  -dict {PACKAGE_PIN  R4} [get_ports tx_data_p[1]]                                        ; ## B36  FMC_HPC0_DP6_C2M_P        MGTHTXP0_228_R4
set_property  -dict {PACKAGE_PIN  R3} [get_ports tx_data_n[1]]                                        ; ## B37  FMC_HPC0_DP6_C2M_N        MGTHTXN0_228_R3
set_property  -dict {PACKAGE_PIN  M6} [get_ports tx_data_p[2]]                                        ; ## A34  FMC_HPC0_DP4_C2M_P        MGTHTXP3_228_M6
set_property  -dict {PACKAGE_PIN  M5} [get_ports tx_data_n[2]]                                        ; ## A35  FMC_HPC0_DP4_C2M_N        MGTHTXN3_228_M5
set_property  -dict {PACKAGE_PIN  N4} [get_ports tx_data_p[3]]                                        ; ## B32  FMC_HPC0_DP7_C2M_P        MGTHTXP2_228_N4
set_property  -dict {PACKAGE_PIN  N3} [get_ports tx_data_n[3]]                                        ; ## B33  FMC_HPC0_DP7_C2M_N        MGTHTXN2_228_N3
set_property  -dict {PACKAGE_PIN  K5} [get_ports tx_data_n[4]]                                        ; ## A31  FMC_HPC0_DP3_C2M_N        MGTHTXN0_229_K5
set_property  -dict {PACKAGE_PIN  K6} [get_ports tx_data_p[4]]                                        ; ## A30  FMC_HPC0_DP3_C2M_P        MGTHTXP0_229_K6
set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[5]]                                        ; ## A27  FMC_HPC0_DP2_C2M_N        MGTHTXN3_229_F5
set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[5]]                                        ; ## A26  FMC_HPC0_DP2_C2M_P        MGTHTXP3_229_F6
set_property  -dict {PACKAGE_PIN  H5} [get_ports tx_data_n[6]]                                        ; ## A23  FMC_HPC0_DP1_C2M_N        MGTHTXN1_229_H5
set_property  -dict {PACKAGE_PIN  H6} [get_ports tx_data_p[6]]                                        ; ## A22  FMC_HPC0_DP1_C2M_P        MGTHTXP1_229_H6
set_property  -dict {PACKAGE_PIN  G3} [get_ports tx_data_n[7]]                                        ; ## C03  FMC_HPC0_DP0_C2M_N        MGTHTXN2_229_G3
set_property  -dict {PACKAGE_PIN  G4} [get_ports tx_data_p[7]]                                        ; ## C02  FMC_HPC0_DP0_C2M_P        MGTHTXP2_229_G4

# clocks

create_clock -name tx_ref_clk   -period  2.65 [get_ports tx_ref_clk_p]

# exceptions
# We can't place the sysref in IOB, instead limit the input delay of the signal
# to the first sampling FF
set_max_delay -from [get_ports tx_sysref_*] \
              -to [get_pins i_system_wrapper/system_i/axi_ad9172_jesd/tx/inst/i_lmfc/sysref_r_reg/D] 2.0 \
              -datapath_only


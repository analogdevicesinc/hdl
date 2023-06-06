#
## Quad Apollo
#
## FMC+ Connections
#
## Serdes Data Input
#
set_property  -dict {PACKAGE_PIN AR46                                                         } [get_ports m2c_n[0]         ]; ## DP0_M2C_N       C7   MGTYRXN0_121
set_property  -dict {PACKAGE_PIN AR45                                                         } [get_ports m2c_p[0]         ]; ## DP0_M2C_P       C6   MGTYRXP0_121
set_property  -dict {PACKAGE_PIN AN45                                                         } [get_ports m2c_p[1]         ]; ## DP1_M2C_P       A2   MGTYRXP1_121
set_property  -dict {PACKAGE_PIN AN46                                                         } [get_ports m2c_n[1]         ]; ## DP1_M2C_N       A3   MGTYRXN1_121
set_property  -dict {PACKAGE_PIN AL45                                                         } [get_ports m2c_p[2]         ]; ## DP2_M2C_P       A6   MGTYRXP2_121
set_property  -dict {PACKAGE_PIN AL46                                                         } [get_ports m2c_n[2]         ]; ## DP2_M2C_N       A7   MGTYRXN2_121
set_property  -dict {PACKAGE_PIN AJ45                                                         } [get_ports m2c_p[3]         ]; ## DP3_M2C_P       A10  MGTYRXP3_121
set_property  -dict {PACKAGE_PIN AJ46                                                         } [get_ports m2c_n[3]         ]; ## DP3_M2C_N       A11  MGTYRXN3_121
set_property  -dict {PACKAGE_PIN W45                                                          } [get_ports m2c_p[4]         ]; ## DP4_M2C_P       A14  MGTYRXP0_126
set_property  -dict {PACKAGE_PIN W46                                                          } [get_ports m2c_n[4]         ]; ## DP4_M2C_N       A15  MGTYRXN0_126
set_property  -dict {PACKAGE_PIN U45                                                          } [get_ports m2c_p[5]         ]; ## DP5_M2C_P       A18  MGTYRXP1_126
set_property  -dict {PACKAGE_PIN U46                                                          } [get_ports m2c_n[5]         ]; ## DP5_M2C_N       A19  MGTYRXN1_126
set_property  -dict {PACKAGE_PIN R45                                                          } [get_ports m2c_p[6]         ]; ## DP6_M2C_P       B16  MGTYRXP2_126
set_property  -dict {PACKAGE_PIN R46                                                          } [get_ports m2c_n[6]         ]; ## DP6_M2C_N       B17  MGTYRXN2_126
set_property  -dict {PACKAGE_PIN N45                                                          } [get_ports m2c_p[7]         ]; ## DP7_M2C_P       B12  MGTYRXP3_126
set_property  -dict {PACKAGE_PIN N46                                                          } [get_ports m2c_n[7]         ]; ## DP7_M2C_N       B13  MGTYRXN3_126
set_property  -dict {PACKAGE_PIN AG45                                                         } [get_ports m2c_p[8]         ]; ## DP8_M2C_P       B8   MGTYRXP0_122
set_property  -dict {PACKAGE_PIN AG46                                                         } [get_ports m2c_n[8]         ]; ## DP8_M2C_N       B9   MGTYRXN0_122
set_property  -dict {PACKAGE_PIN AF43                                                         } [get_ports m2c_p[9]         ]; ## DP9_M2C_P       B4   MGTYRXP1_122
set_property  -dict {PACKAGE_PIN AF44                                                         } [get_ports m2c_n[9]         ]; ## DP9_M2C_N       B5   MGTYRXN1_122
set_property  -dict {PACKAGE_PIN AE45                                                         } [get_ports m2c_p[10]        ]; ## DP10_M2C_P      Y10  MGTYRXP2_122
set_property  -dict {PACKAGE_PIN AE46                                                         } [get_ports m2c_n[10]        ]; ## DP10_M2C_N      Y11  MGTYRXN2_122
set_property  -dict {PACKAGE_PIN AD43                                                         } [get_ports m2c_p[11]        ]; ## DP11_M2C_P      Z12  MGTYRXP3_122
set_property  -dict {PACKAGE_PIN AD44                                                         } [get_ports m2c_n[11]        ]; ## DP11_M2C_N      Z13  MGTYRXN3_122
set_property  -dict {PACKAGE_PIN AC45                                                         } [get_ports m2c_p[12]        ]; ## DP12_M2C_P      Y14  MGTYRXP0_125
set_property  -dict {PACKAGE_PIN AC46                                                         } [get_ports m2c_n[12]        ]; ## DP12_M2C_N      Y15  MGTYRXN0_125
set_property  -dict {PACKAGE_PIN AB43                                                         } [get_ports m2c_p[13]        ]; ## DP13_M2C_P      Z16  MGTYRXP1_125
set_property  -dict {PACKAGE_PIN AB44                                                         } [get_ports m2c_n[13]        ]; ## DP13_M2C_N      Z17  MGTYRXN1_125
set_property  -dict {PACKAGE_PIN AA45                                                         } [get_ports m2c_p[14]        ]; ## DP14_M2C_P      Y18  MGTYRXP2_125
set_property  -dict {PACKAGE_PIN AA46                                                         } [get_ports m2c_n[14]        ]; ## DP14_M2C_N      Y19  MGTYRXN2_125
set_property  -dict {PACKAGE_PIN Y43                                                          } [get_ports m2c_p[15]        ]; ## DP15_M2C_P      Y22  MGTYRXP3_125
set_property  -dict {PACKAGE_PIN Y44                                                          } [get_ports m2c_n[15]        ]; ## DP15_M2C_N      Y23  MGTYRXN3_125
#
## Serdes Data Output
#
set_property  -dict {PACKAGE_PIN AT42                                                         } [get_ports c2m_p[0]         ]; ## DP0_C2M_P       C2   MGTYTXP0_121
set_property  -dict {PACKAGE_PIN AT43                                                         } [get_ports c2m_n[0]         ]; ## DP0_C2M_N       C3   MGTYTXN0_121
set_property  -dict {PACKAGE_PIN AP42                                                         } [get_ports c2m_p[1]         ]; ## DP1_C2M_P       A22  MGTYTXP1_121
set_property  -dict {PACKAGE_PIN AP43                                                         } [get_ports c2m_n[1]         ]; ## DP1_C2M_N       A23  MGTYTXN1_121
set_property  -dict {PACKAGE_PIN AM42                                                         } [get_ports c2m_p[2]         ]; ## DP2_C2M_P       A26  MGTYTXP2_121
set_property  -dict {PACKAGE_PIN AM43                                                         } [get_ports c2m_n[2]         ]; ## DP2_C2M_N       A27  MGTYTXN2_121
set_property  -dict {PACKAGE_PIN AL40                                                         } [get_ports c2m_p[3]         ]; ## DP3_C2M_P       A30  MGTYTXP3_121
set_property  -dict {PACKAGE_PIN AL41                                                         } [get_ports c2m_n[3]         ]; ## DP3_C2M_N       A31  MGTYTXN3_121
set_property  -dict {PACKAGE_PIN T42                                                          } [get_ports c2m_p[4]         ]; ## DP4_C2M_P       A34  MGTYTXP0_126
set_property  -dict {PACKAGE_PIN T43                                                          } [get_ports c2m_n[4]         ]; ## DP4_C2M_N       A35  MGTYTXN0_126
set_property  -dict {PACKAGE_PIN P42                                                          } [get_ports c2m_p[5]         ]; ## DP5_C2M_P       A38  MGTYTXP1_126
set_property  -dict {PACKAGE_PIN P43                                                          } [get_ports c2m_n[5]         ]; ## DP5_C2M_N       A39  MGTYTXN1_126
set_property  -dict {PACKAGE_PIN M42                                                          } [get_ports c2m_p[6]         ]; ## DP6_C2M_P       B36  MGTYTXP2_126
set_property  -dict {PACKAGE_PIN M43                                                          } [get_ports c2m_n[6]         ]; ## DP6_C2M_N       B37  MGTYTXN2_126
set_property  -dict {PACKAGE_PIN K42                                                          } [get_ports c2m_p[7]         ]; ## DP7_C2M_P       B32  MGTYTXP3_126
set_property  -dict {PACKAGE_PIN K43                                                          } [get_ports c2m_n[7]         ]; ## DP7_C2M_N       B33  MGTYTXN3_126
set_property  -dict {PACKAGE_PIN AK42                                                         } [get_ports c2m_p[8]         ]; ## DP8_C2M_P       B28  MGTYTXP0_122
set_property  -dict {PACKAGE_PIN AK43                                                         } [get_ports c2m_n[8]         ]; ## DP8_C2M_N       B29  MGTYTXN0_122
set_property  -dict {PACKAGE_PIN AJ40                                                         } [get_ports c2m_p[9]         ]; ## DP9_C2M_P       B24  MGTYTXP1_122
set_property  -dict {PACKAGE_PIN AJ41                                                         } [get_ports c2m_n[9]         ]; ## DP9_C2M_N       B25  MGTYTXN1_122
set_property  -dict {PACKAGE_PIN AG40                                                         } [get_ports c2m_p[10]        ]; ## DP10_C2M_P      Z24  MGTYTXP2_122
set_property  -dict {PACKAGE_PIN AG41                                                         } [get_ports c2m_n[10]        ]; ## DP10_C2M_N      Z25  MGTYTXN2_122
set_property  -dict {PACKAGE_PIN AE40                                                         } [get_ports c2m_p[11]        ]; ## DP11_C2M_P      Y26  MGTYTXP3_122
set_property  -dict {PACKAGE_PIN AE41                                                         } [get_ports c2m_n[11]        ]; ## DP11_C2M_N      Y27  MGTYTXN3_122
set_property  -dict {PACKAGE_PIN AC40                                                         } [get_ports c2m_p[12]        ]; ## DP12_C2M_P      Z28  MGTYTXP0_125
set_property  -dict {PACKAGE_PIN AC41                                                         } [get_ports c2m_n[12]        ]; ## DP12_C2M_N      Z29  MGTYTXN0_125
set_property  -dict {PACKAGE_PIN AA40                                                         } [get_ports c2m_p[13]        ]; ## DP13_C2M_P      Y30  MGTYTXP1_125
set_property  -dict {PACKAGE_PIN AA41                                                         } [get_ports c2m_n[13]        ]; ## DP13_C2M_N      Y31  MGTYTXN1_125
set_property  -dict {PACKAGE_PIN W40                                                          } [get_ports c2m_p[14]        ]; ## DP14_C2M_P      M18  MGTYTXP2_125
set_property  -dict {PACKAGE_PIN W41                                                          } [get_ports c2m_n[14]        ]; ## DP14_C2M_N      M19  MGTYTXN2_125
set_property  -dict {PACKAGE_PIN U40                                                          } [get_ports c2m_p[15]        ]; ## DP15_C2M_P      M22  MGTYTXP3_125
set_property  -dict {PACKAGE_PIN U41                                                          } [get_ports c2m_n[15]        ]; ## DP15_C2M_N      M23  MGTYTXN3_125
#
## Refernce clocks
#
set_property  -dict {PACKAGE_PIN AK38                                                         } [get_ports ref_clk_p[0]     ]; ## GBTCLK0_M2C_P   D4   MGTREFCLK0P_121  
set_property  -dict {PACKAGE_PIN AK39                                                         } [get_ports ref_clk_n[0]     ]; ## GBTCLK0_M2C_N   D5   MGTREFCLK0N_121 
set_property  -dict {PACKAGE_PIN V38                                                          } [get_ports ref_clk_replica_p]; ## -               -    MGTREFCLK0P_126  
set_property  -dict {PACKAGE_PIN V39                                                          } [get_ports ref_clk_replica_n]; ## -               -    MGTREFCLK0N_126 
set_property  -dict {PACKAGE_PIN AM38                                                         } [get_ports ref_clk_p[1]      ]; ## GBTCLK1_M2C_P   B20  MGTREFCLK1P_120,120,121,122,125,126,127   
set_property  -dict {PACKAGE_PIN AM39                                                         } [get_ports ref_clk_n[1]      ]; ## GBTCLK1_M2C_N   B21  MGTREFCLK1N_120,120,121,122,125,126,127   
set_property  -dict {PACKAGE_PIN AL32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports ref_clk_p[2]      ]; ## CLK0_M2C_P      H4   IO_L13P_T2L_N0_GC_QBC_43
set_property  -dict {PACKAGE_PIN AM32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports ref_clk_n[2]      ]; ## CLK0_M2C_N      H5   IO_L13N_T2L_N1_GC_QBC_43
## Sysref
set_property  -dict {PACKAGE_PIN P35  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref_m2c_p     ]; ## CLK1_M2C_P      G2   IO_L14P_T2L_N2_GC_45
set_property  -dict {PACKAGE_PIN P36  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref_m2c_n     ]; ## CLK1_M2C_N      G3   IO_L14N_T2L_N3_GC_45
## Apollo SPIs
set_property  -dict {PACKAGE_PIN AL35 IOSTANDARD LVCMOS18                                     } [get_ports apollo_sclk[0]   ]; ## LA00_P_CC       G6   IO_L7P_T1L_N0_QBC_AD13P_43
set_property  -dict {PACKAGE_PIN AL36 IOSTANDARD LVCMOS18                                     } [get_ports apollo_sclk[1]   ]; ## LA00_N_CC       G7   IO_L7N_T1L_N1_QBC_AD13N_43
set_property  -dict {PACKAGE_PIN R34  IOSTANDARD LVCMOS18                                     } [get_ports apollo_sclk[2]   ]; ## LA17_P_CC       D20  IO_L13P_T2L_N0_GC_QBC_45
set_property  -dict {PACKAGE_PIN P34  IOSTANDARD LVCMOS18                                     } [get_ports apollo_sclk[3]   ]; ## LA17_N_CC       D21  IO_L13N_T2L_N1_GC_QBC_45
set_property  -dict {PACKAGE_PIN AJ32 IOSTANDARD LVCMOS18                                     } [get_ports apollo_sdio[0]   ]; ## LA02_P          H7   IO_L14P_T2L_N2_GC_43
set_property  -dict {PACKAGE_PIN AK32 IOSTANDARD LVCMOS18                                     } [get_ports apollo_sdio[1]   ]; ## LA02_N          H8   IO_L14N_T2L_N3_GC_43
set_property  -dict {PACKAGE_PIN N34  IOSTANDARD LVCMOS18                                     } [get_ports apollo_sdio[2]   ]; ## LA22_P          G24  IO_L20P_T3L_N2_AD1P_45
set_property  -dict {PACKAGE_PIN N35  IOSTANDARD LVCMOS18                                     } [get_ports apollo_sdio[3]   ]; ## LA22_N          G25  IO_L20N_T3L_N3_AD1N_45
set_property  -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18                                     } [get_ports apollo_csb[0]    ]; ## LA15_P          H19  IO_L24P_T3U_N10_43
set_property  -dict {PACKAGE_PIN AG33 IOSTANDARD LVCMOS18                                     } [get_ports apollo_csb[1]    ]; ## LA15_N          H20  IO_L24N_T3U_N11_43
set_property  -dict {PACKAGE_PIN N38  IOSTANDARD LVCMOS18                                     } [get_ports apollo_csb[2]    ]; ## LA30_P          H34  IO_L18P_T2U_N10_AD2P_45
set_property  -dict {PACKAGE_PIN M38  IOSTANDARD LVCMOS18                                     } [get_ports apollo_csb[3]    ]; ## LA30_N          H35  IO_L18N_T2U_N11_AD2N_45
## ADF4382
set_property  -dict {PACKAGE_PIN R31  IOSTANDARD LVCMOS18                                     } [get_ports art_sclk         ]; ## LA18_P_CC       C22  IO_L10P_T1U_N6_QBC_AD4P_45
set_property  -dict {PACKAGE_PIN P31  IOSTANDARD LVCMOS18                                     } [get_ports art_sdio         ]; ## LA18_N_CC       C23  IO_L10N_T1U_N7_QBC_AD4N_45
set_property  -dict {PACKAGE_PIN T34  IOSTANDARD LVCMOS18                                     } [get_ports art_csb[0]       ]; ## LA24_P          H28  IO_L6P_T0U_N10_AD6P_45
set_property  -dict {PACKAGE_PIN T35  IOSTANDARD LVCMOS18                                     } [get_ports art_csb[1]       ]; ## LA24_N          H29  IO_L6N_T0U_N11_AD6N_45
set_property  -dict {PACKAGE_PIN V32  IOSTANDARD LVCMOS18                                     } [get_ports art_csb[2]       ]; ## LA26_P          D26  IO_L2P_T0L_N2_45
set_property  -dict {PACKAGE_PIN U33  IOSTANDARD LVCMOS18                                     } [get_ports art_csb[3]       ]; ## LA26_N          D27  IO_L2N_T0L_N3_45
## ADF4030
# set_property  -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18                                     } [get_ports adf4030_sclk     ]; ## LA11_P          H16  IO_L17P_T2U_N8_AD10P_43
# set_property  -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18                                     } [get_ports adf4030_sdio     ]; ## LA11_N          H17  IO_L17N_T2U_N9_AD10N_43
# set_property  -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18                                     } [get_ports adf4030_csn      ]; ## LA04_N          H11  IO_L6N_T0U_N11_AD6N_43
## LTC6952
set_property  -dict {PACKAGE_PIN AL30 IOSTANDARD LVCMOS18                                     } [get_ports ltc6953_sclk     ]; ## LA01_P_CC       D8   IO_L16P_T2U_N6_QBC_AD3P_43
set_property  -dict {PACKAGE_PIN AL31 IOSTANDARD LVCMOS18                                     } [get_ports ltc6953_sdi      ]; ## LA01_N_CC       D9   IO_L16N_T2U_N7_QBC_AD3N_43
set_property  -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18                                     } [get_ports ltc6953_sdo      ]; ## LA10_P          C14  IO_L3P_T0L_N4_AD15P_43
set_property  -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18                                     } [get_ports ltc6953_csn[0]   ]; ## LA10_N          C15  IO_L3N_T0L_N5_AD15N_43
set_property  -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS18                                     } [get_ports ltc6953_csn[1]   ]; ## LA04_P          H10  IO_L6P_T0U_N10_AD6P_43
# ## HSCI
set_property  -dict {PACKAGE_PIN P37  IOSTANDARD LVDS                                         } [get_ports hsci_ckin_p[0]   ]; ## LA31_P          G33  IO_L16P_T2U_N6_QBC_AD3P_45
set_property  -dict {PACKAGE_PIN N37  IOSTANDARD LVDS                                         } [get_ports hsci_ckin_n[0]   ]; ## LA31_N          G34  IO_L16N_T2U_N7_QBC_AD3N_45
set_property  -dict {PACKAGE_PIN L34  IOSTANDARD LVDS                                         } [get_ports hsci_ckin_p[1]   ]; ## LA33_P          G36  IO_L19P_T3L_N0_DBC_AD9P_45
set_property  -dict {PACKAGE_PIN K34  IOSTANDARD LVDS                                         } [get_ports hsci_ckin_n[1]   ]; ## LA33_N          G37  IO_L19N_T3L_N1_DBC_AD9N_45
set_property  -dict {PACKAGE_PIN AG34 IOSTANDARD LVDS                                         } [get_ports hsci_ckin_p[2]   ]; ## LA16_P          G18  IO_L22P_T3U_N6_DBC_AD0P_43
set_property  -dict {PACKAGE_PIN AH35 IOSTANDARD LVDS                                         } [get_ports hsci_ckin_n[2]   ]; ## LA16_N          G19  IO_L22N_T3U_N7_DBC_AD0N_43
set_property  -dict {PACKAGE_PIN AT39 IOSTANDARD LVDS                                         } [get_ports hsci_ckin_p[3]   ]; ## LA03_P          G9   IO_L4P_T0U_N6_DBC_AD7P_43
set_property  -dict {PACKAGE_PIN AT40 IOSTANDARD LVDS                                         } [get_ports hsci_ckin_n[3]   ]; ## LA03_N          G10  IO_L4N_T0U_N7_DBC_AD7N_43
set_property  -dict {PACKAGE_PIN M36  IOSTANDARD LVDS                                         } [get_ports hsci_din_p[0]    ]; ## LA28_P          H31  IO_L17P_T2U_N8_AD10P_45
set_property  -dict {PACKAGE_PIN L36  IOSTANDARD LVDS                                         } [get_ports hsci_din_n[0]    ]; ## LA28_N          H32  IO_L17N_T2U_N9_AD10N_45
set_property  -dict {PACKAGE_PIN L33  IOSTANDARD LVDS                                         } [get_ports hsci_din_p[1]    ]; ## LA32_P          H37  IO_L21P_T3L_N4_AD8P_45
set_property  -dict {PACKAGE_PIN K33  IOSTANDARD LVDS                                         } [get_ports hsci_din_n[1]    ]; ## LA32_N          H38  IO_L21N_T3L_N5_AD8N_45
set_property  -dict {PACKAGE_PIN AG31 IOSTANDARD LVDS                                         } [get_ports hsci_din_p[2]    ]; ## LA14_P          C18  IO_L23P_T3U_N8_43
set_property  -dict {PACKAGE_PIN AH31 IOSTANDARD LVDS                                         } [get_ports hsci_din_n[2]    ]; ## LA14_N          C19  IO_L23N_T3U_N9_43
set_property  -dict {PACKAGE_PIN AP36 IOSTANDARD LVDS                                         } [get_ports hsci_din_p[3]    ]; ## LA07_P          H13  IO_L5P_T0U_N8_AD14P_43
set_property  -dict {PACKAGE_PIN AP37 IOSTANDARD LVDS                                         } [get_ports hsci_din_n[3]    ]; ## LA07_N          H14  IO_L5N_T0U_N9_AD14N_43
set_property  -dict {PACKAGE_PIN N33  IOSTANDARD LVDS                                         } [get_ports hsci_cko_p[0]    ]; ## LA19_P          H22  IO_L22P_T3U_N6_DBC_AD0P_45
set_property  -dict {PACKAGE_PIN M33  IOSTANDARD LVDS                                         } [get_ports hsci_cko_n[0]    ]; ## LA19_N          H23  IO_L22N_T3U_N7_DBC_AD0N_45
set_property  -dict {PACKAGE_PIN U35  IOSTANDARD LVDS                                         } [get_ports hsci_cko_p[1]    ]; ## LA29_P          G30  IO_L4P_T0U_N6_DBC_AD7P_45
set_property  -dict {PACKAGE_PIN T36  IOSTANDARD LVDS                                         } [get_ports hsci_cko_n[1]    ]; ## LA29_N          G31  IO_L4N_T0U_N7_DBC_AD7N_45
set_property  -dict {PACKAGE_PIN AJ33 IOSTANDARD LVDS                                         } [get_ports hsci_cko_p[2]    ]; ## LA09_P          D14  IO_L19P_T3L_N0_DBC_AD9P_43
set_property  -dict {PACKAGE_PIN AK33 IOSTANDARD LVDS                                         } [get_ports hsci_cko_n[2]    ]; ## LA09_N          D15  IO_L19N_T3L_N1_DBC_AD9N_43
set_property  -dict {PACKAGE_PIN AP38 IOSTANDARD LVDS                                         } [get_ports hsci_cko_p[3]    ]; ## LA05_P          D11  IO_L1P_T0L_N0_DBC_43
set_property  -dict {PACKAGE_PIN AR38 IOSTANDARD LVDS                                         } [get_ports hsci_cko_n[3]    ]; ## LA05_N          D12  IO_L1N_T0L_N1_DBC_43
set_property  -dict {PACKAGE_PIN N32  IOSTANDARD LVDS                                         } [get_ports hsci_do_p[0]     ]; ## LA20_P          G21  IO_L23P_T3U_N8_45
set_property  -dict {PACKAGE_PIN M32  IOSTANDARD LVDS                                         } [get_ports hsci_do_n[0]     ]; ## LA20_N          G22  IO_L23N_T3U_N9_45
set_property  -dict {PACKAGE_PIN V34  IOSTANDARD LVDS                                         } [get_ports hsci_do_n[1]     ]; ## LA27_N          C27  IO_L5P_T0U_N8_AD14P_45
set_property  -dict {PACKAGE_PIN V33  IOSTANDARD LVDS                                         } [get_ports hsci_do_p[1]     ]; ## LA27_P          C26  IO_L5N_T0U_N9_AD14N_45
set_property  -dict {PACKAGE_PIN AJ35 IOSTANDARD LVDS                                         } [get_ports hsci_do_p[2]     ]; ## LA13_P          D17  IO_L20P_T3L_N2_AD1P_43
set_property  -dict {PACKAGE_PIN AJ36 IOSTANDARD LVDS                                         } [get_ports hsci_do_n[2]     ]; ## LA13_N          D18  IO_L20N_T3L_N3_AD1N_43
set_property  -dict {PACKAGE_PIN AT35 IOSTANDARD LVDS                                         } [get_ports hsci_do_p[3]     ]; ## LA06_P          C10  IO_L2P_T0L_N2_43
set_property  -dict {PACKAGE_PIN AT36 IOSTANDARD LVDS                                         } [get_ports hsci_do_n[3]     ]; ## LA06_N          C11  IO_L2N_T0L_N3_43
## Trigger
set_property  -dict {PACKAGE_PIN W14  IOSTANDARD LVCMOS18                                     } [get_ports trig0_a[0]       ]; ## HA09_P          E9   IO_L6P_T0U_N10_AD6P_70
set_property  -dict {PACKAGE_PIN T14  IOSTANDARD LVCMOS18                                     } [get_ports trig0_a[1]       ]; ## HA16_P          E15  IO_L11P_T1U_N8_GC_70
set_property  -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18                                     } [get_ports trig0_a[2]       ]; ## HA08_P          F10  IO_L10P_T1U_N6_QBC_AD4P_70
set_property  -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18                                     } [get_ports trig0_a[3]       ]; ## HA15_P          F16  IO_L19P_T3L_N0_DBC_AD9P_70
set_property  -dict {PACKAGE_PIN V14  IOSTANDARD LVCMOS18                                     } [get_ports trig1_a[0]       ]; ## HA09_N          E10  IO_L6N_T0U_N11_AD6N_70
set_property  -dict {PACKAGE_PIN R13  IOSTANDARD LVCMOS18                                     } [get_ports trig1_a[1]       ]; ## HA16_N          E16  IO_L11N_T1U_N9_GC_70
set_property  -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18                                     } [get_ports trig1_a[2]       ]; ## HA08_N          F11  IO_L10N_T1U_N7_QBC_AD4N_70
set_property  -dict {PACKAGE_PIN M12  IOSTANDARD LVCMOS18                                     } [get_ports trig1_a[3]       ]; ## HA15_N          F17  IO_L19N_T3L_N1_DBC_AD9N_70
set_property  -dict {PACKAGE_PIN V13  IOSTANDARD LVCMOS18                                     } [get_ports trig0_b[0]       ]; ## HA13_P          E12  IO_L4P_T0U_N6_DBC_AD7P_70
set_property  -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18                                     } [get_ports trig0_b[1]       ]; ## HA20_P          E18  IO_L17P_T2U_N8_AD10P_70
set_property  -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS18                                     } [get_ports trig0_b[2]       ]; ## HA12_P          F13  IO_L9P_T1L_N4_AD12P_70
set_property  -dict {PACKAGE_PIN L14  IOSTANDARD LVCMOS18                                     } [get_ports trig0_b[3]       ]; ## HA19_P          F19  IO_L20P_T3L_N2_AD1P_70
set_property  -dict {PACKAGE_PIN U12  IOSTANDARD LVCMOS18                                     } [get_ports trig1_b[0]       ]; ## HA13_N          E13  IO_L4N_T0U_N7_DBC_AD7N_70
set_property  -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18                                     } [get_ports trig1_b[1]       ]; ## HA20_N          E19  IO_L17N_T2U_N9_AD10N_70
set_property  -dict {PACKAGE_PIN T15  IOSTANDARD LVCMOS18                                     } [get_ports trig1_b[2]       ]; ## HA12_N          F14  IO_L9N_T1L_N5_AD12N_70
set_property  -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18                                     } [get_ports trig1_b[3]       ]; ## HA19_N          F20  IO_L20N_T3L_N3_AD1N_70
## Reset
set_property  -dict {PACKAGE_PIN Y32  IOSTANDARD LVCMOS18                                     } [get_ports resetb[0]        ]; ## LA23_P          D23  IO_L1P_T0L_N0_DBC_45
set_property  -dict {PACKAGE_PIN W32  IOSTANDARD LVCMOS18                                     } [get_ports resetb[1]        ]; ## LA23_N          D24  IO_L1N_T0L_N1_DBC_45
set_property  -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18                                     } [get_ports resetb[2]        ]; ## LA12_P          G15  IO_L21P_T3L_N4_AD8P_43 
set_property  -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18                                     } [get_ports resetb[3]        ]; ## LA12_N          G16  IO_L21N_T3L_N5_AD8N_43
## GPIO
set_property  -dict {PACKAGE_PIN M35  IOSTANDARD LVCMOS18                                     } [get_ports txen[0]          ]; ## LA21_P          H25  IO_L24P_T3U_N10_45
set_property  -dict {PACKAGE_PIN L35  IOSTANDARD LVCMOS18                                     } [get_ports txen[1]          ]; ## LA21_N          H26  IO_L24N_T3U_N11_45
set_property  -dict {PACKAGE_PIN Y34  IOSTANDARD LVCMOS18                                     } [get_ports rxen[0]          ]; ## LA25_P          G27  IO_L3P_T0L_N4_AD15P_45
set_property  -dict {PACKAGE_PIN W34  IOSTANDARD LVCMOS18                                     } [get_ports rxen[1]          ]; ## LA25_N          G28  IO_L3N_T0L_N5_AD15N_45
set_property  -dict {PACKAGE_PIN N14  IOSTANDARD LVCMOS18                                     } [get_ports irqa[0]          ]; ## HA00_P_CC       F4   IO_L13P_T2L_N0_GC_QBC_70
set_property  -dict {PACKAGE_PIN V15  IOSTANDARD LVCMOS18                                     } [get_ports irqa[1]          ]; ## HA01_P_CC       E2   IO_L7P_T1L_N0_QBC_AD13P_70
set_property  -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18                                     } [get_ports irqa[2]          ]; ## HA04_P          F7   IO_L1P_T0L_N0_DBC_70
set_property  -dict {PACKAGE_PIN R14  IOSTANDARD LVCMOS18                                     } [get_ports irqa[3]          ]; ## HA05_P          E6   IO_L14P_T2L_N2_GC_70
set_property  -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18                                     } [get_ports irqb[0]          ]; ## HA00_N_CC       F5   IO_L13N_T2L_N1_GC_QBC_70
set_property  -dict {PACKAGE_PIN U15  IOSTANDARD LVCMOS18                                     } [get_ports irqb[1]          ]; ## HA01_N_CC       E3   IO_L7N_T1L_N1_QBC_AD13N_70
set_property  -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS18                                     } [get_ports irqb[2]          ]; ## HA04_N          F8   IO_L1N_T0L_N1_DBC_70
set_property  -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS18                                     } [get_ports irqb[3]          ]; ## HA05_N          E7   IO_L14N_T2L_N3_GC_70
set_property  -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18                                     } [get_ports txrxn[0]         ]; ## HA02_P          K7   IO_L5P_T0U_N8_AD14P_70
set_property  -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18                                     } [get_ports txrxn[1]         ]; ## HA02_N          K8   IO_L5N_T0U_N9_AD14N_70
set_property  -dict {PACKAGE_PIN W12  IOSTANDARD LVCMOS18                                     } [get_ports slice[0]         ]; ## HA03_P          J6   IO_L3P_T0L_N4_AD15P_70
set_property  -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS18                                     } [get_ports slice[1]         ]; ## HA03_N          J7   IO_L3N_T0L_N5_AD15N_70
set_property  -dict {PACKAGE_PIN U13  IOSTANDARD LVCMOS18                                     } [get_ports slice[2]         ]; ## HA06_P          K10  IO_L12P_T1U_N10_GC_70
set_property  -dict {PACKAGE_PIN T13  IOSTANDARD LVCMOS18                                     } [get_ports txrxwe           ]; ## HA06_N          K11  IO_L12N_T1U_N11_GC_70
set_property  -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS18                                     } [get_ports fcnsel[0]        ]; ## HA07_P          J9   IO_L2P_T0L_N2_70
set_property  -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS18                                     } [get_ports fcnsel[1]        ]; ## HA07_N          J10  IO_L2N_T0L_N3_70
set_property  -dict {PACKAGE_PIN V16  IOSTANDARD LVCMOS18                                     } [get_ports fcnsel[2]        ]; ## HA10_P          K13  IO_L8P_T1L_N2_AD5P_70
set_property  -dict {PACKAGE_PIN U16  IOSTANDARD LVCMOS18                                     } [get_ports profile[0]       ]; ## HA10_N          K14  IO_L8N_T1L_N3_AD5N_70
set_property  -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18                                     } [get_ports profile[1]       ]; ## HA11_P          J12  IO_L18P_T2U_N10_AD2P_70
set_property  -dict {PACKAGE_PIN P12  IOSTANDARD LVCMOS18                                     } [get_ports profile[2]       ]; ## HA11_N          J13  IO_L18N_T2U_N11_AD2N_70
set_property  -dict {PACKAGE_PIN R11  IOSTANDARD LVCMOS18                                     } [get_ports profile[3]       ]; ## HA17_P_CC       K16  IO_L16P_T2U_N6_QBC_AD3P_70
set_property  -dict {PACKAGE_PIN P11  IOSTANDARD LVCMOS18                                     } [get_ports profile[4]       ]; ## HA17_N_CC       K17  IO_L16N_T2U_N7_QBC_AD3N_70

set_property  -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18                                     } [get_ports hpf_b[0]         ]; ## LA08_P          G12  IO_L18P_T2U_N10_AD2P_43
set_property  -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18                                     } [get_ports hpf_b[1]         ]; ## LA08_N          G13  IO_L18N_T2U_N11_AD2N_43
set_property  -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18                                     } [get_ports hpf_b[2]         ]; ## HA14_P          J15  IO_L22P_T3U_N6_DBC_AD0P_70
set_property  -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18                                     } [get_ports hpf_b[3]         ]; ## HA14_N          J16  IO_L22N_T3U_N7_DBC_AD0N_70
set_property  -dict {PACKAGE_PIN K14  IOSTANDARD LVCMOS18                                     } [get_ports lpf_b[0]         ]; ## HA21_P          K19  IO_L23P_T3U_N8_70
set_property  -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18                                     } [get_ports lpf_b[1]         ]; ## HA21_N          K20  IO_L23N_T3U_N9_70
set_property  -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18                                     } [get_ports lpf_b[2]         ]; ## HA22_P          J21  IO_L24P_T3U_N10_70
set_property  -dict {PACKAGE_PIN J12  IOSTANDARD LVCMOS18                                     } [get_ports lpf_b[3]         ]; ## HA22_N          J22  IO_L24N_T3U_N11_70
set_property  -dict {PACKAGE_PIN N15  IOSTANDARD LVCMOS18                                     } [get_ports admv8913_cs_n    ]; ## HA18_N          J19  IO_L15N_T2L_N5_AD11N_70

set_property  -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18                                     } [get_ports hpf_b[0]         ]; ## LA08_P          G12  IO_L18P_T2U_N10_AD2P_43
## Syncin
# set_property  -dict {PACKAGE_PIN AN34 IOSTANDARD LVCMOS18                                     } [get_ports syncin_c2m_p     ]; ## SYNC_C2M_P      L16  IO_L8P_T1L_N2_AD5P_43
# set_property  -dict {PACKAGE_PIN AN35 IOSTANDARD LVCMOS18                                     } [get_ports syncin_c2m_n     ]; ## SYNC_C2M_N      L17  IO_L8N_T1L_N3_AD5N_43
## RX_DSA
set_property  -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[0]        ]; ## LA04_N          H11  IO_L6N_T0U_N11_AD6N_43
set_property  -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[1]        ]; ## LA11_P          H16  IO_L17P_T2U_N8_AD10P_43
set_property  -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[2]        ]; ## LA11_N          H17  IO_L17N_T2U_N9_AD10N_43
set_property  -dict {PACKAGE_PIN K11  IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[3]        ]; ## HA23_P          K22  IO_L21P_T3L_N4_AD8P_70
set_property  -dict {PACKAGE_PIN J11  IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[4]        ]; ## HA23_N          K23  IO_L21N_T3L_N5_AD8N_70
set_property  -dict {PACKAGE_PIN P15  IOSTANDARD LVCMOS18                                     } [get_ports rx_dsa[5]        ]; ## HA18_P          J18  IO_L15P_T2L_N4_AD11P_70
## FMC HPC Connections
# set_property  -dict {PACKAGE_PIN AW10 IOSTANDARD LVCMOS18                                     } [get_ports syncin_a1_n      ]; ## LA28_N          H32  IO_L4N_T0U_N7_DBC_AD7N_67
# set_property  -dict {PACKAGE_PIN AV10 IOSTANDARD LVCMOS18                                     } [get_ports syncin_a1_p      ]; ## LA28_P          H31  IO_L4P_T0U_N6_DBC_AD7P_67
# set_property  -dict {PACKAGE_PIN AP15 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports syncout_b0_n     ]; ## LA29_N          G31  IO_L18N_T2U_N11_AD2N_67
# set_property  -dict {PACKAGE_PIN AK12 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports syncout_b1_p     ]; ## LA30_P          H34  IO_L21P_T3L_N4_AD8P_67
# set_property  -dict {PACKAGE_PIN AN15 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b0_p[0]  ]; ## LA29_P          G30  IO_L18P_T2U_N10_AD2P_67
# set_property  -dict {PACKAGE_PIN AL12 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b1_n[0]  ]; ## LA30_N          H35  IO_L21N_T3L_N5_AD8N_67
# set_property  -dict {PACKAGE_PIN AM13 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b0_p[1]  ]; ## LA31_P          G33  IO_L23P_T3U_N8_67
# set_property  -dict {PACKAGE_PIN AM12 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b1_n[1]  ]; ## LA31_N          G34  IO_L23N_T3U_N9_67
# set_property  -dict {PACKAGE_PIN AJ13 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b0_p[2]  ]; ## LA32_P          H37  IO_L22P_T3U_N6_DBC_AD0P_67
# set_property  -dict {PACKAGE_PIN AJ12 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b1_n[2]  ]; ## LA32_N          H38  IO_L22N_T3U_N7_DBC_AD0N_67
# set_property  -dict {PACKAGE_PIN AK14 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b0_p[3]  ]; ## LA33_P          G36  IO_L24P_T3U_N10_67
# set_property  -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS18                                     } [get_ports syncout_b1_n[3]  ]; ## LA33_N          G37  IO_L24N_T3U_N11_67

set_property  -dict {PACKAGE_PIN AU11 IOSTANDARD LVCMOS18                                     } [get_ports gp4[0]           ]; ## LA21_P          H25  IO_L6P_T0U_N10_AD6P_67
set_property  -dict {PACKAGE_PIN AV11 IOSTANDARD LVCMOS18                                     } [get_ports gp5[0]           ]; ## LA21_N          H26  IO_L6N_T0U_N11_AD6N_67
set_property  -dict {PACKAGE_PIN AW13 IOSTANDARD LVCMOS18                                     } [get_ports gp4[1]           ]; ## LA22_P          G24  IO_L5P_T0U_N8_AD14P_67
set_property  -dict {PACKAGE_PIN AY13 IOSTANDARD LVCMOS18                                     } [get_ports gp5[1]           ]; ## LA22_N          G25  IO_L5N_T0U_N9_AD14N_67
set_property  -dict {PACKAGE_PIN AP13 IOSTANDARD LVCMOS18                                     } [get_ports gp4[2]           ]; ## LA24_P          H28  IO_L14P_T2L_N2_GC_67
set_property  -dict {PACKAGE_PIN AR13 IOSTANDARD LVCMOS18                                     } [get_ports gp5[2]           ]; ## LA24_N          H29  IO_L14N_T2L_N3_GC_67
set_property  -dict {PACKAGE_PIN AT12 IOSTANDARD LVCMOS18                                     } [get_ports gp4[3]           ]; ## LA25_P          G27  IO_L1P_T0L_N0_DBC_67
set_property  -dict {PACKAGE_PIN AU12 IOSTANDARD LVCMOS18                                     } [get_ports gp5[3]           ]; ## LA25_N          G28  IO_L1N_T0L_N1_DBC_67

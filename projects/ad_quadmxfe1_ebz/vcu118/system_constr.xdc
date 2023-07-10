###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## quad mxfe
#
set_property  -dict {PACKAGE_PIN V33   IOSTANDARD LVCMOS18                       } [get_ports adf4371_cs[0]            ]; ## LA27_P         C26  IO_L5P_T0U_N8_AD14P_45
set_property  -dict {PACKAGE_PIN V34   IOSTANDARD LVCMOS18                       } [get_ports adf4371_cs[1]            ]; ## LA27_N         C27  IO_L5N_T0U_N9_AD14N_45
set_property  -dict {PACKAGE_PIN V32   IOSTANDARD LVCMOS18                       } [get_ports adf4371_cs[2]            ]; ## LA26_P         D26  IO_L2P_T0L_N2_45
set_property  -dict {PACKAGE_PIN U33   IOSTANDARD LVCMOS18                       } [get_ports adf4371_cs[3]            ]; ## LA26_N         D27  IO_L2N_T0L_N3_45
set_property  -dict {PACKAGE_PIN R31   IOSTANDARD LVCMOS18                       } [get_ports adf4371_sclk             ]; ## LA18_P_CC      C22  IO_L10P_T1U_N6_QBC_AD4P_45
set_property  -dict {PACKAGE_PIN P31   IOSTANDARD LVCMOS18                       } [get_ports adf4371_sdio             ]; ## LA18_N_CC      C23  IO_L10N_T1U_N7_QBC_AD4N_45
set_property  -dict {PACKAGE_PIN W32   IOSTANDARD LVCMOS18                       } [get_ports adrf5020_ctrl            ]; ## LA23_N         D24  IO_L1N_T0L_N1_DBC_45
set_property  -dict {PACKAGE_PIN P43                                             } [get_ports c2m_n[0]                 ]; ## DP5_C2M_N      A39  MGTYTXN1_126
set_property  -dict {PACKAGE_PIN AC41                                            } [get_ports c2m_n[1]                 ]; ## DP12_C2M_N     Z29  MGTYTXN0_125
set_property  -dict {PACKAGE_PIN AA41                                            } [get_ports c2m_n[2]                 ]; ## DP13_C2M_N     Y31  MGTYTXN1_125
set_property  -dict {PACKAGE_PIN AE41                                            } [get_ports c2m_n[3]                 ]; ## DP11_C2M_N     Y27  MGTYTXN3_122
set_property  -dict {PACKAGE_PIN AL41                                            } [get_ports c2m_n[4]                 ]; ## DP3_C2M_N      A31  MGTYTXN3_121
set_property  -dict {PACKAGE_PIN K43                                             } [get_ports c2m_n[5]                 ]; ## DP7_C2M_N      B33  MGTYTXN3_126
set_property  -dict {PACKAGE_PIN T43                                             } [get_ports c2m_n[6]                 ]; ## DP4_C2M_N      A35  MGTYTXN0_126
set_property  -dict {PACKAGE_PIN M43                                             } [get_ports c2m_n[7]                 ]; ## DP6_C2M_N      B37  MGTYTXN2_126
set_property  -dict {PACKAGE_PIN AG41                                            } [get_ports c2m_n[8]                 ]; ## DP10_C2M_N     Z25  MGTYTXN2_122
set_property  -dict {PACKAGE_PIN AJ41                                            } [get_ports c2m_n[9]                 ]; ## DP9_C2M_N      B25  MGTYTXN1_122
set_property  -dict {PACKAGE_PIN AM43                                            } [get_ports c2m_n[10]                ]; ## DP2_C2M_N      A27  MGTYTXN2_121
set_property  -dict {PACKAGE_PIN AK43                                            } [get_ports c2m_n[11]                ]; ## DP8_C2M_N      B29  MGTYTXN0_122
set_property  -dict {PACKAGE_PIN AT43                                            } [get_ports c2m_n[12]                ]; ## DP0_C2M_N      C03  MGTYTXN0_121
set_property  -dict {PACKAGE_PIN W41                                             } [get_ports c2m_n[13]                ]; ## DP14_C2M_N     M19  MGTYTXN2_125
set_property  -dict {PACKAGE_PIN AP43                                            } [get_ports c2m_n[14]                ]; ## DP1_C2M_N      A23  MGTYTXN1_121
set_property  -dict {PACKAGE_PIN U41                                             } [get_ports c2m_n[15]                ]; ## DP15_C2M_N     M23  MGTYTXN3_125
set_property  -dict {PACKAGE_PIN P42                                             } [get_ports c2m_p[0]                 ]; ## DP5_C2M_P      A38  MGTYTXP1_126
set_property  -dict {PACKAGE_PIN AC40                                            } [get_ports c2m_p[1]                 ]; ## DP12_C2M_P     Z28  MGTYTXP0_125
set_property  -dict {PACKAGE_PIN AA40                                            } [get_ports c2m_p[2]                 ]; ## DP13_C2M_P     Y30  MGTYTXP1_125
set_property  -dict {PACKAGE_PIN AE40                                            } [get_ports c2m_p[3]                 ]; ## DP11_C2M_P     Y26  MGTYTXP3_122
set_property  -dict {PACKAGE_PIN AL40                                            } [get_ports c2m_p[4]                 ]; ## DP3_C2M_P      A30  MGTYTXP3_121
set_property  -dict {PACKAGE_PIN K42                                             } [get_ports c2m_p[5]                 ]; ## DP7_C2M_P      B32  MGTYTXP3_126
set_property  -dict {PACKAGE_PIN T42                                             } [get_ports c2m_p[6]                 ]; ## DP4_C2M_P      A34  MGTYTXP0_126
set_property  -dict {PACKAGE_PIN M42                                             } [get_ports c2m_p[7]                 ]; ## DP6_C2M_P      B36  MGTYTXP2_126
set_property  -dict {PACKAGE_PIN AG40                                            } [get_ports c2m_p[8]                 ]; ## DP10_C2M_P     Z24  MGTYTXP2_122
set_property  -dict {PACKAGE_PIN AJ40                                            } [get_ports c2m_p[9]                 ]; ## DP9_C2M_P      B24  MGTYTXP1_122
set_property  -dict {PACKAGE_PIN AM42                                            } [get_ports c2m_p[10]                ]; ## DP2_C2M_P      A26  MGTYTXP2_121
set_property  -dict {PACKAGE_PIN AK42                                            } [get_ports c2m_p[11]                ]; ## DP8_C2M_P      B28  MGTYTXP0_122
set_property  -dict {PACKAGE_PIN AT42                                            } [get_ports c2m_p[12]                ]; ## DP0_C2M_P      C02  MGTYTXP0_121
set_property  -dict {PACKAGE_PIN W40                                             } [get_ports c2m_p[13]                ]; ## DP14_C2M_P     M18  MGTYTXP2_125
set_property  -dict {PACKAGE_PIN AP42                                            } [get_ports c2m_p[14]                ]; ## DP1_C2M_P      A22  MGTYTXP1_121
set_property  -dict {PACKAGE_PIN U40                                             } [get_ports c2m_p[15]                ]; ## DP15_C2M_P     M22  MGTYTXP3_125
set_property  -dict {PACKAGE_PIN AK39                                            } [get_ports fpga_clk_m2c_n[0]        ]; ## GBTCLK0_M2C_N  D05  MGTREFCLK0N_121
set_property  -dict {PACKAGE_PIN V39                                             } [get_ports fpga_clk_m2c_0_replica_n ]; ## -              -    MGTREFCLK0N_126
set_property  -dict {PACKAGE_PIN P34   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_clk_m2c_n[1]        ]; ## LA17_N_CC      D21  IO_L13N_T2L_N1_GC_QBC_45
set_property  -dict {PACKAGE_PIN AM32  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_clk_m2c_n[2]        ]; ## CLK0_M2C_N     H05  IO_L13N_T2L_N1_GC_QBC_43
set_property  -dict {PACKAGE_PIN AK38                                            } [get_ports fpga_clk_m2c_p[0]        ]; ## GBTCLK0_M2C_P  D04  MGTREFCLK0P_121
set_property  -dict {PACKAGE_PIN V38                                             } [get_ports fpga_clk_m2c_0_replica_p ]; ## -              -    MGTREFCLK0P_126
set_property  -dict {PACKAGE_PIN R34   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_clk_m2c_p[1]        ]; ## LA17_P_CC      D20  IO_L13P_T2L_N0_GC_QBC_45
set_property  -dict {PACKAGE_PIN AL32  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_clk_m2c_p[2]        ]; ## CLK0_M2C_P     H04  IO_L13P_T2L_N0_GC_QBC_43
set_property  -dict {PACKAGE_PIN AL36  IOSTANDARD LVDS                           } [get_ports fpga_sysref_c2m_n        ]; ## LA00_N_CC      G07  IO_L7N_T1L_N1_QBC_AD13N_43
set_property  -dict {PACKAGE_PIN AL35  IOSTANDARD LVDS                           } [get_ports fpga_sysref_c2m_p        ]; ## LA00_P_CC      G06  IO_L7P_T1L_N0_QBC_AD13P_43
set_property  -dict {PACKAGE_PIN P36   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_sysref_m2c_n        ]; ## CLK1_M2C_N     G03  IO_L14N_T2L_N3_GC_45
set_property  -dict {PACKAGE_PIN P35   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_sysref_m2c_p        ]; ## CLK1_M2C_P     G02  IO_L14P_T2L_N2_GC_45
set_property  -dict {PACKAGE_PIN AH31  IOSTANDARD LVCMOS18                       } [get_ports hmc425a_v[1]             ]; ## LA14_N         C19  IO_L23N_T3U_N9_43
set_property  -dict {PACKAGE_PIN AG31  IOSTANDARD LVCMOS18                       } [get_ports hmc425a_v[2]             ]; ## LA14_P         C18  IO_L23P_T3U_N8_43
set_property  -dict {PACKAGE_PIN AR35  IOSTANDARD LVCMOS18                       } [get_ports hmc425a_v[3]             ]; ## LA10_N         C15  IO_L3N_T0L_N5_AD15N_43
set_property  -dict {PACKAGE_PIN AP35  IOSTANDARD LVCMOS18                       } [get_ports hmc425a_v[4]             ]; ## LA10_P         C14  IO_L3P_T0L_N4_AD15P_43
set_property  -dict {PACKAGE_PIN Y32   IOSTANDARD LVCMOS18                       } [get_ports hmc7043_gpio             ]; ## LA23_P         D23  IO_L1P_T0L_N0_DBC_45
set_property  -dict {PACKAGE_PIN AJ35  IOSTANDARD LVCMOS18                       } [get_ports hmc7043_reset            ]; ## LA13_P         D17  IO_L20P_T3L_N2_AD1P_43
set_property  -dict {PACKAGE_PIN AT35  IOSTANDARD LVCMOS18                       } [get_ports hmc7043_sclk             ]; ## LA06_P         C10  IO_L2P_T0L_N2_43
set_property  -dict {PACKAGE_PIN AT36  IOSTANDARD LVCMOS18                       } [get_ports hmc7043_sdata            ]; ## LA06_N         C11  IO_L2N_T0L_N3_43
set_property  -dict {PACKAGE_PIN AJ36  IOSTANDARD LVCMOS18                       } [get_ports hmc7043_slen             ]; ## LA13_N         D18  IO_L20N_T3L_N3_AD1N_43
set_property  -dict {PACKAGE_PIN U46                                             } [get_ports m2c_n[0]                 ]; ## DP5_M2C_N      A19  MGTYRXN1_126
set_property  -dict {PACKAGE_PIN AA46                                            } [get_ports m2c_n[1]                 ]; ## DP14_M2C_N     Y19  MGTYRXN2_125
set_property  -dict {PACKAGE_PIN Y44                                             } [get_ports m2c_n[2]                 ]; ## DP15_M2C_N     Y23  MGTYRXN3_125
set_property  -dict {PACKAGE_PIN AB44                                            } [get_ports m2c_n[3]                 ]; ## DP13_M2C_N     Z17  MGTYRXN1_125
set_property  -dict {PACKAGE_PIN AJ46                                            } [get_ports m2c_n[4]                 ]; ## DP3_M2C_N      A11  MGTYRXN3_121
set_property  -dict {PACKAGE_PIN N46                                             } [get_ports m2c_n[5]                 ]; ## DP7_M2C_N      B13  MGTYRXN3_126
set_property  -dict {PACKAGE_PIN W46                                             } [get_ports m2c_n[6]                 ]; ## DP4_M2C_N      A15  MGTYRXN0_126
set_property  -dict {PACKAGE_PIN R46                                             } [get_ports m2c_n[7]                 ]; ## DP6_M2C_N      B17  MGTYRXN2_126
set_property  -dict {PACKAGE_PIN AL46                                            } [get_ports m2c_n[8]                 ]; ## DP2_M2C_N      A07  MGTYRXN2_121
set_property  -dict {PACKAGE_PIN AF44                                            } [get_ports m2c_n[9]                 ]; ## DP9_M2C_N      B05  MGTYRXN1_122
set_property  -dict {PACKAGE_PIN AR46                                            } [get_ports m2c_n[10]                ]; ## DP0_M2C_N      C07  MGTYRXN0_121
set_property  -dict {PACKAGE_PIN AG46                                            } [get_ports m2c_n[11]                ]; ## DP8_M2C_N      B09  MGTYRXN0_122
set_property  -dict {PACKAGE_PIN AC46                                            } [get_ports m2c_n[12]                ]; ## DP12_M2C_N     Y15  MGTYRXN0_125
set_property  -dict {PACKAGE_PIN AD44                                            } [get_ports m2c_n[13]                ]; ## DP11_M2C_N     Z13  MGTYRXN3_122
set_property  -dict {PACKAGE_PIN AE46                                            } [get_ports m2c_n[14]                ]; ## DP10_M2C_N     Y11  MGTYRXN2_122
set_property  -dict {PACKAGE_PIN AN46                                            } [get_ports m2c_n[15]                ]; ## DP1_M2C_N      A03  MGTYRXN1_121
set_property  -dict {PACKAGE_PIN U45                                             } [get_ports m2c_p[0]                 ]; ## DP5_M2C_P      A18  MGTYRXP1_126
set_property  -dict {PACKAGE_PIN AA45                                            } [get_ports m2c_p[1]                 ]; ## DP14_M2C_P     Y18  MGTYRXP2_125
set_property  -dict {PACKAGE_PIN Y43                                             } [get_ports m2c_p[2]                 ]; ## DP15_M2C_P     Y22  MGTYRXP3_125
set_property  -dict {PACKAGE_PIN AB43                                            } [get_ports m2c_p[3]                 ]; ## DP13_M2C_P     Z16  MGTYRXP1_125
set_property  -dict {PACKAGE_PIN AJ45                                            } [get_ports m2c_p[4]                 ]; ## DP3_M2C_P      A10  MGTYRXP3_121
set_property  -dict {PACKAGE_PIN N45                                             } [get_ports m2c_p[5]                 ]; ## DP7_M2C_P      B12  MGTYRXP3_126
set_property  -dict {PACKAGE_PIN W45                                             } [get_ports m2c_p[6]                 ]; ## DP4_M2C_P      A14  MGTYRXP0_126
set_property  -dict {PACKAGE_PIN R45                                             } [get_ports m2c_p[7]                 ]; ## DP6_M2C_P      B16  MGTYRXP2_126
set_property  -dict {PACKAGE_PIN AL45                                            } [get_ports m2c_p[8]                 ]; ## DP2_M2C_P      A06  MGTYRXP2_121
set_property  -dict {PACKAGE_PIN AF43                                            } [get_ports m2c_p[9]                 ]; ## DP9_M2C_P      B04  MGTYRXP1_122
set_property  -dict {PACKAGE_PIN AR45                                            } [get_ports m2c_p[10]                ]; ## DP0_M2C_P      C06  MGTYRXP0_121
set_property  -dict {PACKAGE_PIN AG45                                            } [get_ports m2c_p[11]                ]; ## DP8_M2C_P      B08  MGTYRXP0_122
set_property  -dict {PACKAGE_PIN AC45                                            } [get_ports m2c_p[12]                ]; ## DP12_M2C_P     Y14  MGTYRXP0_125
set_property  -dict {PACKAGE_PIN AD43                                            } [get_ports m2c_p[13]                ]; ## DP11_M2C_P     Z12  MGTYRXP3_122
set_property  -dict {PACKAGE_PIN AE45                                            } [get_ports m2c_p[14]                ]; ## DP10_M2C_P     Y10  MGTYRXP2_122
set_property  -dict {PACKAGE_PIN AN45                                            } [get_ports m2c_p[15]                ]; ## DP1_M2C_P      A02  MGTYRXP1_121
set_property  -dict {PACKAGE_PIN Y13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_cs[0]               ]; ## HA04_N         F08  IO_L1N_T0L_N1_DBC_70
set_property  -dict {PACKAGE_PIN AT37  IOSTANDARD LVCMOS18                       } [get_ports mxfe_cs[1]               ]; ## LA04_N         H11  IO_L6N_T0U_N11_AD6N_43
set_property  -dict {PACKAGE_PIN K13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_cs[2]               ]; ## HA21_N         K20  IO_L23N_T3U_N9_70
set_property  -dict {PACKAGE_PIN AR38  IOSTANDARD LVCMOS18                       } [get_ports mxfe_cs[3]               ]; ## LA05_N         D12  IO_L1N_T0L_N1_DBC_43
set_property  -dict {PACKAGE_PIN N13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_miso[0]             ]; ## HA00_N_CC      F05  IO_L13N_T2L_N1_GC_QBC_70
set_property  -dict {PACKAGE_PIN AT40  IOSTANDARD LVCMOS18                       } [get_ports mxfe_miso[1]             ]; ## LA03_N         G10  IO_L4N_T0U_N7_DBC_AD7N_43
set_property  -dict {PACKAGE_PIN P11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_miso[2]             ]; ## HA17_N_CC      K17  IO_L16N_T2U_N7_QBC_AD3N_70
set_property  -dict {PACKAGE_PIN AL31  IOSTANDARD LVCMOS18                       } [get_ports mxfe_miso[3]             ]; ## LA01_N_CC      D09  IO_L16N_T2U_N7_QBC_AD3N_43
set_property  -dict {PACKAGE_PIN AA13  IOSTANDARD LVCMOS18                       } [get_ports mxfe_mosi[0]             ]; ## HA04_P         F07  IO_L1P_T0L_N0_DBC_70
set_property  -dict {PACKAGE_PIN AR37  IOSTANDARD LVCMOS18                       } [get_ports mxfe_mosi[1]             ]; ## LA04_P         H10  IO_L6P_T0U_N10_AD6P_43
set_property  -dict {PACKAGE_PIN K14   IOSTANDARD LVCMOS18                       } [get_ports mxfe_mosi[2]             ]; ## HA21_P         K19  IO_L23P_T3U_N8_70
set_property  -dict {PACKAGE_PIN AP38  IOSTANDARD LVCMOS18                       } [get_ports mxfe_mosi[3]             ]; ## LA05_P         D11  IO_L1P_T0L_N0_DBC_43
set_property  -dict {PACKAGE_PIN AK29  IOSTANDARD LVCMOS18                       } [get_ports mxfe_reset[0]            ]; ## LA08_P         G12  IO_L18P_T2U_N10_AD2P_43
set_property  -dict {PACKAGE_PIN N33   IOSTANDARD LVCMOS18                       } [get_ports mxfe_reset[1]            ]; ## LA19_P         H22  IO_L22P_T3U_N6_DBC_AD0P_45
set_property  -dict {PACKAGE_PIN W12   IOSTANDARD LVCMOS18                       } [get_ports mxfe_reset[2]            ]; ## HA03_P         J06  IO_L3P_T0L_N4_AD15P_70
set_property  -dict {PACKAGE_PIN T16   IOSTANDARD LVCMOS18                       } [get_ports mxfe_reset[3]            ]; ## HA12_P         F13  IO_L9P_T1L_N4_AD12P_70
set_property  -dict {PACKAGE_PIN L34   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en0[0]           ]; ## LA33_P         G36  IO_L19P_T3L_N0_DBC_AD9P_45
set_property  -dict {PACKAGE_PIN AP36  IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en0[1]           ]; ## LA07_P         H13  IO_L5P_T0U_N8_AD14P_43
set_property  -dict {PACKAGE_PIN V16   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en0[2]           ]; ## HA10_P         K13  IO_L8P_T1L_N2_AD5P_70
set_property  -dict {PACKAGE_PIN M15   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en0[3]           ]; ## HA20_P         E18  IO_L17P_T2U_N8_AD10P_70
set_property  -dict {PACKAGE_PIN K34   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en1[0]           ]; ## LA33_N         G37  IO_L19N_T3L_N1_DBC_AD9N_45
set_property  -dict {PACKAGE_PIN AP37  IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en1[1]           ]; ## LA07_N         H14  IO_L5N_T0U_N9_AD14N_43
set_property  -dict {PACKAGE_PIN U16   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en1[2]           ]; ## HA10_N         K14  IO_L8N_T1L_N3_AD5N_70
set_property  -dict {PACKAGE_PIN L15   IOSTANDARD LVCMOS18                       } [get_ports mxfe_rx_en1[3]           ]; ## HA20_N         E19  IO_L17N_T2U_N9_AD10N_70
set_property  -dict {PACKAGE_PIN N14   IOSTANDARD LVCMOS18                       } [get_ports mxfe_sclk[0]             ]; ## HA00_P_CC      F04  IO_L13P_T2L_N0_GC_QBC_70
set_property  -dict {PACKAGE_PIN AT39  IOSTANDARD LVCMOS18                       } [get_ports mxfe_sclk[1]             ]; ## LA03_P         G09  IO_L4P_T0U_N6_DBC_AD7P_43
set_property  -dict {PACKAGE_PIN R11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_sclk[2]             ]; ## HA17_P_CC      K16  IO_L16P_T2U_N6_QBC_AD3P_70
set_property  -dict {PACKAGE_PIN AL30  IOSTANDARD LVCMOS18                       } [get_ports mxfe_sclk[3]             ]; ## LA01_P_CC      D08  IO_L16P_T2U_N6_QBC_AD3P_43
set_property  -dict {PACKAGE_PIN T36   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_0_n          ]; ## LA29_N         G31  IO_L4N_T0U_N7_DBC_AD7N_45
set_property  -dict {PACKAGE_PIN AJ31  IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_1_n          ]; ## LA11_N         H17  IO_L17N_T2U_N9_AD10N_43
set_property  -dict {PACKAGE_PIN Y12   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_2_n          ]; ## HA02_N         K08  IO_L5N_T0U_N9_AD14N_70
set_property  -dict {PACKAGE_PIN U12   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_3_n          ]; ## HA13_N         E13  IO_L4N_T0U_N7_DBC_AD7N_70
set_property  -dict {PACKAGE_PIN W34   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_0_p          ]; ## LA25_N         G28  IO_L3N_T0L_N5_AD15N_45
set_property  -dict {PACKAGE_PIN U35   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_1_p          ]; ## LA29_P         G30  IO_L4P_T0U_N6_DBC_AD7P_45
set_property  -dict {PACKAGE_PIN K33   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_2_p          ]; ## LA32_N         H38  IO_L21N_T3L_N5_AD8N_45
set_property  -dict {PACKAGE_PIN AJ30  IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_3_p          ]; ## LA11_P         H16  IO_L17P_T2U_N8_AD10P_43
set_property  -dict {PACKAGE_PIN J12   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_4_p          ]; ## HA22_N         J22  IO_L24N_T3U_N11_70
set_property  -dict {PACKAGE_PIN AA12  IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_5_p          ]; ## HA02_P         K07  IO_L5P_T0U_N8_AD14P_70
set_property  -dict {PACKAGE_PIN V14   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_6_p          ]; ## HA09_N         E10  IO_L6N_T0U_N11_AD6N_70
set_property  -dict {PACKAGE_PIN V13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncin_7_p          ]; ## HA13_P         E12  IO_L4P_T0U_N6_DBC_AD7P_70
set_property  -dict {PACKAGE_PIN N37   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_0_n         ]; ## LA31_N         G34  IO_L16N_T2U_N7_QBC_AD3N_45
set_property  -dict {PACKAGE_PIN AG33  IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_1_n         ]; ## LA15_N         H20  IO_L24N_T3U_N11_43
set_property  -dict {PACKAGE_PIN T13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_2_n         ]; ## HA06_N         K11  IO_L12N_T1U_N11_GC_70
set_property  -dict {PACKAGE_PIN R13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_3_n         ]; ## HA16_N         E16  IO_L11N_T1U_N9_GC_70
set_property  -dict {PACKAGE_PIN Y34   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_0_p         ]; ## LA25_P         G27  IO_L3P_T0L_N4_AD15P_45
set_property  -dict {PACKAGE_PIN P37   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_1_p         ]; ## LA31_P         G33  IO_L16P_T2U_N6_QBC_AD3P_45
set_property  -dict {PACKAGE_PIN L33   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_2_p         ]; ## LA32_P         H37  IO_L21P_T3L_N4_AD8P_45
set_property  -dict {PACKAGE_PIN AG32  IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_3_p         ]; ## LA15_P         H19  IO_L24P_T3U_N10_43
set_property  -dict {PACKAGE_PIN K12   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_4_p         ]; ## HA22_P         J21  IO_L24P_T3U_N10_70
set_property  -dict {PACKAGE_PIN U13   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_5_p         ]; ## HA06_P         K10  IO_L12P_T1U_N10_GC_70
set_property  -dict {PACKAGE_PIN W14   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_6_p         ]; ## HA09_P         E09  IO_L6P_T0U_N10_AD6P_70
set_property  -dict {PACKAGE_PIN T14   IOSTANDARD LVCMOS18                       } [get_ports mxfe_syncout_7_p         ]; ## HA16_P         E15  IO_L11P_T1U_N8_GC_70
set_property  -dict {PACKAGE_PIN U11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en0[0]           ]; ## HA08_P         F10  IO_L10P_T1U_N6_QBC_AD4P_70
set_property  -dict {PACKAGE_PIN AJ32  IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en0[1]           ]; ## LA02_P         H07  IO_L14P_T2L_N2_GC_43
set_property  -dict {PACKAGE_PIN K11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en0[2]           ]; ## HA23_P         K22  IO_L21P_T3L_N4_AD8P_70
set_property  -dict {PACKAGE_PIN AJ33  IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en0[3]           ]; ## LA09_P         D14  IO_L19P_T3L_N0_DBC_AD9P_43
set_property  -dict {PACKAGE_PIN T11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en1[0]           ]; ## HA08_N         F11  IO_L10N_T1U_N7_QBC_AD4N_70
set_property  -dict {PACKAGE_PIN AK32  IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en1[1]           ]; ## LA02_N         H08  IO_L14N_T2L_N3_GC_43
set_property  -dict {PACKAGE_PIN J11   IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en1[2]           ]; ## HA23_N         K23  IO_L21N_T3L_N5_AD8N_70
set_property  -dict {PACKAGE_PIN AK33  IOSTANDARD LVCMOS18                       } [get_ports mxfe_tx_en1[3]           ]; ## LA09_N         D15  IO_L19N_T3L_N1_DBC_AD9N_43
set_property  -dict {PACKAGE_PIN AK30  IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[0]            ]; ## LA08_N         G13  IO_L18N_T2U_N11_AD2N_43
set_property  -dict {PACKAGE_PIN AH33  IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[1]            ]; ## LA12_P         G15  IO_L21P_T3L_N4_AD8P_43
set_property  -dict {PACKAGE_PIN AH34  IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[2]            ]; ## LA12_N         G16  IO_L21N_T3L_N5_AD8N_43
set_property  -dict {PACKAGE_PIN AG34  IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[3]            ]; ## LA16_P         G18  IO_L22P_T3U_N6_DBC_AD0P_43
set_property  -dict {PACKAGE_PIN AH35  IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[4]            ]; ## LA16_N         G19  IO_L22N_T3U_N7_DBC_AD0N_43
set_property  -dict {PACKAGE_PIN N32   IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[5]            ]; ## LA20_P         G21  IO_L23P_T3U_N8_45
set_property  -dict {PACKAGE_PIN M32   IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[6]            ]; ## LA20_N         G22  IO_L23N_T3U_N9_45
set_property  -dict {PACKAGE_PIN N34   IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[7]            ]; ## LA22_P         G24  IO_L20P_T3L_N2_AD1P_45
set_property  -dict {PACKAGE_PIN N35   IOSTANDARD LVCMOS18                       } [get_ports mxfe0_gpio[8]            ]; ## LA22_N         G25  IO_L20N_T3L_N3_AD1N_45
set_property  -dict {PACKAGE_PIN M33   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[0]            ]; ## LA19_N         H23  IO_L22N_T3U_N7_DBC_AD0N_45
set_property  -dict {PACKAGE_PIN M35   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[1]            ]; ## LA21_P         H25  IO_L24P_T3U_N10_45
set_property  -dict {PACKAGE_PIN L35   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[2]            ]; ## LA21_N         H26  IO_L24N_T3U_N11_45
set_property  -dict {PACKAGE_PIN T34   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[3]            ]; ## LA24_P         H28  IO_L6P_T0U_N10_AD6P_45
set_property  -dict {PACKAGE_PIN T35   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[4]            ]; ## LA24_N         H29  IO_L6N_T0U_N11_AD6N_45
set_property  -dict {PACKAGE_PIN M36   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[5]            ]; ## LA28_P         H31  IO_L17P_T2U_N8_AD10P_45
set_property  -dict {PACKAGE_PIN L36   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[6]            ]; ## LA28_N         H32  IO_L17N_T2U_N9_AD10N_45
set_property  -dict {PACKAGE_PIN N38   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[7]            ]; ## LA30_P         H34  IO_L18P_T2U_N10_AD2P_45
set_property  -dict {PACKAGE_PIN M38   IOSTANDARD LVCMOS18                       } [get_ports mxfe1_gpio[8]            ]; ## LA30_N         H35  IO_L18N_T2U_N11_AD2N_45
set_property  -dict {PACKAGE_PIN V12   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[0]            ]; ## HA03_N         J07  IO_L3N_T0L_N5_AD15N_70
set_property  -dict {PACKAGE_PIN AA14  IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[1]            ]; ## HA07_P         J09  IO_L2P_T0L_N2_70
set_property  -dict {PACKAGE_PIN Y14   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[2]            ]; ## HA07_N         J10  IO_L2N_T0L_N3_70
set_property  -dict {PACKAGE_PIN R12   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[3]            ]; ## HA11_P         J12  IO_L18P_T2U_N10_AD2P_70
set_property  -dict {PACKAGE_PIN P12   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[4]            ]; ## HA11_N         J13  IO_L18N_T2U_N11_AD2N_70
set_property  -dict {PACKAGE_PIN M11   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[5]            ]; ## HA14_P         J15  IO_L22P_T3U_N6_DBC_AD0P_70
set_property  -dict {PACKAGE_PIN L11   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[6]            ]; ## HA14_N         J16  IO_L22N_T3U_N7_DBC_AD0N_70
set_property  -dict {PACKAGE_PIN P15   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[7]            ]; ## HA18_P         J18  IO_L15P_T2L_N4_AD11P_70
set_property  -dict {PACKAGE_PIN N15   IOSTANDARD LVCMOS18                       } [get_ports mxfe2_gpio[8]            ]; ## HA18_N         J19  IO_L15N_T2L_N5_AD11N_70
set_property  -dict {PACKAGE_PIN T15   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[0]            ]; ## HA12_N         F14  IO_L9N_T1L_N5_AD12N_70
set_property  -dict {PACKAGE_PIN M13   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[1]            ]; ## HA15_P         F16  IO_L19P_T3L_N0_DBC_AD9P_70
set_property  -dict {PACKAGE_PIN M12   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[2]            ]; ## HA15_N         F17  IO_L19N_T3L_N1_DBC_AD9N_70
set_property  -dict {PACKAGE_PIN L14   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[3]            ]; ## HA19_P         F19  IO_L20P_T3L_N2_AD1P_70
set_property  -dict {PACKAGE_PIN L13   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[4]            ]; ## HA19_N         F20  IO_L20N_T3L_N3_AD1N_70
set_property  -dict {PACKAGE_PIN V15   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[5]            ]; ## HA01_P_CC      E02  IO_L7P_T1L_N0_QBC_AD13P_70
set_property  -dict {PACKAGE_PIN U15   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[6]            ]; ## HA01_N_CC      E03  IO_L7N_T1L_N1_QBC_AD13N_70
set_property  -dict {PACKAGE_PIN R14   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[7]            ]; ## HA05_P         E06  IO_L14P_T2L_N2_GC_70
set_property  -dict {PACKAGE_PIN P14   IOSTANDARD LVCMOS18                       } [get_ports mxfe3_gpio[8]            ]; ## HA05_N         E07  IO_L14N_T2L_N3_GC_70

set_property  -dict {PACKAGE_PIN AK35  IOSTANDARD LVCMOS18 PULLTYPE PULLUP       } [get_ports vadj_1v8_pgood             ];   ## IO_T1U_N12_43_AK35 

# PMOD1 calibration board connector
set_property  -dict {PACKAGE_PIN N28   IOSTANDARD LVCMOS12                      } [get_ports pmod1_adc_sync_n           ]; ## PMOD1_0 J53.1
set_property  -dict {PACKAGE_PIN M30   IOSTANDARD LVCMOS12                      } [get_ports pmod1_adc_sdi              ]; ## PMOD1_1 J53.3
set_property  -dict {PACKAGE_PIN N30   IOSTANDARD LVCMOS12                      } [get_ports pmod1_adc_sdo              ]; ## PMOD1_2 J53.5
set_property  -dict {PACKAGE_PIN P30   IOSTANDARD LVCMOS12                      } [get_ports pmod1_adc_sclk             ]; ## PMOD1_3 J53.7

set_property  -dict {PACKAGE_PIN P29   IOSTANDARD LVCMOS12                      } [get_ports pmod1_5045_v2              ]; ## PMOD1_4 J53.2
set_property  -dict {PACKAGE_PIN L31   IOSTANDARD LVCMOS12                      } [get_ports pmod1_5045_v1              ]; ## PMOD1_5 J53.4
set_property  -dict {PACKAGE_PIN M31   IOSTANDARD LVCMOS12                      } [get_ports pmod1_ctrl_ind             ]; ## PMOD1_6 J53.6
set_property  -dict {PACKAGE_PIN R29   IOSTANDARD LVCMOS12                      } [get_ports pmod1_ctrl_rx_combined     ]; ## PMOD1_7 J53.8

create_pblock pblock_axi_mem_interconnect
add_cells_to_pblock [get_pblocks pblock_axi_mem_interconnect] [get_cells -quiet [list i_system_wrapper/system_i/axi_mem_interconnect]]
resize_pblock [get_pblocks pblock_axi_mem_interconnect] -add {CLOCKREGION_X0Y0:CLOCKREGION_X5Y4}

create_pblock SLR1
add_cells_to_pblock [get_pblocks SLR1] [get_cells -quiet [list i_system_wrapper/system_i/util_mxfe_upack]]
resize_pblock SLR1 -add SLR1:SLR1


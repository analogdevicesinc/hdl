###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## mxfe
#

set_property         -dict {PACKAGE_PIN R34  IOSTANDARD LVCMOS18                                     } [get_ports agc0[0]                   ]    ; ## IO_L13P_T2L_N0_GC_QBC_45
set_property         -dict {PACKAGE_PIN P34  IOSTANDARD LVCMOS18                                     } [get_ports agc0[1]                   ]    ; ## IO_L13N_T2L_N1_GC_QBC_45
set_property         -dict {PACKAGE_PIN R31  IOSTANDARD LVCMOS18                                     } [get_ports agc1[0]                   ]    ; ## IO_L10P_T1U_N6_QBC_AD4P_45
set_property         -dict {PACKAGE_PIN P31  IOSTANDARD LVCMOS18                                     } [get_ports agc1[1]                   ]    ; ## IO_L10N_T1U_N7_QBC_AD4N_45
set_property         -dict {PACKAGE_PIN N32  IOSTANDARD LVCMOS18                                     } [get_ports agc2[0]                   ]    ; ## IO_L23P_T3U_N8_45
set_property         -dict {PACKAGE_PIN M32  IOSTANDARD LVCMOS18                                     } [get_ports agc2[1]                   ]    ; ## IO_L23N_T3U_N9_45
set_property         -dict {PACKAGE_PIN M35  IOSTANDARD LVCMOS18                                     } [get_ports agc3[0]                   ]    ; ## IO_L24P_T3U_N10_45
set_property         -dict {PACKAGE_PIN L35  IOSTANDARD LVCMOS18                                     } [get_ports agc3[1]                   ]    ; ## IO_L24N_T3U_N11_45
set_property         -dict {PACKAGE_PIN P36  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin6_n                  ]    ; ## IO_L14N_T2L_N3_GC_45
set_property         -dict {PACKAGE_PIN P35  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin6_p                  ]    ; ## IO_L14P_T2L_N2_GC_45
set_property         -dict {PACKAGE_PIN AM39                                                         } [get_ports clkin8_n                  ]    ; ## MGTREFCLK1N_120 
set_property         -dict {PACKAGE_PIN AM38                                                         } [get_ports clkin8_p                  ]    ; ## MGTREFCLK1P_120 
set_property         -dict {PACKAGE_PIN AK39                                                         } [get_ports fpga_refclk_in_n          ]    ; ## MGTREFCLK0N_121 
set_property         -dict {PACKAGE_PIN AK38                                                         } [get_ports fpga_refclk_in_p          ]    ; ## MGTREFCLK0P_121 
set_property         -dict {PACKAGE_PIN V39                                                          } [get_ports fpga_refclk_in_replica_n  ]    ; ## MGTREFCLK0N_126 
set_property         -dict {PACKAGE_PIN V38                                                          } [get_ports fpga_refclk_in_replica_p  ]    ; ## MGTREFCLK0P_126
set_property  -quiet -dict {PACKAGE_PIN AL46                                                         } [get_ports rx_data_n[2]              ]    ; ## MGTYRXN2_121               FPGA_SERDIN_0_N
set_property  -quiet -dict {PACKAGE_PIN AL45                                                         } [get_ports rx_data_p[2]              ]    ; ## MGTYRXP2_121               FPGA_SERDIN_0_P
set_property  -quiet -dict {PACKAGE_PIN AR46                                                         } [get_ports rx_data_n[0]              ]    ; ## MGTYRXN0_121               FPGA_SERDIN_1_N
set_property  -quiet -dict {PACKAGE_PIN AR45                                                         } [get_ports rx_data_p[0]              ]    ; ## MGTYRXP0_121               FPGA_SERDIN_1_P
set_property  -quiet -dict {PACKAGE_PIN N46                                                          } [get_ports rx_data_n[7]              ]    ; ## MGTYRXN3_126               FPGA_SERDIN_2_N
set_property  -quiet -dict {PACKAGE_PIN N45                                                          } [get_ports rx_data_p[7]              ]    ; ## MGTYRXP3_126               FPGA_SERDIN_2_P
set_property  -quiet -dict {PACKAGE_PIN R46                                                          } [get_ports rx_data_n[6]              ]    ; ## MGTYRXN2_126               FPGA_SERDIN_3_N
set_property  -quiet -dict {PACKAGE_PIN R45                                                          } [get_ports rx_data_p[6]              ]    ; ## MGTYRXP2_126               FPGA_SERDIN_3_P
set_property  -quiet -dict {PACKAGE_PIN U46                                                          } [get_ports rx_data_n[5]              ]    ; ## MGTYRXN1_126               FPGA_SERDIN_4_N
set_property  -quiet -dict {PACKAGE_PIN U45                                                          } [get_ports rx_data_p[5]              ]    ; ## MGTYRXP1_126               FPGA_SERDIN_4_P
set_property  -quiet -dict {PACKAGE_PIN W46                                                          } [get_ports rx_data_n[4]              ]    ; ## MGTYRXN0_126               FPGA_SERDIN_5_N
set_property  -quiet -dict {PACKAGE_PIN W45                                                          } [get_ports rx_data_p[4]              ]    ; ## MGTYRXP0_126               FPGA_SERDIN_5_P
set_property  -quiet -dict {PACKAGE_PIN AJ46                                                         } [get_ports rx_data_n[3]              ]    ; ## MGTYRXN3_121               FPGA_SERDIN_6_N
set_property  -quiet -dict {PACKAGE_PIN AJ45                                                         } [get_ports rx_data_p[3]              ]    ; ## MGTYRXP3_121               FPGA_SERDIN_6_P
set_property  -quiet -dict {PACKAGE_PIN AN46                                                         } [get_ports rx_data_n[1]              ]    ; ## MGTYRXN1_121               FPGA_SERDIN_7_N
set_property  -quiet -dict {PACKAGE_PIN AN45                                                         } [get_ports rx_data_p[1]              ]    ; ## MGTYRXP1_121               FPGA_SERDIN_7_P
set_property  -quiet -dict {PACKAGE_PIN AT43                                                         } [get_ports tx_data_n[0]              ]    ; ## MGTYTXN0_121               FPGA_SERDOUT_0_N
set_property  -quiet -dict {PACKAGE_PIN AT42                                                         } [get_ports tx_data_p[0]              ]    ; ## MGTYTXP0_121               FPGA_SERDOUT_0_P
set_property  -quiet -dict {PACKAGE_PIN AM43                                                         } [get_ports tx_data_n[2]              ]    ; ## MGTYTXN2_121               FPGA_SERDOUT_1_N
set_property  -quiet -dict {PACKAGE_PIN AM42                                                         } [get_ports tx_data_p[2]              ]    ; ## MGTYTXP2_121               FPGA_SERDOUT_1_P
set_property  -quiet -dict {PACKAGE_PIN K43                                                          } [get_ports tx_data_n[7]              ]    ; ## MGTYTXN3_126               FPGA_SERDOUT_2_N
set_property  -quiet -dict {PACKAGE_PIN K42                                                          } [get_ports tx_data_p[7]              ]    ; ## MGTYTXP3_126               FPGA_SERDOUT_2_P
set_property  -quiet -dict {PACKAGE_PIN M43                                                          } [get_ports tx_data_n[6]              ]    ; ## MGTYTXN2_126               FPGA_SERDOUT_3_N
set_property  -quiet -dict {PACKAGE_PIN M42                                                          } [get_ports tx_data_p[6]              ]    ; ## MGTYTXP2_126               FPGA_SERDOUT_3_P
set_property  -quiet -dict {PACKAGE_PIN AP43                                                         } [get_ports tx_data_n[1]              ]    ; ## MGTYTXN1_121               FPGA_SERDOUT_4_N
set_property  -quiet -dict {PACKAGE_PIN AP42                                                         } [get_ports tx_data_p[1]              ]    ; ## MGTYTXP1_121               FPGA_SERDOUT_4_P
set_property  -quiet -dict {PACKAGE_PIN P43                                                          } [get_ports tx_data_n[5]              ]    ; ## MGTYTXN1_126               FPGA_SERDOUT_5_N
set_property  -quiet -dict {PACKAGE_PIN P42                                                          } [get_ports tx_data_p[5]              ]    ; ## MGTYTXP1_126               FPGA_SERDOUT_5_P
set_property  -quiet -dict {PACKAGE_PIN T43                                                          } [get_ports tx_data_n[4]              ]    ; ## MGTYTXN0_126               FPGA_SERDOUT_6_N
set_property  -quiet -dict {PACKAGE_PIN T42                                                          } [get_ports tx_data_p[4]              ]    ; ## MGTYTXP0_126               FPGA_SERDOUT_6_P
set_property  -quiet -dict {PACKAGE_PIN AL41                                                         } [get_ports tx_data_n[3]              ]    ; ## MGTYTXN3_121               FPGA_SERDOUT_7_N
set_property  -quiet -dict {PACKAGE_PIN AL40                                                         } [get_ports tx_data_p[3]              ]    ; ## MGTYTXP3_121               FPGA_SERDOUT_7_P
set_property  -quiet -dict {PACKAGE_PIN AK32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_n[0]          ]    ; ## IO_L14N_T2L_N3_GC_43       
set_property  -quiet -dict {PACKAGE_PIN AJ32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_p[0]          ]    ; ## IO_L14P_T2L_N2_GC_43
set_property  -quiet -dict {PACKAGE_PIN AT40 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_n[1]          ]    ; ## IO_L4N_T0U_N7_DBC_AD7N_43
set_property  -quiet -dict {PACKAGE_PIN AT39 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_p[1]          ]    ; ## IO_L4P_T0U_N6_DBC_AD7P_43
set_property  -quiet -dict {PACKAGE_PIN AL31 IOSTANDARD LVDS                                         } [get_ports fpga_syncout_n[0]         ]    ; ## IO_L16N_T2U_N7_QBC_AD3N_43
set_property  -quiet -dict {PACKAGE_PIN AL30 IOSTANDARD LVDS                                         } [get_ports fpga_syncout_p[0]         ]    ; ## IO_L16P_T2U_N6_QBC_AD3P_43
set_property  -quiet -dict {PACKAGE_PIN AT36 IOSTANDARD LVDS                                         } [get_ports fpga_syncout_n[1]         ]    ; ## IO_L2N_T0L_N3_43
set_property  -quiet -dict {PACKAGE_PIN AT35 IOSTANDARD LVDS                                         } [get_ports fpga_syncout_p[1]         ]    ; ## IO_L2P_T0L_N2_43
set_property         -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18                                     } [get_ports gpio[0]                   ]    ; ## IO_L24P_T3U_N10_43
set_property         -dict {PACKAGE_PIN AG33 IOSTANDARD LVCMOS18                                     } [get_ports gpio[1]                   ]    ; ## IO_L24N_T3U_N11_43
set_property         -dict {PACKAGE_PIN N33  IOSTANDARD LVCMOS18                                     } [get_ports gpio[2]                   ]    ; ## IO_L22P_T3U_N6_DBC_AD0P_45
set_property         -dict {PACKAGE_PIN M33  IOSTANDARD LVCMOS18                                     } [get_ports gpio[3]                   ]    ; ## IO_L22N_T3U_N7_DBC_AD0N_45
set_property         -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18                                     } [get_ports gpio[4]                   ]    ; ## IO_L20P_T3L_N2_AD1P_43
set_property         -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18                                     } [get_ports gpio[5]                   ]    ; ## IO_L20N_T3L_N3_AD1N_43
set_property         -dict {PACKAGE_PIN AG31 IOSTANDARD LVCMOS18                                     } [get_ports gpio[6]                   ]    ; ## IO_L23P_T3U_N8_43
set_property         -dict {PACKAGE_PIN AH31 IOSTANDARD LVCMOS18                                     } [get_ports gpio[7]                   ]    ; ## IO_L23N_T3U_N9_43
set_property         -dict {PACKAGE_PIN AG34 IOSTANDARD LVCMOS18                                     } [get_ports gpio[8]                   ]    ; ## IO_L22P_T3U_N6_DBC_AD0P_43
set_property         -dict {PACKAGE_PIN AH35 IOSTANDARD LVCMOS18                                     } [get_ports gpio[9]                   ]    ; ## IO_L22N_T3U_N7_DBC_AD0N_43
set_property         -dict {PACKAGE_PIN N35  IOSTANDARD LVCMOS18                                     } [get_ports gpio[10]                  ]    ; ## IO_L20N_T3L_N3_AD1N_45
set_property         -dict {PACKAGE_PIN AJ31 IOSTANDARD LVCMOS18                                     } [get_ports hmc_gpio1                 ]    ; ## IO_L17N_T2U_N9_AD10N_43
set_property         -dict {PACKAGE_PIN AP37 IOSTANDARD LVCMOS18                                     } [get_ports hmc_sync                  ]    ; ## IO_L5N_T0U_N9_AD14N_43
set_property         -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18                                     } [get_ports irqb[0]                   ]    ; ## IO_L18P_T2U_N10_AD2P_43
set_property         -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18                                     } [get_ports irqb[1]                   ]    ; ## IO_L18N_T2U_N11_AD2N_43
set_property         -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18                                     } [get_ports rstb                      ]    ; ## IO_L5P_T0U_N8_AD14P_43
set_property         -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18                                     } [get_ports rxen[0]                   ]    ; ## IO_L3P_T0L_N4_AD15P_43
set_property         -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18                                     } [get_ports rxen[1]                   ]    ; ## IO_L3N_T0L_N5_AD15N_43
set_property         -dict {PACKAGE_PIN AP38 IOSTANDARD LVCMOS18                                     } [get_ports spi0_csb                  ]    ; ## IO_L1P_T0L_N0_DBC_43
set_property         -dict {PACKAGE_PIN AR38 IOSTANDARD LVCMOS18                                     } [get_ports spi0_miso                 ]    ; ## IO_L1N_T0L_N1_DBC_43
set_property         -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS18                                     } [get_ports spi0_mosi                 ]    ; ## IO_L6P_T0U_N10_AD6P_43
set_property         -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18                                     } [get_ports spi0_sclk                 ]    ; ## IO_L6N_T0U_N11_AD6N_43
set_property         -dict {PACKAGE_PIN AH33 IOSTANDARD LVCMOS18                                     } [get_ports spi1_csb                  ]    ; ## IO_L21P_T3L_N4_AD8P_43
set_property         -dict {PACKAGE_PIN AJ30 IOSTANDARD LVCMOS18                                     } [get_ports spi1_sclk                 ]    ; ## IO_L17P_T2U_N8_AD10P_43
set_property         -dict {PACKAGE_PIN AH34 IOSTANDARD LVCMOS18                                     } [get_ports spi1_sdio                 ]    ; ## IO_L21N_T3L_N5_AD8N_43
set_property         -dict {PACKAGE_PIN AM32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref2_n                 ]    ; ## IO_L13N_T2L_N1_GC_QBC_43
set_property         -dict {PACKAGE_PIN AL32 IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref2_p                 ]    ; ## IO_L13P_T2L_N0_GC_QBC_43
set_property         -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18                                     } [get_ports txen[0]                   ]    ; ## IO_L19P_T3L_N0_DBC_AD9P_43
set_property         -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18                                     } [get_ports txen[1]                   ]    ; ## IO_L19N_T3L_N1_DBC_AD9N_43

set_property         -dict {PACKAGE_PIN AK35 IOSTANDARD LVCMOS18 PULLTYPE PULLUP                     } [get_ports vadj_1v8_pgood            ]    ; ## IO_T1U_N12_43_AK35 




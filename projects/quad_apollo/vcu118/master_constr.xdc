set_property  -dict {PACKAGE_PIN AU11 IOSTANDARD LVCMOS18                                     } [get_ports gp4[0]           ]; ## LA21_P          H25  IO_L6P_T0U_N10_AD6P_67
set_property  -dict {PACKAGE_PIN AV11 IOSTANDARD LVCMOS18                                     } [get_ports gp5[0]           ]; ## LA21_N          H26  IO_L6N_T0U_N11_AD6N_67
set_property  -dict {PACKAGE_PIN AW13 IOSTANDARD LVCMOS18                                     } [get_ports gp4[1]           ]; ## LA22_P          G24  IO_L5P_T0U_N8_AD14P_67
set_property  -dict {PACKAGE_PIN AY13 IOSTANDARD LVCMOS18                                     } [get_ports gp5[1]           ]; ## LA22_N          G25  IO_L5N_T0U_N9_AD14N_67
set_property  -dict {PACKAGE_PIN AP13 IOSTANDARD LVCMOS18                                     } [get_ports gp4[2]           ]; ## LA24_P          H28  IO_L14P_T2L_N2_GC_67
set_property  -dict {PACKAGE_PIN AR13 IOSTANDARD LVCMOS18                                     } [get_ports gp5[2]           ]; ## LA24_N          H29  IO_L14N_T2L_N3_GC_67
set_property  -dict {PACKAGE_PIN AT12 IOSTANDARD LVCMOS18                                     } [get_ports gp4[3]           ]; ## LA25_P          G27  IO_L1P_T0L_N0_DBC_67
set_property  -dict {PACKAGE_PIN AU12 IOSTANDARD LVCMOS18                                     } [get_ports gp5[3]           ]; ## LA25_N          G28  IO_L1N_T0L_N1_DBC_67

# PMOD0 connections (NCO Sync and DMA Sync Start signals)
set_property  -dict {PACKAGE_PIN AY14 IOSTANDARD LVCMOS18                                     } [get_ports nco_sync         ]; ## PMOD0_0 J52.1
set_property  -dict {PACKAGE_PIN AY15 IOSTANDARD LVCMOS18                                     } [get_ports dma_start        ]; ## PMOD0_1 J52.3
set_property  -dict {PACKAGE_PIN AW15 IOSTANDARD LVCMOS18                                     } [get_ports sync_start_debug ]; ## PMOD0_2 J52.5
# set_property         -dict {PACKAGE_PIN AV15  IOSTANDARD LVCMOS18                  } [get_ports pmod0_3             ]    ; ## PMOD0_3 J52.7
# set_property         -dict {PACKAGE_PIN AV16  IOSTANDARD LVCMOS18                  } [get_ports pmod0_4             ]    ; ## PMOD0_4 J52.2
# set_property         -dict {PACKAGE_PIN AU16  IOSTANDARD LVCMOS18                  } [get_ports pmod0_5             ]    ; ## PMOD0_5 J52.4
# set_property         -dict {PACKAGE_PIN AT15  IOSTANDARD LVCMOS18                  } [get_ports pmod0_6             ]    ; ## PMOD0_6 J52.6
# set_property         -dict {PACKAGE_PIN AT16  IOSTANDARD LVCMOS18                  } [get_ports pmod0_7             ]    ; ## PMOD0_7 J52.8

# PMOD1 calibration board connector
set_property  -dict {PACKAGE_PIN N28  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_adc_sync_n           ]; ## PMOD1_0 J53.1
set_property  -dict {PACKAGE_PIN M30  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_adc_sdi              ]; ## PMOD1_1 J53.3
set_property  -dict {PACKAGE_PIN N30  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_adc_sdo              ]; ## PMOD1_2 J53.5
set_property  -dict {PACKAGE_PIN P30  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_adc_sclk             ]; ## PMOD1_3 J53.7

set_property  -dict {PACKAGE_PIN P29  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_5045_v2              ]; ## PMOD1_4 J53.2
set_property  -dict {PACKAGE_PIN L31  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_5045_v1              ]; ## PMOD1_5 J53.4
set_property  -dict {PACKAGE_PIN M31  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_ctrl_ind             ]; ## PMOD1_6 J53.6
set_property  -dict {PACKAGE_PIN R29  IOSTANDARD LVCMOS12                                     } [get_ports pmod1_ctrl_rx_combined     ]; ## PMOD1_7 J53.8
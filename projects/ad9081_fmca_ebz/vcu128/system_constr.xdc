###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## mxfe
#

set_property         -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS18                       } [get_ports agc0[0]                   ]    ; ## IO_L13P_T2L_N0_GC_QBC_71  
set_property         -dict {PACKAGE_PIN E17  IOSTANDARD LVCMOS18                       } [get_ports agc0[1]                   ]    ; ## IO_L13N_T2L_N1_GC_QBC_71  
set_property         -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS18                       } [get_ports agc1[0]                   ]    ; ## IO_L14P_T2L_N2_GC_71      
set_property         -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS18                       } [get_ports agc1[1]                   ]    ; ## IO_L14N_T2L_N3_GC_71      
set_property         -dict {PACKAGE_PIN A21  IOSTANDARD LVCMOS18                       } [get_ports agc2[0]                   ]    ; ## IO_L22P_T3U_N6_DBC_AD0P_71
set_property         -dict {PACKAGE_PIN A20  IOSTANDARD LVCMOS18                       } [get_ports agc2[1]                   ]    ; ## IO_L22N_T3U_N7_DBC_AD0N_71
set_property         -dict {PACKAGE_PIN A19  IOSTANDARD LVCMOS18                       } [get_ports agc3[0]                   ]    ; ## IO_L23P_T3U_N8_71         
set_property         -dict {PACKAGE_PIN A18  IOSTANDARD LVCMOS18                       } [get_ports agc3[1]                   ]    ; ## IO_L23N_T3U_N9_71         
set_property         -dict {PACKAGE_PIN G17  IOSTANDARD LVDS                           } [get_ports clkin6_n                  ]    ; ## IO_L11N_T1U_N9_GC_71      
set_property         -dict {PACKAGE_PIN G18  IOSTANDARD LVDS                           } [get_ports clkin6_p                  ]    ; ## IO_L11P_T1U_N8_GC_71      
set_property         -dict {PACKAGE_PIN AR41                                           } [get_ports clkin8_n                  ]    ; ## MGTREFCLK0N_125           
set_property         -dict {PACKAGE_PIN AR40                                           } [get_ports clkin8_p                  ]    ; ## MGTREFCLK0P_125           
set_property         -dict {PACKAGE_PIN AV43                                           } [get_ports fpga_refclk_in_n          ]    ; ## MGTREFCLK0N_124           
set_property         -dict {PACKAGE_PIN AV42                                           } [get_ports fpga_refclk_in_p          ]    ; ## MGTREFCLK0P_124                         
set_property  -quiet -dict {PACKAGE_PIN BA54                                           } [get_ports rx_data_n[2]              ]    ; ## MGTYRXN2_124              FPGA_SERDIN_0_N
set_property  -quiet -dict {PACKAGE_PIN BA53                                           } [get_ports rx_data_p[2]              ]    ; ## MGTYRXP2_124              FPGA_SERDIN_0_P
set_property  -quiet -dict {PACKAGE_PIN BC54                                           } [get_ports rx_data_n[0]              ]    ; ## MGTYRXN0_124              FPGA_SERDIN_1_N
set_property  -quiet -dict {PACKAGE_PIN BC53                                           } [get_ports rx_data_p[0]              ]    ; ## MGTYRXP0_124              FPGA_SERDIN_1_P
set_property  -quiet -dict {PACKAGE_PIN AV52                                           } [get_ports rx_data_n[7]              ]    ; ## MGTYRXN3_125              FPGA_SERDIN_2_N
set_property  -quiet -dict {PACKAGE_PIN AV51                                           } [get_ports rx_data_p[7]              ]    ; ## MGTYRXP3_125              FPGA_SERDIN_2_P
set_property  -quiet -dict {PACKAGE_PIN AW50                                           } [get_ports rx_data_n[6]              ]    ; ## MGTYRXN2_125              FPGA_SERDIN_3_N
set_property  -quiet -dict {PACKAGE_PIN AW49                                           } [get_ports rx_data_p[6]              ]    ; ## MGTYRXP2_125              FPGA_SERDIN_3_P
set_property  -quiet -dict {PACKAGE_PIN AW54                                           } [get_ports rx_data_n[5]              ]    ; ## MGTYRXN1_125              FPGA_SERDIN_4_N
set_property  -quiet -dict {PACKAGE_PIN AW53                                           } [get_ports rx_data_p[5]              ]    ; ## MGTYRXP1_125              FPGA_SERDIN_4_P
set_property  -quiet -dict {PACKAGE_PIN AY52                                           } [get_ports rx_data_n[4]              ]    ; ## MGTYRXN0_125              FPGA_SERDIN_5_N
set_property  -quiet -dict {PACKAGE_PIN AY51                                           } [get_ports rx_data_p[4]              ]    ; ## MGTYRXP0_125              FPGA_SERDIN_5_P
set_property  -quiet -dict {PACKAGE_PIN BA50                                           } [get_ports rx_data_n[3]              ]    ; ## MGTYRXN3_124              FPGA_SERDIN_6_N
set_property  -quiet -dict {PACKAGE_PIN BA49                                           } [get_ports rx_data_p[3]              ]    ; ## MGTYRXP3_124              FPGA_SERDIN_6_P
set_property  -quiet -dict {PACKAGE_PIN BB52                                           } [get_ports rx_data_n[1]              ]    ; ## MGTYRXN1_124              FPGA_SERDIN_7_N
set_property  -quiet -dict {PACKAGE_PIN BB51                                           } [get_ports rx_data_p[1]              ]    ; ## MGTYRXP1_124              FPGA_SERDIN_7_P
set_property  -quiet -dict {PACKAGE_PIN BC49                                           } [get_ports tx_data_n[0]              ]    ; ## MGTYTXN0_124              FPGA_SERDOUT_0_N
set_property  -quiet -dict {PACKAGE_PIN BC48                                           } [get_ports tx_data_p[0]              ]    ; ## MGTYTXP0_124              FPGA_SERDOUT_0_P
set_property  -quiet -dict {PACKAGE_PIN BB47                                           } [get_ports tx_data_n[2]              ]    ; ## MGTYTXN2_124              FPGA_SERDOUT_1_N
set_property  -quiet -dict {PACKAGE_PIN BB46                                           } [get_ports tx_data_p[2]              ]    ; ## MGTYTXP2_124              FPGA_SERDOUT_1_P
set_property  -quiet -dict {PACKAGE_PIN AU45                                           } [get_ports tx_data_n[7]              ]    ; ## MGTYTXN3_125              FPGA_SERDOUT_2_N
set_property  -quiet -dict {PACKAGE_PIN AU44                                           } [get_ports tx_data_p[7]              ]    ; ## MGTYTXP3_125              FPGA_SERDOUT_2_P
set_property  -quiet -dict {PACKAGE_PIN AV47                                           } [get_ports tx_data_n[6]              ]    ; ## MGTYTXN2_125              FPGA_SERDOUT_3_N
set_property  -quiet -dict {PACKAGE_PIN AV46                                           } [get_ports tx_data_p[6]              ]    ; ## MGTYTXP2_125              FPGA_SERDOUT_3_P
set_property  -quiet -dict {PACKAGE_PIN BC45                                           } [get_ports tx_data_n[1]              ]    ; ## MGTYTXN1_124              FPGA_SERDOUT_4_N
set_property  -quiet -dict {PACKAGE_PIN BC44                                           } [get_ports tx_data_p[1]              ]    ; ## MGTYTXP1_124              FPGA_SERDOUT_4_P
set_property  -quiet -dict {PACKAGE_PIN AW45                                           } [get_ports tx_data_n[5]              ]    ; ## MGTYTXN1_125              FPGA_SERDOUT_5_N
set_property  -quiet -dict {PACKAGE_PIN AW44                                           } [get_ports tx_data_p[5]              ]    ; ## MGTYTXP1_125              FPGA_SERDOUT_5_P
set_property  -quiet -dict {PACKAGE_PIN AY47                                           } [get_ports tx_data_n[4]              ]    ; ## MGTYTXN0_125              FPGA_SERDOUT_6_N
set_property  -quiet -dict {PACKAGE_PIN AY46                                           } [get_ports tx_data_p[4]              ]    ; ## MGTYTXP0_125              FPGA_SERDOUT_6_P
set_property  -quiet -dict {PACKAGE_PIN BA45                                           } [get_ports tx_data_n[3]              ]    ; ## MGTYTXN3_124              FPGA_SERDOUT_7_N
set_property  -quiet -dict {PACKAGE_PIN BA44                                           } [get_ports tx_data_p[3]              ]    ; ## MGTYTXP3_124              FPGA_SERDOUT_7_P
set_property  -quiet -dict {PACKAGE_PIN K22  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_syncin_0_n           ]    ; ## IO_L4N_T0U_N7_DBC_AD7N_72 
set_property  -quiet -dict {PACKAGE_PIN L23  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports fpga_syncin_0_p           ]    ; ## IO_L4P_T0U_N6_DBC_AD7P_72 
set_property  -quiet -dict {PACKAGE_PIN A26  IOSTANDARD LVCMOS18                       } [get_ports fpga_syncin_1_n           ]    ; ## IO_L23N_T3U_N9_72         
set_property  -quiet -dict {PACKAGE_PIN B27  IOSTANDARD LVCMOS18                       } [get_ports fpga_syncin_1_p           ]    ; ## IO_L23P_T3U_N8_72         
set_property  -quiet -dict {PACKAGE_PIN F25  IOSTANDARD LVDS                           } [get_ports fpga_syncout_0_n          ]    ; ## IO_L14N_T2L_N3_GC_72      
set_property  -quiet -dict {PACKAGE_PIN F26  IOSTANDARD LVDS                           } [get_ports fpga_syncout_0_p          ]    ; ## IO_L14P_T2L_N2_GC_72      
set_property  -quiet -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS18                       } [get_ports fpga_syncout_1_n          ]    ; ## IO_L15N_T2L_N5_AD11N_72   
set_property  -quiet -dict {PACKAGE_PIN E22  IOSTANDARD LVCMOS18                       } [get_ports fpga_syncout_1_p          ]    ; ## IO_L15P_T2L_N4_AD11P_72   
set_property         -dict {PACKAGE_PIN J26  IOSTANDARD LVCMOS18                       } [get_ports gpio[0]                   ]    ; ## IO_L6P_T0U_N10_AD6P_72    
set_property         -dict {PACKAGE_PIN J25  IOSTANDARD LVCMOS18                       } [get_ports gpio[1]                   ]    ; ## IO_L6N_T0U_N11_AD6N_72    
set_property         -dict {PACKAGE_PIN B18  IOSTANDARD LVCMOS18                       } [get_ports gpio[2]                   ]    ; ## IO_L21P_T3L_N4_AD8P_71    
set_property         -dict {PACKAGE_PIN B17  IOSTANDARD LVCMOS18                       } [get_ports gpio[3]                   ]    ; ## IO_L21N_T3L_N5_AD8N_71    
set_property         -dict {PACKAGE_PIN A25  IOSTANDARD LVCMOS18                       } [get_ports gpio[4]                   ]    ; ## IO_L24P_T3U_N10_72        
set_property         -dict {PACKAGE_PIN A24  IOSTANDARD LVCMOS18                       } [get_ports gpio[5]                   ]    ; ## IO_L24N_T3U_N11_72        
set_property         -dict {PACKAGE_PIN C23  IOSTANDARD LVCMOS18                       } [get_ports gpio[6]                   ]    ; ## IO_L19P_T3L_N0_DBC_AD9P_72
set_property         -dict {PACKAGE_PIN B22  IOSTANDARD LVCMOS18                       } [get_ports gpio[7]                   ]    ; ## IO_L19N_T3L_N1_DBC_AD9N_72
set_property         -dict {PACKAGE_PIN K24  IOSTANDARD LVCMOS18                       } [get_ports gpio[8]                   ]    ; ## IO_L3P_T0L_N4_AD15P_72    
set_property         -dict {PACKAGE_PIN K23  IOSTANDARD LVCMOS18                       } [get_ports gpio[9]                   ]    ; ## IO_L3N_T0L_N5_AD15N_72    
set_property         -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS18                       } [get_ports gpio[10]                  ]    ; ## IO_L24N_T3U_N11_71        
set_property         -dict {PACKAGE_PIN B25  IOSTANDARD LVCMOS18                       } [get_ports hmc_gpio1                 ]    ; ## IO_L21N_T3L_N5_AD8N_72    
set_property         -dict {PACKAGE_PIN J27  IOSTANDARD LVCMOS18                       } [get_ports hmc_sync                  ]    ; ## IO_L5N_T0U_N9_AD14N_72    
set_property         -dict {PACKAGE_PIN E27  IOSTANDARD LVCMOS18                       } [get_ports irqb[0]                   ]    ; ## IO_L18P_T2U_N10_AD2P_72   
set_property         -dict {PACKAGE_PIN D27  IOSTANDARD LVCMOS18                       } [get_ports irqb[1]                   ]    ; ## IO_L18N_T2U_N11_AD2N_72   
set_property         -dict {PACKAGE_PIN K27  IOSTANDARD LVCMOS18                       } [get_ports rstb                      ]    ; ## IO_L5P_T0U_N8_AD14P_72    
set_property         -dict {PACKAGE_PIN B23  IOSTANDARD LVCMOS18                       } [get_ports rxen[0]                   ]    ; ## IO_L22P_T3U_N6_DBC_AD0P_72
set_property         -dict {PACKAGE_PIN A23  IOSTANDARD LVCMOS18                       } [get_ports rxen[1]                   ]    ; ## IO_L22N_T3U_N7_DBC_AD0N_72
set_property         -dict {PACKAGE_PIN H27  IOSTANDARD LVCMOS18                       } [get_ports spi0_csb                  ]    ; ## IO_L9P_T1L_N4_AD12P_72    
set_property         -dict {PACKAGE_PIN G27  IOSTANDARD LVCMOS18                       } [get_ports spi0_miso                 ]    ; ## IO_L9N_T1L_N5_AD12N_72    
set_property         -dict {PACKAGE_PIN C25  IOSTANDARD LVCMOS18                       } [get_ports spi0_mosi                 ]    ; ## IO_L20P_T3L_N2_AD1P_72    
set_property         -dict {PACKAGE_PIN C24  IOSTANDARD LVCMOS18                       } [get_ports spi0_sclk                 ]    ; ## IO_L20N_T3L_N3_AD1N_72    
set_property         -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS18                       } [get_ports spi1_csb                  ]    ; ## IO_L8P_T1L_N2_AD5P_72     
set_property         -dict {PACKAGE_PIN B26  IOSTANDARD LVCMOS18                       } [get_ports spi1_sclk                 ]    ; ## IO_L21P_T3L_N4_AD8P_72    
set_property         -dict {PACKAGE_PIN H22  IOSTANDARD LVCMOS18                       } [get_ports spi1_sdio                 ]    ; ## IO_L8N_T1L_N3_AD5N_72     
set_property         -dict {PACKAGE_PIN F23  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports sysref2_n                 ]    ; ## IO_L11N_T1U_N9_GC_72      
set_property         -dict {PACKAGE_PIN F24  IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100} [get_ports sysref2_p                 ]    ; ## IO_L11P_T1U_N8_GC_72      
set_property         -dict {PACKAGE_PIN E26  IOSTANDARD LVCMOS18                       } [get_ports txen[0]                   ]    ; ## IO_L17P_T2U_N8_AD10P_72   
set_property         -dict {PACKAGE_PIN D26  IOSTANDARD LVCMOS18                       } [get_ports txen[1]                   ]    ; ## IO_L17N_T2U_N9_AD10N_72   


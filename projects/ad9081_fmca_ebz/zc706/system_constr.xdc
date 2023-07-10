###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## mxfe
#

set_property         -dict {PACKAGE_PIN V23   IOSTANDARD LVCMOS25               } [get_ports agc0[0]          ]    ; ## FMC0_LA17_CC_P      IO_L24P_T3_13 
set_property         -dict {PACKAGE_PIN W24   IOSTANDARD LVCMOS25               } [get_ports agc0[1]          ]    ; ## FMC0_LA17_CC_N      IO_L24N_T3_13
set_property         -dict {PACKAGE_PIN W25   IOSTANDARD LVCMOS25               } [get_ports agc1[0]          ]    ; ## FMC0_LA18_CC_P      IO_L10P_T1_13
set_property         -dict {PACKAGE_PIN W26   IOSTANDARD LVCMOS25               } [get_ports agc1[1]          ]    ; ## FMC0_LA18_CC_N      IO_L10N_T1_13
set_property         -dict {PACKAGE_PIN U25   IOSTANDARD LVCMOS25               } [get_ports agc2[0]          ]    ; ## FMC0_LA20_P         IO_L11P_T1_SRCC_13
set_property         -dict {PACKAGE_PIN V26   IOSTANDARD LVCMOS25               } [get_ports agc2[1]          ]    ; ## FMC0_LA20_N         IO_L11N_T1_SRCC_13
set_property         -dict {PACKAGE_PIN W29   IOSTANDARD LVCMOS25               } [get_ports agc3[0]          ]    ; ## FMC0_LA21_P         IO_L8P_T1_13
set_property         -dict {PACKAGE_PIN W30   IOSTANDARD LVCMOS25               } [get_ports agc3[1]          ]    ; ## FMC0_LA21_N         IO_L8N_T1_13
set_property         -dict {PACKAGE_PIN AG20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports clkin10_n        ]    ; ## FMC0_CLK2_IO_N      IO_L14N_T2_SRCC_11
set_property         -dict {PACKAGE_PIN AF20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports clkin10_p        ]    ; ## FMC0_CLK2_IO_P      IO_L14P_T2_SRCC_11
set_property         -dict {PACKAGE_PIN U27   IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports clkin6_n         ]    ; ## FMC0_CLK1_M2C_N     IO_L12N_T1_MRCC_13
set_property         -dict {PACKAGE_PIN U26   IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports clkin6_p         ]    ; ## FMC0_CLK1_M2C_P     IO_L12P_T1_MRCC_13
set_property         -dict {PACKAGE_PIN AD9                                     } [get_ports fpga_refclk_in_n ]    ; ## FMC0_GBTCLK0_M2C_N  MGTREFCLK0N_109
set_property         -dict {PACKAGE_PIN AD10                                    } [get_ports fpga_refclk_in_p ]    ; ## FMC0_GBTCLK0_M2C_P  MGTREFCLK0P_109
set_property  -quiet -dict {PACKAGE_PIN AG7                                     } [get_ports rx_data_n[2]     ]    ; ## FMC0_DP2_M2C_N      MGTXRXN2_109     FPGA_SERDIN_0_N
set_property  -quiet -dict {PACKAGE_PIN AG8                                     } [get_ports rx_data_p[2]     ]    ; ## FMC0_DP2_M2C_P      MGTXRXP2_109     FPGA_SERDIN_0_P
set_property  -quiet -dict {PACKAGE_PIN AH9                                     } [get_ports rx_data_n[0]     ]    ; ## FMC0_DP0_M2C_N      MGTXRXN0_109     FPGA_SERDIN_1_N
set_property  -quiet -dict {PACKAGE_PIN AH10                                    } [get_ports rx_data_p[0]     ]    ; ## FMC0_DP0_M2C_P      MGTXRXP0_109     FPGA_SERDIN_1_P
set_property  -quiet -dict {PACKAGE_PIN AD5                                     } [get_ports rx_data_n[7]     ]    ; ## FMC0_DP7_M2C_N      MGTXRXN3_110     FPGA_SERDIN_2_N
set_property  -quiet -dict {PACKAGE_PIN AD6                                     } [get_ports rx_data_p[7]     ]    ; ## FMC0_DP7_M2C_P      MGTXRXP3_110     FPGA_SERDIN_2_P
set_property  -quiet -dict {PACKAGE_PIN AF5                                     } [get_ports rx_data_n[6]     ]    ; ## FMC0_DP6_M2C_N      MGTXRXN2_110     FPGA_SERDIN_3_N
set_property  -quiet -dict {PACKAGE_PIN AF6                                     } [get_ports rx_data_p[6]     ]    ; ## FMC0_DP6_M2C_P      MGTXRXP2_110     FPGA_SERDIN_3_P
set_property  -quiet -dict {PACKAGE_PIN AG3                                     } [get_ports rx_data_n[5]     ]    ; ## FMC0_DP5_M2C_N      MGTXRXN1_110     FPGA_SERDIN_4_N
set_property  -quiet -dict {PACKAGE_PIN AG4                                     } [get_ports rx_data_p[5]     ]    ; ## FMC0_DP5_M2C_P      MGTXRXP1_110     FPGA_SERDIN_4_P
set_property  -quiet -dict {PACKAGE_PIN AH5                                     } [get_ports rx_data_n[4]     ]    ; ## FMC0_DP4_M2C_N      MGTXRXN0_110     FPGA_SERDIN_5_N
set_property  -quiet -dict {PACKAGE_PIN AH6                                     } [get_ports rx_data_p[4]     ]    ; ## FMC0_DP4_M2C_P      MGTXRXP0_110     FPGA_SERDIN_5_P
set_property  -quiet -dict {PACKAGE_PIN AE7                                     } [get_ports rx_data_n[3]     ]    ; ## FMC0_DP3_M2C_N      MGTXRXN3_109     FPGA_SERDIN_6_N
set_property  -quiet -dict {PACKAGE_PIN AE8                                     } [get_ports rx_data_p[3]     ]    ; ## FMC0_DP3_M2C_P      MGTXRXP3_109     FPGA_SERDIN_6_P
set_property  -quiet -dict {PACKAGE_PIN AJ7                                     } [get_ports rx_data_n[1]     ]    ; ## FMC0_DP1_M2C_N      MGTXRXN1_109     FPGA_SERDIN_7_N
set_property  -quiet -dict {PACKAGE_PIN AJ8                                     } [get_ports rx_data_p[1]     ]    ; ## FMC0_DP1_M2C_P      MGTXRXP1_109     FPGA_SERDIN_7_P
set_property  -quiet -dict {PACKAGE_PIN AK9                                     } [get_ports tx_data_n[0]     ]    ; ## FMC0_DP0_C2M_N      MGTXTXN0_109     FPGA_SERDOUT_0_N
set_property  -quiet -dict {PACKAGE_PIN AK10                                    } [get_ports tx_data_p[0]     ]    ; ## FMC0_DP0_C2M_P      MGTXTXP0_109     FPGA_SERDOUT_0_P
set_property  -quiet -dict {PACKAGE_PIN AJ3                                     } [get_ports tx_data_n[2]     ]    ; ## FMC0_DP2_C2M_N      MGTXTXN2_109     FPGA_SERDOUT_1_N
set_property  -quiet -dict {PACKAGE_PIN AJ4                                     } [get_ports tx_data_p[2]     ]    ; ## FMC0_DP2_C2M_P      MGTXTXP2_109     FPGA_SERDOUT_1_P
set_property  -quiet -dict {PACKAGE_PIN AD1                                     } [get_ports tx_data_n[7]     ]    ; ## FMC0_DP7_C2M_N      MGTXTXN3_110     FPGA_SERDOUT_2_N
set_property  -quiet -dict {PACKAGE_PIN AD2                                     } [get_ports tx_data_p[7]     ]    ; ## FMC0_DP7_C2M_P      MGTXTXP3_110     FPGA_SERDOUT_2_P
set_property  -quiet -dict {PACKAGE_PIN AE3                                     } [get_ports tx_data_n[6]     ]    ; ## FMC0_DP6_C2M_N      MGTXTXN2_110     FPGA_SERDOUT_3_N
set_property  -quiet -dict {PACKAGE_PIN AE4                                     } [get_ports tx_data_p[6]     ]    ; ## FMC0_DP6_C2M_P      MGTXTXP2_110     FPGA_SERDOUT_3_P
set_property  -quiet -dict {PACKAGE_PIN AK5                                     } [get_ports tx_data_n[1]     ]    ; ## FMC0_DP1_C2M_N      MGTXTXN1_109     FPGA_SERDOUT_4_N
set_property  -quiet -dict {PACKAGE_PIN AK6                                     } [get_ports tx_data_p[1]     ]    ; ## FMC0_DP1_C2M_P      MGTXTXP1_109     FPGA_SERDOUT_4_P
set_property  -quiet -dict {PACKAGE_PIN AF1                                     } [get_ports tx_data_n[5]     ]    ; ## FMC0_DP5_C2M_N      MGTXTXN1_110     FPGA_SERDOUT_5_N
set_property  -quiet -dict {PACKAGE_PIN AF2                                     } [get_ports tx_data_p[5]     ]    ; ## FMC0_DP5_C2M_P      MGTXTXP1_110     FPGA_SERDOUT_5_P
set_property  -quiet -dict {PACKAGE_PIN AH1                                     } [get_ports tx_data_n[4]     ]    ; ## FMC0_DP4_C2M_N      MGTXTXN0_110     FPGA_SERDOUT_6_N
set_property  -quiet -dict {PACKAGE_PIN AH2                                     } [get_ports tx_data_p[4]     ]    ; ## FMC0_DP4_C2M_P      MGTXTXP0_110     FPGA_SERDOUT_6_P
set_property  -quiet -dict {PACKAGE_PIN AK1                                     } [get_ports tx_data_n[3]     ]    ; ## FMC0_DP3_C2M_N      MGTXTXN3_109     FPGA_SERDOUT_7_N
set_property  -quiet -dict {PACKAGE_PIN AK2                                     } [get_ports tx_data_p[3]     ]    ; ## FMC0_DP3_C2M_P      MGTXTXP3_109     FPGA_SERDOUT_7_P
set_property  -quiet -dict {PACKAGE_PIN AK18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports fpga_syncin_0_n  ]    ; ## FMC0_LA02_N         IO_L16N_T2_11
set_property  -quiet -dict {PACKAGE_PIN AK17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports fpga_syncin_0_p  ]    ; ## FMC0_LA02_P         IO_L16P_T2_11
set_property  -quiet -dict {PACKAGE_PIN AJ19  IOSTANDARD LVCMOS25               } [get_ports fpga_syncin_1_n  ]    ; ## FMC0_LA03_N         IO_L17N_T2_11
set_property  -quiet -dict {PACKAGE_PIN AH19  IOSTANDARD LVCMOS25               } [get_ports fpga_syncin_1_p  ]    ; ## FMC0_LA03_P         IO_L17P_T2_11
set_property  -quiet -dict {PACKAGE_PIN AH21  IOSTANDARD LVDS_25                } [get_ports fpga_syncout_0_n ]    ; ## FMC0_LA01_CC_N      IO_L13N_T2_MRCC_11
set_property  -quiet -dict {PACKAGE_PIN AG21  IOSTANDARD LVDS_25                } [get_ports fpga_syncout_0_p ]    ; ## FMC0_LA01_CC_P      IO_L13P_T2_MRCC_11
set_property  -quiet -dict {PACKAGE_PIN AH22  IOSTANDARD LVCMOS25               } [get_ports fpga_syncout_1_n ]    ; ## FMC0_LA06_N         IO_L6N_T0_VREF_11
set_property  -quiet -dict {PACKAGE_PIN AG22  IOSTANDARD LVCMOS25               } [get_ports fpga_syncout_1_p ]    ; ## FMC0_LA06_P         IO_L6P_T0_11
set_property         -dict {PACKAGE_PIN Y22   IOSTANDARD LVCMOS25               } [get_ports gpio[0]          ]    ; ## FMC0_LA15_P         IO_L21P_T3_DQS_11
set_property         -dict {PACKAGE_PIN Y23   IOSTANDARD LVCMOS25               } [get_ports gpio[1]          ]    ; ## FMC0_LA15_N         IO_L21N_T3_DQS_11
set_property         -dict {PACKAGE_PIN T24   IOSTANDARD LVCMOS25               } [get_ports gpio[2]          ]    ; ## FMC0_LA19_P         IO_L17P_T2_13
set_property         -dict {PACKAGE_PIN T25   IOSTANDARD LVCMOS25               } [get_ports gpio[3]          ]    ; ## FMC0_LA19_N         IO_L17N_T2_13
set_property         -dict {PACKAGE_PIN AA22  IOSTANDARD LVCMOS25               } [get_ports gpio[4]          ]    ; ## FMC0_LA13_P         IO_L23P_T3_11
set_property         -dict {PACKAGE_PIN AA23  IOSTANDARD LVCMOS25               } [get_ports gpio[5]          ]    ; ## FMC0_LA13_N         IO_L23N_T3_11
set_property         -dict {PACKAGE_PIN AC24  IOSTANDARD LVCMOS25               } [get_ports gpio[6]          ]    ; ## FMC0_LA14_P         IO_L7P_T1_11
set_property         -dict {PACKAGE_PIN AD24  IOSTANDARD LVCMOS25               } [get_ports gpio[7]          ]    ; ## FMC0_LA14_N         IO_L7N_T1_11
set_property         -dict {PACKAGE_PIN AA24  IOSTANDARD LVCMOS25               } [get_ports gpio[8]          ]    ; ## FMC0_LA16_P         IO_L22P_T3_11
set_property         -dict {PACKAGE_PIN AB24  IOSTANDARD LVCMOS25               } [get_ports gpio[9]          ]    ; ## FMC0_LA16_N         IO_L22N_T3_11
set_property         -dict {PACKAGE_PIN W28   IOSTANDARD LVCMOS25               } [get_ports gpio[10]         ]    ; ## FMC0_LA22_N         IO_L9N_T1_DQS_13
set_property         -dict {PACKAGE_PIN AE23  IOSTANDARD LVCMOS25               } [get_ports hmc_gpio1        ]    ; ## FMC0_LA11_N         IO_L11N_T1_SRCC_11
set_property         -dict {PACKAGE_PIN AJ24  IOSTANDARD LVCMOS25               } [get_ports hmc_sync         ]    ; ## FMC0_LA07_N         IO_L4N_T0_11
set_property         -dict {PACKAGE_PIN AF19  IOSTANDARD LVCMOS25               } [get_ports irqb[0]          ]    ; ## FMC0_LA08_P         IO_L18P_T2_11
set_property         -dict {PACKAGE_PIN AG19  IOSTANDARD LVCMOS25               } [get_ports irqb[1]          ]    ; ## FMC0_LA08_N         IO_L18N_T2_11
set_property         -dict {PACKAGE_PIN AJ23  IOSTANDARD LVCMOS25               } [get_ports rstb             ]    ; ## FMC0_LA07_P         IO_L4P_T0_11
set_property         -dict {PACKAGE_PIN AG24  IOSTANDARD LVCMOS25               } [get_ports rxen[0]          ]    ; ## FMC0_LA10_P         IO_L8P_T1_11
set_property         -dict {PACKAGE_PIN AG25  IOSTANDARD LVCMOS25               } [get_ports rxen[1]          ]    ; ## FMC0_LA10_N         IO_L8N_T1_11
set_property         -dict {PACKAGE_PIN AH23  IOSTANDARD LVCMOS25               } [get_ports spi0_csb         ]    ; ## FMC0_LA05_P         IO_L5P_T0_11
set_property         -dict {PACKAGE_PIN AH24  IOSTANDARD LVCMOS25               } [get_ports spi0_miso        ]    ; ## FMC0_LA05_N         IO_L5N_T0_11
set_property         -dict {PACKAGE_PIN AJ20  IOSTANDARD LVCMOS25               } [get_ports spi0_mosi        ]    ; ## FMC0_LA04_P         IO_L15P_T2_DQS_11
set_property         -dict {PACKAGE_PIN AK20  IOSTANDARD LVCMOS25               } [get_ports spi0_sclk        ]    ; ## FMC0_LA04_N         IO_L15N_T2_DQS_11
set_property         -dict {PACKAGE_PIN AF23  IOSTANDARD LVCMOS25               } [get_ports spi1_csb         ]    ; ## FMC0_LA12_P         IO_L9P_T1_DQS_11
set_property         -dict {PACKAGE_PIN AD23  IOSTANDARD LVCMOS25               } [get_ports spi1_sclk        ]    ; ## FMC0_LA11_P         IO_L11P_T1_SRCC_11
set_property         -dict {PACKAGE_PIN AF24  IOSTANDARD LVCMOS25               } [get_ports spi1_sdio        ]    ; ## FMC0_LA12_N         IO_L9N_T1_DQS_11
set_property         -dict {PACKAGE_PIN AF22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports sysref2_n        ]    ; ## FMC0_CLK0_M2C_N     IO_L12N_T1_MRCC_11
set_property         -dict {PACKAGE_PIN AE22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports sysref2_p        ]    ; ## FMC0_CLK0_M2C_P     IO_L12P_T1_MRCC_11
set_property         -dict {PACKAGE_PIN AD21  IOSTANDARD LVCMOS25               } [get_ports txen[0]          ]    ; ## FMC0_LA09_P         IO_L10P_T1_11
set_property         -dict {PACKAGE_PIN AE21  IOSTANDARD LVCMOS25               } [get_ports txen[1]          ]    ; ## FMC0_LA09_N         IO_L10N_T1_11


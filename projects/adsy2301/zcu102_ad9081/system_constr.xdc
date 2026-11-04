###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# FMC HPC0
set_property -dict {PACKAGE_PIN V8   IOSTANDARD LVCMOS18} [get_ports "TR_01"]
set_property -dict {PACKAGE_PIN L12  IOSTANDARD LVCMOS18} [get_ports "TX_LOAD_01"]
set_property -dict {PACKAGE_PIN K12  IOSTANDARD LVCMOS18} [get_ports "RX_LOAD_01"]
set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_01"]
set_property -dict {PACKAGE_PIN V12  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_01"]
set_property -dict {PACKAGE_PIN U9   IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_01"]
set_property -dict {PACKAGE_PIN Y2   IOSTANDARD LVCMOS18} [get_ports "TR_02"]
set_property -dict {PACKAGE_PIN L13  IOSTANDARD LVCMOS18} [get_ports "TX_LOAD_02"]
set_property -dict {PACKAGE_PIN K13  IOSTANDARD LVCMOS18} [get_ports "RX_LOAD_02"]
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_02"]
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_02"]
set_property -dict {PACKAGE_PIN V3   IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_02"]
set_property -dict {PACKAGE_PIN AC6  IOSTANDARD LVCMOS18} [get_ports "TR_03"]
set_property -dict {PACKAGE_PIN N11  IOSTANDARD LVCMOS18} [get_ports "TX_LOAD_03"]
set_property -dict {PACKAGE_PIN N9   IOSTANDARD LVCMOS18} [get_ports "RX_LOAD_03"]
set_property -dict {PACKAGE_PIN L10  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_03"]
set_property -dict {PACKAGE_PIN M10  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_03"]
set_property -dict {PACKAGE_PIN AC8  IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_03"]
set_property -dict {PACKAGE_PIN W4   IOSTANDARD LVCMOS18} [get_ports "TR_04"]
set_property -dict {PACKAGE_PIN W1   IOSTANDARD LVCMOS18} [get_ports "TX_LOAD_04"]
set_property -dict {PACKAGE_PIN AC7  IOSTANDARD LVCMOS18} [get_ports "RX_LOAD_04"]
set_property -dict {PACKAGE_PIN AC2  IOSTANDARD LVCMOS18} [get_ports "PG_PA_VGG_04"]
set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS18} [get_ports "BF_PWR_EN_04"]
set_property -dict {PACKAGE_PIN AB8  IOSTANDARD LVCMOS18} [get_ports "BF_PA_ON_04"]
set_property -dict {PACKAGE_PIN N13  IOSTANDARD LVCMOS18} [get_ports "XUD_RX_GAIN_MODE"]
set_property -dict {PACKAGE_PIN M13  IOSTANDARD LVCMOS18} [get_ports "XUD_PLL_OUTPUT_SEL"]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX0"]
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX1"]
set_property -dict {PACKAGE_PIN W6   IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX2"]
set_property -dict {PACKAGE_PIN W7   IOSTANDARD LVCMOS18} [get_ports "XUD_TXRX3"]

set_property -dict {PACKAGE_PIN W2   IOSTANDARD LVCMOS18} [get_ports "tdd_sync_in_debug"]
set_property -dict {PACKAGE_PIN N8   IOSTANDARD LVCMOS18} [get_ports "tdd_sync_out_debug"]
set_property -dict {PACKAGE_PIN P11  IOSTANDARD LVCMOS18} [get_ports "tdd_enable_debug"]

set_property -dict {PACKAGE_PIN U11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_01"]
set_property -dict {PACKAGE_PIN U6   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_01"]
set_property -dict {PACKAGE_PIN T11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_01"]
set_property -dict {PACKAGE_PIN V6   IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_01"]

set_property -dict {PACKAGE_PIN V2   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_02"]
set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_02"]
set_property -dict {PACKAGE_PIN V1   IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_02"]
set_property -dict {PACKAGE_PIN AA1  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_02"]

set_property -dict {PACKAGE_PIN K15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_03"]
set_property -dict {PACKAGE_PIN K16  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_03"]
set_property -dict {PACKAGE_PIN L15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_03"]
set_property -dict {PACKAGE_PIN L16  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_03"]

set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_SCLK_04"]
set_property -dict {PACKAGE_PIN AB3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_CSB_04"]
set_property -dict {PACKAGE_PIN AC4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "BF_SPI_MOSI_04"]
set_property -dict {PACKAGE_PIN AC3  IOSTANDARD LVCMOS18          } [get_ports "BF_SPI_MISO_04"]

set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_SCLK"]
set_property -dict {PACKAGE_PIN L11  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_CSB"]
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports "XUD_SPI_MOSI"]
set_property -dict {PACKAGE_PIN M11  IOSTANDARD LVCMOS18          } [get_ports "XUD_SPI_MISO"]

# FMC HPC1 - AD9081-FMCA-EBZ (ported from ad9081_fmca_ebz/zcu102/system_constr.xdc)

set_property         -dict {PACKAGE_PIN Y5    IOSTANDARD LVCMOS18                                     } [get_ports agc0[0]          ]    ; ## FMC1_LA17_CC_P IO_L14P_T2L_N2_GC_66
set_property         -dict {PACKAGE_PIN AA5   IOSTANDARD LVCMOS18                                     } [get_ports agc0[1]          ]    ; ## FMC1_LA17_CC_N IO_L14N_T2L_N3_GC_66
set_property         -dict {PACKAGE_PIN Y8    IOSTANDARD LVCMOS18                                     } [get_ports agc1[0]          ]    ; ## FMC1_LA18_CC_P IO_L11N_T1U_N9_GC_66
set_property         -dict {PACKAGE_PIN Y7    IOSTANDARD LVCMOS18                                     } [get_ports agc1[1]          ]    ; ## FMC1_LA18_CC_N IO_L11N_T1U_N9_GC_66
set_property         -dict {PACKAGE_PIN AB11  IOSTANDARD LVCMOS18                                     } [get_ports agc2[0]          ]    ; ## FMC1_LA20_P IO_L2P_T0L_N2_66
set_property         -dict {PACKAGE_PIN AB10  IOSTANDARD LVCMOS18                                     } [get_ports agc2[1]          ]    ; ## FMC1_LA20_N IO_L2N_T0L_N3_66
set_property         -dict {PACKAGE_PIN AC12  IOSTANDARD LVCMOS18                                     } [get_ports agc3[0]          ]    ; ## FMC1_LA21_P IO_L1P_T0L_N0_DBC_66
set_property         -dict {PACKAGE_PIN AC11  IOSTANDARD LVCMOS18                                     } [get_ports agc3[1]          ]    ; ## FMC1_LA21_N IO_L1N_T0L_N1_DBC_66
set_property         -dict {PACKAGE_PIN AF5   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin10_n        ]    ; ## FMC1_LA00_CC_N IO_L13N_T2L_N1_GC_QBC_65
set_property         -dict {PACKAGE_PIN AE5   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin10_p        ]    ; ## FMC1_LA00_CC_P IO_L13P_T2L_N0_GC_QBC_65
set_property         -dict {PACKAGE_PIN P9    IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin6_n         ]    ; ## FMC1_CLK1_M2C_N IO_L14N_T2L_N3_GC_67
set_property         -dict {PACKAGE_PIN P10   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports clkin6_p         ]    ; ## FMC1_CLK1_M2C_P IO_L14P_T2L_N2_GC_67
set_property         -dict {PACKAGE_PIN G28   } [get_ports fpga_refclk_in_n ]    ; ## FMC1_GBTCLK0_M2C_C_N MGTREFCLK0N_130
set_property         -dict {PACKAGE_PIN G27   } [get_ports fpga_refclk_in_p ]    ; ## FMC1_GBTCLK0_M2C_C_P MGTREFCLK0P_130
set_property  -quiet -dict {PACKAGE_PIN C32   } [get_ports rx_data_n[2]     ]    ; ## FMC1_DP2_M2C_N MGTHRXN2_130
set_property  -quiet -dict {PACKAGE_PIN C31   } [get_ports rx_data_p[2]     ]    ; ## FMC1_DP2_M2C_P MGTHRXP2_130
set_property  -quiet -dict {PACKAGE_PIN E32   } [get_ports rx_data_n[0]     ]    ; ## FMC1_DP0_M2C_N MGTHRXN0_130
set_property  -quiet -dict {PACKAGE_PIN E31   } [get_ports rx_data_p[0]     ]    ; ## FMC1_DP0_M2C_P MGTHRXP0_130
set_property  -quiet -dict {PACKAGE_PIN F34   } [get_ports rx_data_n[7]     ]    ; ## FMC1_DP7_M2C_N MGTHRXN3_129
set_property  -quiet -dict {PACKAGE_PIN F33   } [get_ports rx_data_p[7]     ]    ; ## FMC1_DP7_M2C_P MGTHRXP3_129
set_property  -quiet -dict {PACKAGE_PIN H34   } [get_ports rx_data_n[6]     ]    ; ## FMC1_DP6_M2C_N MGTHRXN2_129
set_property  -quiet -dict {PACKAGE_PIN H33   } [get_ports rx_data_p[6]     ]    ; ## FMC1_DP6_M2C_P MGTHRXP2_129
set_property  -quiet -dict {PACKAGE_PIN K34   } [get_ports rx_data_n[5]     ]    ; ## FMC1_DP5_M2C_N MGTHRXN1_129
set_property  -quiet -dict {PACKAGE_PIN K33   } [get_ports rx_data_p[5]     ]    ; ## FMC1_DP5_M2C_P MGTHRXP1_129
set_property  -quiet -dict {PACKAGE_PIN L32   } [get_ports rx_data_n[4]     ]    ; ## FMC1_DP4_M2C_N MGTHRXN0_129
set_property  -quiet -dict {PACKAGE_PIN L31   } [get_ports rx_data_p[4]     ]    ; ## FMC1_DP4_M2C_P MGTHRXP0_129
set_property  -quiet -dict {PACKAGE_PIN B34   } [get_ports rx_data_n[3]     ]    ; ## FMC1_DP3_M2C_N MGTHRXN3_130
set_property  -quiet -dict {PACKAGE_PIN B33   } [get_ports rx_data_p[3]     ]    ; ## FMC1_DP3_M2C_P MGTHRXP3_130
set_property  -quiet -dict {PACKAGE_PIN D34   } [get_ports rx_data_n[1]     ]    ; ## FMC1_DP1_M2C_N MGTHRXN1_130
set_property  -quiet -dict {PACKAGE_PIN D33   } [get_ports rx_data_p[1]     ]    ; ## FMC1_DP1_M2C_P MGTHRXP1_130
set_property  -quiet -dict {PACKAGE_PIN F30   } [get_ports tx_data_n[0]     ]    ; ## FMC1_DP0_C2M_N MGTHTXN0_130
set_property  -quiet -dict {PACKAGE_PIN F29   } [get_ports tx_data_p[0]     ]    ; ## FMC1_DP0_C2M_P MGTHTXP0_130
set_property  -quiet -dict {PACKAGE_PIN B30   } [get_ports tx_data_n[2]     ]    ; ## FMC1_DP2_C2M_N MGTHTXN2_130
set_property  -quiet -dict {PACKAGE_PIN B29   } [get_ports tx_data_p[2]     ]    ; ## FMC1_DP2_C2M_P MGTHTXP2_130
set_property  -quiet -dict {PACKAGE_PIN G32   } [get_ports tx_data_n[7]     ]    ; ## FMC1_DP7_C2M_N MGTHTXN3_129
set_property  -quiet -dict {PACKAGE_PIN G31   } [get_ports tx_data_p[7]     ]    ; ## FMC1_DP7_C2M_P MGTHTXP3_129
set_property  -quiet -dict {PACKAGE_PIN H30   } [get_ports tx_data_n[6]     ]    ; ## FMC1_DP6_C2M_N MGTHTXN2_129
set_property  -quiet -dict {PACKAGE_PIN H29   } [get_ports tx_data_p[6]     ]    ; ## FMC1_DP6_C2M_P MGTHTXP2_129
set_property  -quiet -dict {PACKAGE_PIN D30   } [get_ports tx_data_n[1]     ]    ; ## FMC1_DP1_C2M_N MGTHTXN1_130
set_property  -quiet -dict {PACKAGE_PIN D29   } [get_ports tx_data_p[1]     ]    ; ## FMC1_DP1_C2M_P MGTHTXP1_130
set_property  -quiet -dict {PACKAGE_PIN J32   } [get_ports tx_data_n[5]     ]    ; ## FMC1_DP5_C2M_N MGTHTXN1_129
set_property  -quiet -dict {PACKAGE_PIN J31   } [get_ports tx_data_p[5]     ]    ; ## FMC1_DP5_C2M_P MGTHTXP1_129
set_property  -quiet -dict {PACKAGE_PIN K30   } [get_ports tx_data_n[4]     ]    ; ## FMC1_DP4_C2M_N MGTHTXN0_129
set_property  -quiet -dict {PACKAGE_PIN K29   } [get_ports tx_data_p[4]     ]    ; ## FMC1_DP4_C2M_P MGTHTXP0_129
set_property  -quiet -dict {PACKAGE_PIN A32   } [get_ports tx_data_n[3]     ]    ; ## FMC1_DP3_C2M_N MGTHTXN3_130
set_property  -quiet -dict {PACKAGE_PIN A31   } [get_ports tx_data_p[3]     ]    ; ## FMC1_DP3_C2M_P MGTHTXP3_130
set_property  -quiet -dict {PACKAGE_PIN AD1   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_0_n  ]    ; ## FMC1_LA02_N IO_L23N_T3U_N9_65
set_property  -quiet -dict {PACKAGE_PIN AD2   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100              } [get_ports fpga_syncin_0_p  ]    ; ## FMC1_LA02_P IO_L23P_T3U_N8_I2C_SCLK_65
set_property  -quiet -dict {PACKAGE_PIN AJ1   IOSTANDARD LVCMOS18                                     } [get_ports fpga_syncin_1_n  ]    ; ## FMC1_LA03_N IO_L22N_T3U_N7_DBC_AD0N_65
set_property  -quiet -dict {PACKAGE_PIN AH1   IOSTANDARD LVCMOS18                                     } [get_ports fpga_syncin_1_p  ]    ; ## FMC1_LA03_P IO_L22P_T3U_N6_DBC_AD0P_65
set_property  -quiet -dict {PACKAGE_PIN AJ5   IOSTANDARD LVDS                                         } [get_ports fpga_syncout_0_n ]    ; ## FMC1_LA01_CC_N IO_L16N_T2U_N7_QBC_AD3N_65
set_property  -quiet -dict {PACKAGE_PIN AJ6   IOSTANDARD LVDS                                         } [get_ports fpga_syncout_0_p ]    ; ## FMC1_LA01_CC_P IO_L16P_T2U_N6_QBC_AD3P_65
set_property  -quiet -dict {PACKAGE_PIN AJ2   IOSTANDARD LVCMOS18                                     } [get_ports fpga_syncout_1_n ]    ; ## FMC1_LA06_N IO_L19N_T3L_N1_DBC_AD9N_65
set_property  -quiet -dict {PACKAGE_PIN AH2   IOSTANDARD LVCMOS18                                     } [get_ports fpga_syncout_1_p ]    ; ## FMC1_LA06_P IO_L19P_T3L_N0_DBC_AD9P_65
set_property         -dict {PACKAGE_PIN AD10  IOSTANDARD LVCMOS18                                     } [get_ports gpio[0]          ]    ; ## FMC1_LA15_P IO_L6P_T0U_N10_AD6P_65
set_property         -dict {PACKAGE_PIN AE9   IOSTANDARD LVCMOS18                                     } [get_ports gpio[1]          ]    ; ## FMC1_LA15_N IO_L6N_T0U_N11_AD6N_65
set_property         -dict {PACKAGE_PIN AA11  IOSTANDARD LVCMOS18                                     } [get_ports gpio[2]          ]    ; ## FMC1_LA19_P IO_L3P_T0L_N4_AD15P_66
set_property         -dict {PACKAGE_PIN AA10  IOSTANDARD LVCMOS18                                     } [get_ports gpio[3]          ]    ; ## FMC1_LA19_N IO_L3N_T0L_N5_AD15N_66
set_property         -dict {PACKAGE_PIN AG8   IOSTANDARD LVCMOS18                                     } [get_ports gpio[4]          ]    ; ## FMC1_LA13_P IO_L8P_T1L_N2_AD5P_65
set_property         -dict {PACKAGE_PIN AH8   IOSTANDARD LVCMOS18                                     } [get_ports gpio[5]          ]    ; ## FMC1_LA13_N IO_L8N_T1L_N3_AD5N_65
set_property         -dict {PACKAGE_PIN AH7   IOSTANDARD LVCMOS18                                     } [get_ports gpio[6]          ]    ; ## FMC1_LA14_P IO_L7P_T1L_N0_QBC_AD13P_65
set_property         -dict {PACKAGE_PIN AH6   IOSTANDARD LVCMOS18                                     } [get_ports gpio[7]          ]    ; ## FMC1_LA14_N IO_L7N_T1L_N1_QBC_AD13N_65
set_property         -dict {PACKAGE_PIN AG10  IOSTANDARD LVCMOS18                                     } [get_ports gpio[8]          ]    ; ## FMC1_LA16_P IO_L5P_T0U_N8_AD14P_65
set_property         -dict {PACKAGE_PIN AG9   IOSTANDARD LVCMOS18                                     } [get_ports gpio[9]          ]    ; ## FMC1_LA16_N IO_L5N_T0U_N9_AD14N_65
set_property         -dict {PACKAGE_PIN AG11  IOSTANDARD LVCMOS18                                     } [get_ports gpio[10]         ]    ; ## FMC1_LA22_N IO_L4N_T0U_N7_DBC_AD7N_65
set_property         -dict {PACKAGE_PIN AF8   IOSTANDARD LVCMOS18                                     } [get_ports hmc_gpio1        ]    ; ## FMC1_LA11_N IO_L10N_T1U_N7_QBC_AD4N_65
set_property         -dict {PACKAGE_PIN AE4   IOSTANDARD LVCMOS18                                     } [get_ports hmc_sync         ]    ; ## FMC1_LA07_N IO_L18N_T2U_N11_AD2N_65
set_property         -dict {PACKAGE_PIN AE3   IOSTANDARD LVCMOS18                                     } [get_ports irqb[0]          ]    ; ## FMC1_LA08_P IO_L17P_T2U_N8_AD10P_65
set_property         -dict {PACKAGE_PIN AF3   IOSTANDARD LVCMOS18                                     } [get_ports irqb[1]          ]    ; ## FMC1_LA08_N IO_L17N_T2U_N9_AD10N_65
set_property         -dict {PACKAGE_PIN AD4   IOSTANDARD LVCMOS18                                     } [get_ports rstb             ]    ; ## FMC1_LA07_P IO_L18P_T2U_N10_AD2P_65
set_property         -dict {PACKAGE_PIN AH4   IOSTANDARD LVCMOS18                                     } [get_ports rxen[0]          ]    ; ## FMC1_LA10_P IO_L15P_T2L_N4_AD11P_65
set_property         -dict {PACKAGE_PIN AJ4   IOSTANDARD LVCMOS18                                     } [get_ports rxen[1]          ]    ; ## FMC1_LA10_N IO_L15N_T2L_N5_AD11N_65
set_property         -dict {PACKAGE_PIN AG3   IOSTANDARD LVCMOS18                                     } [get_ports spi0_csb         ]    ; ## FMC1_LA05_P IO_L20P_T3L_N2_AD1P_65
set_property         -dict {PACKAGE_PIN AH3   IOSTANDARD LVCMOS18                                     } [get_ports spi0_miso        ]    ; ## FMC1_LA05_N IO_L20N_T3L_N3_AD1N_65
set_property         -dict {PACKAGE_PIN AF2   IOSTANDARD LVCMOS18                                     } [get_ports spi0_mosi        ]    ; ## FMC1_LA04_P IO_L21P_T3L_N4_AD8P_65
set_property         -dict {PACKAGE_PIN AF1   IOSTANDARD LVCMOS18                                     } [get_ports spi0_sclk        ]    ; ## FMC1_LA04_N IO_L21N_T3L_N5_AD8N_65
set_property         -dict {PACKAGE_PIN AD7   IOSTANDARD LVCMOS18                                     } [get_ports spi1_csb         ]    ; ## FMC1_LA12_P IO_L9P_T1L_N4_AD12P_65
set_property         -dict {PACKAGE_PIN AE8   IOSTANDARD LVCMOS18                                     } [get_ports spi1_sclk        ]    ; ## FMC1_LA11_P IO_L10P_T1U_N6_QBC_AD4P_65
set_property         -dict {PACKAGE_PIN AD6   IOSTANDARD LVCMOS18                                     } [get_ports spi1_sdio        ]    ; ## FMC1_LA12_N IO_L9N_T1L_N5_AD12N_65
set_property         -dict {PACKAGE_PIN AF7   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref2_n        ]    ; ## FMC1_CLK0_M2C_N IO_L12N_T1U_N11_GC_65
set_property         -dict {PACKAGE_PIN AE7   IOSTANDARD LVDS     DIFF_TERM_ADV TERM_100 DQS_BIAS TRUE} [get_ports sysref2_p        ]    ; ## FMC1_CLK0_M2C_P IO_L12P_T1U_N10_GC_65
set_property         -dict {PACKAGE_PIN AE2   IOSTANDARD LVCMOS18                                     } [get_ports txen[0]          ]    ; ## FMC1_LA09_P IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property         -dict {PACKAGE_PIN AE1   IOSTANDARD LVCMOS18                                     } [get_ports txen[1]          ]    ; ## FMC1_LA09_N IO_L24N_T3U_N11_PERSTN0_65

# set false path to output ports which connect to devices without any clocks
set_false_path -to   [get_ports TR_01]
set_false_path -to   [get_ports TX_LOAD_01]
set_false_path -to   [get_ports RX_LOAD_01]
set_false_path -to   [get_ports BF_PWR_EN_01]
set_false_path -to   [get_ports BF_PA_ON_01]
set_false_path -to   [get_ports TR_02]
set_false_path -to   [get_ports TX_LOAD_02]
set_false_path -to   [get_ports RX_LOAD_02]
set_false_path -to   [get_ports BF_PWR_EN_02]
set_false_path -to   [get_ports BF_PA_ON_02]
set_false_path -to   [get_ports TR_03]
set_false_path -to   [get_ports TX_LOAD_03]
set_false_path -to   [get_ports RX_LOAD_03]
set_false_path -to   [get_ports BF_PWR_EN_03]
set_false_path -to   [get_ports BF_PA_ON_03]
set_false_path -to   [get_ports TR_04]
set_false_path -to   [get_ports TX_LOAD_04]
set_false_path -to   [get_ports RX_LOAD_04]
set_false_path -to   [get_ports BF_PWR_EN_04]
set_false_path -to   [get_ports BF_PA_ON_04]
set_false_path -to   [get_ports XUD_RX_GAIN_MODE]
set_false_path -to   [get_ports XUD_PLL_OUTPUT_SEL]
set_false_path -to   [get_ports XUD_TXRX0]
set_false_path -to   [get_ports XUD_TXRX1]
set_false_path -to   [get_ports XUD_TXRX2]
set_false_path -to   [get_ports XUD_TXRX3]
set_false_path -from [get_ports PG_PA_VGG_01]
set_false_path -from [get_ports PG_PA_VGG_02]
set_false_path -from [get_ports PG_PA_VGG_03]
set_false_path -from [get_ports PG_PA_VGG_04]

set_false_path -to   [get_ports tdd_sync_in_debug]
set_false_path -to   [get_ports tdd_sync_out_debug]
set_false_path -to   [get_ports tdd_enable_debug]

set trce_dly_max   0.800; # maximum board trace delay
set trce_dly_min   0.900; # minimum board trace delay

# BF SPI 01

create_generated_clock -name BF_SPI_SCLK_01 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_01]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_01 BF_SPI_MOSI_01]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_01]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 02

create_generated_clock -name BF_SPI_SCLK_02 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_02]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_02 BF_SPI_MOSI_02]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_02]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 03

create_generated_clock -name BF_SPI_SCLK_03 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_03]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_03 BF_SPI_MOSI_03]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_03]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# BF SPI 04

create_generated_clock -name BF_SPI_SCLK_04 -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports BF_SPI_SCLK_04]
set tsu          5.000;      # destination device setup time requirement
set thd          5.000;      # destination device hold time requirement
set output_ports [get_ports [list BF_SPI_CSB_04 BF_SPI_MOSI_04]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports BF_SPI_MISO_04]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

# XUD SPI

create_generated_clock -name XUD_SPI_SCLK -source [get_pins -of_objects [get_clocks clk_pl_3]] -divide_by 2 [get_ports XUD_SPI_SCLK]
set tsu          0.000;      # destination device setup time requirement
set thd          0.000;      # destination device hold time requirement
set output_ports [get_ports [list XUD_SPI_CSB XUD_SPI_MOSI]]; # list of output ports
set_output_delay -clock [get_clocks clk_pl_3] -max [expr $trce_dly_max + $tsu] [get_ports $output_ports];
set_output_delay -clock [get_clocks clk_pl_3] -min [expr $trce_dly_min - $thd] [get_ports $output_ports];
set tco_max     5.000;     # Maximum clock to out delay
set tco_min     5.000;     # Minimum clock to out delay
set input_ports [get_ports XUD_SPI_MISO]; # list of input ports
set_input_delay -clock [get_clocks clk_pl_3] -max [expr $tco_max + $trce_dly_max * 2] [get_ports $input_ports];
set_input_delay -clock [get_clocks clk_pl_3] -min [expr $tco_min + $trce_dly_min * 2] [get_ports $input_ports];

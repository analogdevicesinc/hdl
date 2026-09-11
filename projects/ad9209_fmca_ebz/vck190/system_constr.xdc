###############################################################################
## Copyright (C) 2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

#
## mxfe
#

set_property         -dict {PACKAGE_PIN BB16  IOSTANDARD LVCMOS15                                     } [get_ports agc0[0]          ]    ; ## FMC0_LA17_CC_P      IO_L13P_T2L_N0_GC_QBC_67   
set_property         -dict {PACKAGE_PIN BC16  IOSTANDARD LVCMOS15                                     } [get_ports agc0[1]          ]    ; ## FMC0_LA17_CC_N      IO_L13N_T2L_N1_GC_QBC_67
set_property         -dict {PACKAGE_PIN BE17  IOSTANDARD LVCMOS15                                     } [get_ports agc1[0]          ]    ; ## FMC0_LA18_CC_P      IO_L16P_T2U_N6_QBC_AD3P_67
set_property         -dict {PACKAGE_PIN BD17  IOSTANDARD LVCMOS15                                     } [get_ports agc1[1]          ]    ; ## FMC0_LA18_CC_N      IO_L16N_T2U_N7_QBC_AD3N_67
set_property         -dict {PACKAGE_PIN BE16  IOSTANDARD LVCMOS15                                     } [get_ports agc2[0]          ]    ; ## FMC0_LA20_P         IO_L22P_T3U_N6_DBC_AD0P_67
set_property         -dict {PACKAGE_PIN BF17  IOSTANDARD LVCMOS15                                     } [get_ports agc2[1]          ]    ; ## FMC0_LA20_N         IO_L22N_T3U_N7_DBC_AD0N_67
set_property         -dict {PACKAGE_PIN BE19  IOSTANDARD LVCMOS15                                     } [get_ports agc3[0]          ]    ; ## FMC0_LA21_P         IO_L21P_T3L_N4_AD8P_67
set_property         -dict {PACKAGE_PIN BD19  IOSTANDARD LVCMOS15                                     } [get_ports agc3[1]          ]    ; ## FMC0_LA21_N         IO_L21N_T3L_N5_AD8N_67
set_property         -dict {PACKAGE_PIN BD24  IOSTANDARD LVDS15   DIFF_TERM_ADV TERM_100              } [get_ports clkin10_n        ]    ; ## FMC0_CLK2_IO_N      IO_L13N_T2L_N1_GC_QBC_66 
set_property         -dict {PACKAGE_PIN BD23  IOSTANDARD LVDS15   DIFF_TERM_ADV TERM_100              } [get_ports clkin10_p        ]    ; ## FMC0_CLK2_IO_P      IO_L13P_T2L_N0_GC_QBC_66
set_property         -dict {PACKAGE_PIN M14                                                           } [get_ports fpga_refclk_in_n ]    ; ## FMC0_GBTCLK0_M2C_N  MGTREFCLK0N_229
set_property         -dict {PACKAGE_PIN M15                                                           } [get_ports fpga_refclk_in_p ]    ; ## FMC0_GBTCLK0_M2C_P  MGTREFCLK0P_229
set_property         -dict {PACKAGE_PIN Y1                                                            } [get_ports rx_data_n[2]     ]    ; ## FMC0_DP2_M2C_N      MGTHRXN3_229    FPGA_SERDIN_0_N
set_property         -dict {PACKAGE_PIN Y2                                                            } [get_ports rx_data_p[2]     ]    ; ## FMC0_DP2_M2C_P      MGTHRXP3_229    FPGA_SERDIN_0_P
set_property         -dict {PACKAGE_PIN AB1                                                           } [get_ports rx_data_n[0]     ]    ; ## FMC0_DP0_M2C_N      MGTHRXN2_229    FPGA_SERDIN_1_N
set_property         -dict {PACKAGE_PIN AB2                                                           } [get_ports rx_data_p[0]     ]    ; ## FMC0_DP0_M2C_P      MGTHRXP2_229    FPGA_SERDIN_1_P
set_property         -dict {PACKAGE_PIN R3                                                            } [get_ports rx_data_n[7]     ]    ; ## FMC0_DP7_M2C_N      MGTHRXN2_228    FPGA_SERDIN_2_N
set_property         -dict {PACKAGE_PIN R4                                                            } [get_ports rx_data_p[7]     ]    ; ## FMC0_DP7_M2C_P      MGTHRXP2_228    FPGA_SERDIN_2_P
set_property         -dict {PACKAGE_PIN T1                                                            } [get_ports rx_data_n[6]     ]    ; ## FMC0_DP6_M2C_N      MGTHRXN0_228    FPGA_SERDIN_3_N
set_property         -dict {PACKAGE_PIN T2                                                            } [get_ports rx_data_p[6]     ]    ; ## FMC0_DP6_M2C_P      MGTHRXP0_228    FPGA_SERDIN_3_P
set_property         -dict {PACKAGE_PIN U3                                                            } [get_ports rx_data_n[5]     ]    ; ## FMC0_DP5_M2C_N      MGTHRXN1_228    FPGA_SERDIN_4_N
set_property         -dict {PACKAGE_PIN U4                                                            } [get_ports rx_data_p[5]     ]    ; ## FMC0_DP5_M2C_P      MGTHRXP1_228    FPGA_SERDIN_4_P
set_property         -dict {PACKAGE_PIN V1                                                            } [get_ports rx_data_n[4]     ]    ; ## FMC0_DP4_M2C_N      MGTHRXN3_228    FPGA_SERDIN_5_N
set_property         -dict {PACKAGE_PIN V2                                                            } [get_ports rx_data_p[4]     ]    ; ## FMC0_DP4_M2C_P      MGTHRXP3_228    FPGA_SERDIN_5_P
set_property         -dict {PACKAGE_PIN W3                                                            } [get_ports rx_data_n[3]     ]    ; ## FMC0_DP3_M2C_N      MGTHRXN0_229    FPGA_SERDIN_6_N
set_property         -dict {PACKAGE_PIN W4                                                            } [get_ports rx_data_p[3]     ]    ; ## FMC0_DP3_M2C_P      MGTHRXP0_229    FPGA_SERDIN_6_P
set_property         -dict {PACKAGE_PIN AA3                                                           } [get_ports rx_data_n[1]     ]    ; ## FMC0_DP1_M2C_N      MGTHRXN1_229    FPGA_SERDIN_7_N
set_property         -dict {PACKAGE_PIN AA4                                                           } [get_ports rx_data_p[1]     ]    ; ## FMC0_DP1_M2C_P      MGTHRXP1_229    FPGA_SERDIN_7_P
set_property         -dict {PACKAGE_PIN BD22  IOSTANDARD LVDS15                                       } [get_ports fpga_syncout_0_n ]    ; ## FMC0_LA01_CC_N      IO_L16N_T2U_N7_QBC_AD3N_66
set_property         -dict {PACKAGE_PIN BC23  IOSTANDARD LVDS15                                       } [get_ports fpga_syncout_0_p ]    ; ## FMC0_LA01_CC_P      IO_L16P_T2U_N6_QBC_AD3P_66
set_property         -dict {PACKAGE_PIN BD20  IOSTANDARD LVCMOS15                                     } [get_ports fpga_syncout_1_n ]    ; ## FMC0_LA06_N         IO_L19N_T3L_N1_DBC_AD9N_66
set_property         -dict {PACKAGE_PIN BC20  IOSTANDARD LVCMOS15                                     } [get_ports fpga_syncout_1_p ]    ; ## FMC0_LA06_P         IO_L19P_T3L_N0_DBC_AD9P_66
set_property         -dict {PACKAGE_PIN AY22  IOSTANDARD LVCMOS15                                     } [get_ports gpio[0]          ]    ; ## FMC0_LA15_P         IO_L6P_T0U_N10_AD6P_66
set_property         -dict {PACKAGE_PIN AY23  IOSTANDARD LVCMOS15                                     } [get_ports gpio[1]          ]    ; ## FMC0_LA15_N         IO_L6N_T0U_N11_AD6N_66
set_property         -dict {PACKAGE_PIN BA17  IOSTANDARD LVCMOS15                                     } [get_ports gpio[2]          ]    ; ## FMC0_LA19_P         IO_L23P_T3U_N8_67
set_property         -dict {PACKAGE_PIN BA16  IOSTANDARD LVCMOS15                                     } [get_ports gpio[3]          ]    ; ## FMC0_LA19_N         IO_L23N_T3U_N9_67
set_property         -dict {PACKAGE_PIN BE21  IOSTANDARD LVCMOS15                                     } [get_ports gpio[4]          ]    ; ## FMC0_LA13_P         IO_L8P_T1L_N2_AD5P_66
set_property         -dict {PACKAGE_PIN BE20  IOSTANDARD LVCMOS15                                     } [get_ports gpio[5]          ]    ; ## FMC0_LA13_N         IO_L8N_T1L_N3_AD5N_66
set_property         -dict {PACKAGE_PIN AU24  IOSTANDARD LVCMOS15                                     } [get_ports gpio[6]          ]    ; ## FMC0_LA14_P         IO_L7P_T1L_N0_QBC_AD13P_66
set_property         -dict {PACKAGE_PIN AU23  IOSTANDARD LVCMOS15                                     } [get_ports gpio[7]          ]    ; ## FMC0_LA14_N         IO_L7N_T1L_N1_QBC_AD13N_66
set_property         -dict {PACKAGE_PIN BF21  IOSTANDARD LVCMOS15                                     } [get_ports gpio[8]          ]    ; ## FMC0_LA16_P         IO_L5P_T0U_N8_AD14P_66
set_property         -dict {PACKAGE_PIN BG20  IOSTANDARD LVCMOS15                                     } [get_ports gpio[9]          ]    ; ## FMC0_LA16_N         IO_L5N_T0U_N9_AD14N_66
set_property         -dict {PACKAGE_PIN BG18  IOSTANDARD LVCMOS15                                     } [get_ports gpio[10]         ]    ; ## FMC0_LA22_N         IO_L20N_T3L_N3_AD1N_67
set_property         -dict {PACKAGE_PIN BE22  IOSTANDARD LVCMOS15                                     } [get_ports hmc_gpio1        ]    ; ## FMC0_LA11_N         IO_L10N_T1U_N7_QBC_AD4N_66
set_property         -dict {PACKAGE_PIN BD25  IOSTANDARD LVCMOS15                                     } [get_ports hmc_sync         ]    ; ## FMC0_LA07_N         IO_L18N_T2U_N11_AD2N_66
set_property         -dict {PACKAGE_PIN BC22  IOSTANDARD LVCMOS15                                     } [get_ports irqb[0]          ]    ; ## FMC0_LA08_P         IO_L17P_T2U_N8_AD10P_66
set_property         -dict {PACKAGE_PIN BC21  IOSTANDARD LVCMOS15                                     } [get_ports irqb[1]          ]    ; ## FMC0_LA08_N         IO_L17N_T2U_N9_AD10N_66
set_property         -dict {PACKAGE_PIN BC25  IOSTANDARD LVCMOS15                                     } [get_ports rstb             ]    ; ## FMC0_LA07_P         IO_L18P_T2U_N10_AD2P_66
set_property         -dict {PACKAGE_PIN BG25  IOSTANDARD LVCMOS15                                     } [get_ports rxen[0]          ]    ; ## FMC0_LA10_P         IO_L15P_T2L_N4_AD11P_66
set_property         -dict {PACKAGE_PIN BG24  IOSTANDARD LVCMOS15                                     } [get_ports rxen[1]          ]    ; ## FMC0_LA10_N         IO_L15N_T2L_N5_AD11N_66
set_property         -dict {PACKAGE_PIN BF24  IOSTANDARD LVCMOS15                                     } [get_ports spi0_csb         ]    ; ## FMC0_LA05_P         IO_L20P_T3L_N2_AD1P_66
set_property         -dict {PACKAGE_PIN BG23  IOSTANDARD LVCMOS15                                     } [get_ports spi0_miso        ]    ; ## FMC0_LA05_N         IO_L20N_T3L_N3_AD1N_66
set_property         -dict {PACKAGE_PIN AU21  IOSTANDARD LVCMOS15                                     } [get_ports spi0_mosi        ]    ; ## FMC0_LA04_P         IO_L21P_T3L_N4_AD8P_66
set_property         -dict {PACKAGE_PIN AV21  IOSTANDARD LVCMOS15                                     } [get_ports spi0_sclk        ]    ; ## FMC0_LA04_N         IO_L21N_T3L_N5_AD8N_66
set_property         -dict {PACKAGE_PIN BG21  IOSTANDARD LVCMOS15                                     } [get_ports spi1_csb         ]    ; ## FMC0_LA12_P         IO_L9P_T1L_N4_AD12P_66
set_property         -dict {PACKAGE_PIN BF23  IOSTANDARD LVCMOS15                                     } [get_ports spi1_sclk        ]    ; ## FMC0_LA11_P         IO_L10P_T1U_N6_QBC_AD4P_66
set_property         -dict {PACKAGE_PIN BF22  IOSTANDARD LVCMOS15                                     } [get_ports spi1_sdio        ]    ; ## FMC0_LA12_N         IO_L9N_T1L_N5_AD12N_66
set_property         -dict {PACKAGE_PIN AW23  IOSTANDARD LVDS15   DIFF_TERM_ADV TERM_100              } [get_ports sysref2_n        ]    ; ## FMC0_CLK0_M2C_N     IO_L12N_T1U_N11_GC_66
set_property         -dict {PACKAGE_PIN AV23  IOSTANDARD LVDS15   DIFF_TERM_ADV TERM_100              } [get_ports sysref2_p        ]    ; ## FMC0_CLK0_M2C_P     IO_L12P_T1U_N10_GC_66


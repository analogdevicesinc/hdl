###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## Apollo
#

set_property   -dict {PACKAGE_PIN K1                                                  } [get_ports stxb_n[0]          ]    ;  ## FMC2_DP0_M2C_N   GTY_204
set_property   -dict {PACKAGE_PIN K2                                                  } [get_ports stxb_p[0]          ]    ;  ## FMC2_DP0_M2C_P   GTY_204
set_property   -dict {PACKAGE_PIN J3                                                  } [get_ports stxb_n[1]          ]    ;  ## FMC2_DP1_M2C_N   GTY_204
set_property   -dict {PACKAGE_PIN J4                                                  } [get_ports stxb_p[1]          ]    ;  ## FMC2_DP1_M2C_P   GTY_204
set_property   -dict {PACKAGE_PIN H1                                                  } [get_ports stxb_n[2]          ]    ;  ## FMC2_DP2_M2C_N   GTY_204
set_property   -dict {PACKAGE_PIN H2                                                  } [get_ports stxb_p[2]          ]    ;  ## FMC2_DP2_M2C_P   GTY_204
set_property   -dict {PACKAGE_PIN H5                                                  } [get_ports stxb_n[3]          ]    ;  ## FMC2_DP3_M2C_N   GTY_204
set_property   -dict {PACKAGE_PIN H6                                                  } [get_ports stxb_p[3]          ]    ;  ## FMC2_DP3_M2C_P   GTY_204
set_property   -dict {PACKAGE_PIN G3                                                  } [get_ports stxa_n[0]          ]    ;  ## FMC2_DP4_M2C_N   GTY_205
set_property   -dict {PACKAGE_PIN G4                                                  } [get_ports stxa_p[0]          ]    ;  ## FMC2_DP4_M2C_P   GTY_205
set_property   -dict {PACKAGE_PIN F1                                                  } [get_ports stxa_n[1]          ]    ;  ## FMC2_DP5_M2C_N   GTY_205
set_property   -dict {PACKAGE_PIN F2                                                  } [get_ports stxa_p[1]          ]    ;  ## FMC2_DP5_M2C_P   GTY_205
set_property   -dict {PACKAGE_PIN F5                                                  } [get_ports stxa_n[2]          ]    ;  ## FMC2_DP6_M2C_N   GTY_205
set_property   -dict {PACKAGE_PIN F6                                                  } [get_ports stxa_p[2]          ]    ;  ## FMC2_DP6_M2C_P   GTY_205
set_property   -dict {PACKAGE_PIN E3                                                  } [get_ports stxa_n[3]          ]    ;  ## FMC2_DP7_M2C_N   GTY_205
set_property   -dict {PACKAGE_PIN E4                                                  } [get_ports stxa_p[3]          ]    ;  ## FMC2_DP7_M2C_P   GTY_205
set_property   -dict {PACKAGE_PIN D1                                                  } [get_ports stxb_n[4]          ]    ;  ## FMC2_DP8_M2C_N   GTY_206
set_property   -dict {PACKAGE_PIN D2                                                  } [get_ports stxb_p[4]          ]    ;  ## FMC2_DP8_M2C_P   GTY_206
set_property   -dict {PACKAGE_PIN D5                                                  } [get_ports stxb_n[5]          ]    ;  ## FMC2_DP9_M2C_N   GTY_206
set_property   -dict {PACKAGE_PIN D6                                                  } [get_ports stxb_p[5]          ]    ;  ## FMC2_DP9_M2C_P   GTY_206
set_property   -dict {PACKAGE_PIN C3                                                  } [get_ports stxb_n[6]          ]    ;  ## FMC2_DP10_M2C_N  GTY_206
set_property   -dict {PACKAGE_PIN C4                                                  } [get_ports stxb_p[6]          ]    ;  ## FMC2_DP10_M2C_P  GTY_206
set_property   -dict {PACKAGE_PIN B5                                                  } [get_ports stxb_n[7]          ]    ;  ## FMC2_DP11_M2C_N  GTY_206
set_property   -dict {PACKAGE_PIN B6                                                  } [get_ports stxb_p[7]          ]    ;  ## FMC2_DP11_M2C_P  GTY_206

set_property   -dict {PACKAGE_PIN  K6                                                 } [get_ports srxb_n[0]          ]    ;  ## FMC2_DP0_C2M_N   GTY_204
set_property   -dict {PACKAGE_PIN  K7                                                 } [get_ports srxb_p[0]          ]    ;  ## FMC2_DP0_C2M_P   GTY_204
set_property   -dict {PACKAGE_PIN  K10                                                } [get_ports srxb_n[1]          ]    ;  ## FMC2_DP1_C2M_N   GTY_204
set_property   -dict {PACKAGE_PIN  K11                                                } [get_ports srxb_p[1]          ]    ;  ## FMC2_DP1_C2M_P   GTY_204
set_property   -dict {PACKAGE_PIN  J8                                                 } [get_ports srxb_n[2]          ]    ;  ## FMC2_DP2_C2M_N   GTY_204
set_property   -dict {PACKAGE_PIN  J9                                                 } [get_ports srxb_p[2]          ]    ;  ## FMC2_DP2_C2M_P   GTY_204
set_property   -dict {PACKAGE_PIN  H10                                                } [get_ports srxb_n[3]          ]    ;  ## FMC2_DP3_C2M_N   GTY_204
set_property   -dict {PACKAGE_PIN  H11                                                } [get_ports srxb_p[3]          ]    ;  ## FMC2_DP3_C2M_P   GTY_204
set_property   -dict {PACKAGE_PIN  G8                                                 } [get_ports srxa_n[0]          ]    ;  ## FMC2_DP4_C2M_N   GTY_205
set_property   -dict {PACKAGE_PIN  G9                                                 } [get_ports srxa_p[0]          ]    ;  ## FMC2_DP4_C2M_P   GTY_205
set_property   -dict {PACKAGE_PIN  F10                                                } [get_ports srxa_n[1]          ]    ;  ## FMC2_DP5_C2M_N   GTY_205
set_property   -dict {PACKAGE_PIN  F11                                                } [get_ports srxa_p[1]          ]    ;  ## FMC2_DP5_C2M_P   GTY_205
set_property   -dict {PACKAGE_PIN  E8                                                 } [get_ports srxa_n[2]          ]    ;  ## FMC2_DP6_C2M_N   GTY_205
set_property   -dict {PACKAGE_PIN  E9                                                 } [get_ports srxa_p[2]          ]    ;  ## FMC2_DP6_C2M_P   GTY_205
set_property   -dict {PACKAGE_PIN  D10                                                } [get_ports srxa_n[3]          ]    ;  ## FMC2_DP7_C2M_N   GTY_205
set_property   -dict {PACKAGE_PIN  D11                                                } [get_ports srxa_p[3]          ]    ;  ## FMC2_DP7_C2M_P   GTY_205
set_property   -dict {PACKAGE_PIN  C8                                                 } [get_ports srxb_n[4]          ]    ;  ## FMC2_DP8_C2M_N   GTY_206
set_property   -dict {PACKAGE_PIN  C9                                                 } [get_ports srxb_p[4]          ]    ;  ## FMC2_DP8_C2M_P   GTY_206
set_property   -dict {PACKAGE_PIN  B10                                                } [get_ports srxb_n[5]          ]    ;  ## FMC2_DP9_C2M_N   GTY_206
set_property   -dict {PACKAGE_PIN  B11                                                } [get_ports srxb_p[5]          ]    ;  ## FMC2_DP9_C2M_P   GTY_206
set_property   -dict {PACKAGE_PIN  A8                                                 } [get_ports srxb_n[6]          ]    ;  ## FMC2_DP10_C2M_N  GTY_206
set_property   -dict {PACKAGE_PIN  A9                                                 } [get_ports srxb_p[6]          ]    ;  ## FMC2_DP10_C2M_P  GTY_206
set_property   -dict {PACKAGE_PIN  A12                                                } [get_ports srxb_n[7]          ]    ;  ## FMC2_DP11_C2M_N  GTY_206
set_property   -dict {PACKAGE_PIN  A13                                                } [get_ports srxb_p[7]          ]    ;  ## FMC2_DP11_C2M_P  GTY_206

set_property   -dict {PACKAGE_PIN AU12  IOSTANDARD LVCMOS15                           } [get_ports gpio[15]		        ]    ;  ## FMC2_LA06_P
set_property   -dict {PACKAGE_PIN AU11  IOSTANDARD LVCMOS15                           } [get_ports gpio[16]		        ]    ;  ## FMC2_LA06_N
set_property   -dict {PACKAGE_PIN BE15  IOSTANDARD LVCMOS15                           } [get_ports gpio[23]		        ]    ;  ## FMC2_LA14_P
set_property   -dict {PACKAGE_PIN BE14  IOSTANDARD LVCMOS15                           } [get_ports gpio[24]		        ]    ;  ## FMC2_LA14_N
set_property   -dict {PACKAGE_PIN AU13  IOSTANDARD LVCMOS15                           } [get_ports gpio[27]	          ]    ;  ## FMC2_LA18_CC_P
set_property   -dict {PACKAGE_PIN AV13  IOSTANDARD LVCMOS15                           } [get_ports gpio[28]	          ]    ;  ## FMC2_LA18_CC_N
set_property   -dict {PACKAGE_PIN BB11  IOSTANDARD LVCMOS15                           } [get_ports gpio[21]		        ]    ;  ## FMC2_LA12_P
set_property   -dict {PACKAGE_PIN BC11  IOSTANDARD LVCMOS15                           } [get_ports gpio[22]		        ]    ;  ## FMC2_LA12_N
set_property   -dict {PACKAGE_PIN BG15  IOSTANDARD LVCMOS15                           } [get_ports gpio[17]		        ]    ;  ## FMC2_LA07_P
set_property   -dict {PACKAGE_PIN BG14  IOSTANDARD LVCMOS15                           } [get_ports gpio[18]		        ]    ;  ## FMC2_LA07_N
set_property   -dict {PACKAGE_PIN BC12  IOSTANDARD LVCMOS15                           } [get_ports gpio[19]		        ]    ;  ## FMC2_LA11_P
set_property   -dict {PACKAGE_PIN BD12  IOSTANDARD LVCMOS15                           } [get_ports gpio[20]		        ]    ;  ## FMC2_LA11_N
set_property   -dict {PACKAGE_PIN BE12  IOSTANDARD LVCMOS15                           } [get_ports gpio[25]		        ]    ;  ## FMC2_LA15_P
set_property   -dict {PACKAGE_PIN BF13  IOSTANDARD LVCMOS15                           } [get_ports gpio[26]		        ]    ;  ## FMC2_LA15_N
set_property   -dict {PACKAGE_PIN AR14  IOSTANDARD LVCMOS15                           } [get_ports gpio[29]	          ]    ;  ## FMC2_LA19_P
set_property   -dict {PACKAGE_PIN AT13  IOSTANDARD LVCMOS15                           } [get_ports gpio[30]	          ]    ;  ## FMC2_LA19_N
set_property   -dict {PACKAGE_PIN AM17  IOSTANDARD LVCMOS15                           } [get_ports aux_gpio	          ]    ;  ## FMC2_LA32_N

set_property   -dict {PACKAGE_PIN AP15  IOSTANDARD LVCMOS15                           } [get_ports syncinb_a1_p_gpio  ]    ;  ## FMC2_LA20_P
set_property   -dict {PACKAGE_PIN AR15  IOSTANDARD LVCMOS15                           } [get_ports syncinb_a1_n_gpio  ]    ;  ## FMC2_LA20_N
set_property   -dict {PACKAGE_PIN AP11  IOSTANDARD LVCMOS15                           } [get_ports syncinb_b1_p_gpio  ]    ;  ## FMC2_LA22_P
set_property   -dict {PACKAGE_PIN AR12  IOSTANDARD LVCMOS15                           } [get_ports syncinb_b1_n_gpio  ]    ;  ## FMC2_LA22_N
set_property   -dict {PACKAGE_PIN AN14  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_a1_p_gpio ]    ;  ## FMC2_LA21_P
set_property   -dict {PACKAGE_PIN AP13  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_a1_n_gpio ]    ;  ## FMC2_LA21_N
set_property   -dict {PACKAGE_PIN AP12  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_b1_p_gpio ]    ;  ## FMC2_LA23_P
set_property   -dict {PACKAGE_PIN AN13  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_b1_n_gpio ]    ;  ## FMC2_LA23_N

set_property   -dict {PACKAGE_PIN BF11  IOSTANDARD LVDS15                             } [get_ports syncinb_a0_p       ]    ;  ## FMC2_LA04_P
set_property   -dict {PACKAGE_PIN BG11  IOSTANDARD LVDS15                             } [get_ports syncinb_a0_n       ]    ;  ## FMC2_LA04_N
set_property   -dict {PACKAGE_PIN AV15  IOSTANDARD LVDS15                             } [get_ports syncinb_b0_p       ]    ;  ## FMC2_LA08_P
set_property   -dict {PACKAGE_PIN AV14  IOSTANDARD LVDS15                             } [get_ports syncinb_b0_n       ]    ;  ## FMC2_LA08_N
set_property   -dict {PACKAGE_PIN AY14  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_a0_p	    ]    ;  ## FMC2_LA05_P
set_property   -dict {PACKAGE_PIN BA13  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_a0_n	    ]    ;  ## FMC2_LA05_N
set_property   -dict {PACKAGE_PIN BD15  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_b0_p	    ]    ;  ## FMC2_LA09_P
set_property   -dict {PACKAGE_PIN BD14  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_b0_n	    ]    ;  ## FMC2_LA09_N

set_property   -dict {PACKAGE_PIN  D15                                                } [get_ports ref_clk_p[0] 	    ]    ;  ## FMC2_GBTCLK1_M2C_C_P  GTY_205
set_property   -dict {PACKAGE_PIN  D14                                                } [get_ports ref_clk_n[0]       ]    ;  ## FMC2_GBTCLK1_M2C_C_N  GTY_205

set_property   -dict {PACKAGE_PIN AV11  IOSTANDARD LVDS15                             } [get_ports sysref_a_p	        ]    ;  ## FMC2_LA16_P
set_property   -dict {PACKAGE_PIN AW11  IOSTANDARD LVDS15                             } [get_ports sysref_a_n	        ]    ;  ## FMC2_LA16_N
set_property   -dict {PACKAGE_PIN AY13  IOSTANDARD LVDS15                             } [get_ports sysref_b_p         ]    ;  ## FMC2_LA17_CC_P
set_property   -dict {PACKAGE_PIN BA12  IOSTANDARD LVDS15                             } [get_ports sysref_b_n         ]    ;  ## FMC2_LA17_CC_N
set_property   -dict {PACKAGE_PIN BC13  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_p	          ]    ;  ## FMC2_LA00_CC_P
set_property   -dict {PACKAGE_PIN BD13  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_n	          ]    ;  ## FMC2_LA00_CC_N
set_property   -dict {PACKAGE_PIN AT17  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_in_p        ]    ;  ## FMC2_LA33_P
set_property   -dict {PACKAGE_PIN AU16  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_in_n        ]    ;  ## FMC2_LA33_N

set_property   -dict {PACKAGE_PIN AR11 IOSTANDARD LVCMOS15	                          } [get_ports spi2_sclk	        ]    ;  ## FMC2_LA24_P
set_property   -dict {PACKAGE_PIN AT11 IOSTANDARD LVCMOS15	                          } [get_ports spi2_sdio	        ]    ;  ## FMC2_LA24_N
set_property   -dict {PACKAGE_PIN AV19 IOSTANDARD LVCMOS15	                          } [get_ports spi2_sdo	          ]    ;  ## FMC2_LA26_P
set_property   -dict {PACKAGE_PIN AV18 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[0]	        ]    ;  ## FMC2_LA26_N
set_property   -dict {PACKAGE_PIN AM18 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[1]	        ]    ;  ## FMC2_LA29_P
set_property   -dict {PACKAGE_PIN AN17 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[2]	        ]    ;  ## FMC2_LA29_N
set_property   -dict {PACKAGE_PIN AN16 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[3]	        ]    ;  ## FMC2_LA30_P
set_property   -dict {PACKAGE_PIN AP16 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[4]	        ]    ;  ## FMC2_LA30_N
set_property   -dict {PACKAGE_PIN AL16 IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[5]	        ]    ;  ## FMC2_LA32_P

set_property   -dict {PACKAGE_PIN BE11  IOSTANDARD LVCMOS15	                          } [get_ports dut_sdio	          ]    ;  ## FMC2_LA03_P
set_property   -dict {PACKAGE_PIN BF12  IOSTANDARD LVCMOS15	                          } [get_ports dut_sdo	          ]    ;  ## FMC2_LA03_N
set_property   -dict {PACKAGE_PIN BF14  IOSTANDARD LVCMOS15	                          } [get_ports dut_sclk	          ]    ;  ## FMC2_LA02_P
set_property   -dict {PACKAGE_PIN BG13  IOSTANDARD LVCMOS15	                          } [get_ports dut_csb	          ]    ;  ## FMC2_LA02_N

set_property   -dict {PACKAGE_PIN BB14 IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_p[0]	      ]    ;  ## FMC2_CLK0_M2C_P
set_property   -dict {PACKAGE_PIN BB13 IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_n[0]	      ]    ;  ## FMC2_CLK0_M2C_N
set_property   -dict {PACKAGE_PIN AW19 IOSTANDARD LVDS15      DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_p[1]	      ]    ;  ## FMC2_CLK1_M2C_P
set_property   -dict {PACKAGE_PIN AY18 IOSTANDARD LVDS15      DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_n[1]	      ]    ;  ## FMC2_CLK1_M2C_N

set_property   -dict {PACKAGE_PIN AT14  IOSTANDARD LVCMOS15	                          } [get_ports trig_a[0]	        ]    ;  ## FMC2_LA10_P
set_property   -dict {PACKAGE_PIN AU15  IOSTANDARD LVCMOS15	                          } [get_ports trig_a[1]	        ]    ;  ## FMC2_LA10_N
set_property   -dict {PACKAGE_PIN BB15  IOSTANDARD LVCMOS15	                          } [get_ports trig_b[0]	        ]    ;  ## FMC2_LA13_P
set_property   -dict {PACKAGE_PIN BC15  IOSTANDARD LVCMOS15	                          } [get_ports trig_b[1]	        ]    ;  ## FMC2_LA13_N
set_property   -dict {PACKAGE_PIN AW13  IOSTANDARD LVCMOS15	                          } [get_ports trig_in	          ]    ;  ## FMC2_LA01_CC_N
set_property   -dict {PACKAGE_PIN AW12  IOSTANDARD LVCMOS15	                          } [get_ports resetb	            ]    ;  ## FMC2_LA01_CC_P

set_property   -dict {PACKAGE_PIN AW20  IOSTANDARD LVDS15	                            } [get_ports hsci_ckin_p	      ]    ;  ## FMC2_LA27_P   # Bank 707
set_property   -dict {PACKAGE_PIN AY19  IOSTANDARD LVDS15	                            } [get_ports hsci_ckin_n	      ]    ;  ## FMC2_LA27_N   # Bank 707
set_property   -dict {PACKAGE_PIN AY11  IOSTANDARD LVDS15	                            } [get_ports hsci_din_p	        ]    ;  ## FMC2_LA25_P   # Bank 708
set_property   -dict {PACKAGE_PIN BA11  IOSTANDARD LVDS15	                            } [get_ports hsci_din_n	        ]    ;  ## FMC2_LA25_N   # Bank 708
set_property   -dict {PACKAGE_PIN AT16  IOSTANDARD LVDS15	  DIFF_TERM_ADV TERM_100    } [get_ports hsci_cko_p	        ]    ;  ## FMC2_LA31_P   # Bank 707
set_property   -dict {PACKAGE_PIN AR17  IOSTANDARD LVDS15	  DIFF_TERM_ADV TERM_100    } [get_ports hsci_cko_n	        ]    ;  ## FMC2_LA31_N   # Bank 707
set_property   -dict {PACKAGE_PIN AU17  IOSTANDARD LVDS15	  DIFF_TERM_ADV TERM_100    } [get_ports hsci_do_p	        ]    ;  ## FMC2_LA28_P   # Bank 708
set_property   -dict {PACKAGE_PIN AV17  IOSTANDARD LVDS15	  DIFF_TERM_ADV TERM_100    } [get_ports hsci_do_n	        ]    ;  ## FMC2_LA28_N   # Bank 708

set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets i_system_wrapper/system_i/axi_hsci_clkgen/inst/i_mmcm_drp/clk_0]
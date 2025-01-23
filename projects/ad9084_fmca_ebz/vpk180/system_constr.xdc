###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
## Apollo
#

set_property   -dict {PACKAGE_PIN CB62                                                } [get_ports stx_n[0]           ]    ;  ## FMCP1_DP0_M2C_N  GTYP_200
set_property   -dict {PACKAGE_PIN CB61                                                } [get_ports stx_p[0]           ]    ;  ## FMCP1_DP0_M2C_P  GTYP_200
set_property   -dict {PACKAGE_PIN BY62                                                } [get_ports stx_n[1]           ]    ;  ## FMCP1_DP1_M2C_N  GTYP_200
set_property   -dict {PACKAGE_PIN BY61                                                } [get_ports stx_p[1]           ]    ;  ## FMCP1_DP1_M2C_P  GTYP_200
set_property   -dict {PACKAGE_PIN BW64                                                } [get_ports stx_n[2]           ]    ;  ## FMCP1_DP2_M2C_N  GTYP_200
set_property   -dict {PACKAGE_PIN BW63                                                } [get_ports stx_p[2]           ]    ;  ## FMCP1_DP2_M2C_P  GTYP_200
set_property   -dict {PACKAGE_PIN BV62                                                } [get_ports stx_n[3]           ]    ;  ## FMCP1_DP3_M2C_N  GTYP_200
set_property   -dict {PACKAGE_PIN BV61                                                } [get_ports stx_p[3]           ]    ;  ## FMCP1_DP3_M2C_P  GTYP_200
set_property   -dict {PACKAGE_PIN BU64                                                } [get_ports stx_n[4]           ]    ;  ## FMCP1_DP4_M2C_N  GTYP_201
set_property   -dict {PACKAGE_PIN BU63                                                } [get_ports stx_p[4]           ]    ;  ## FMCP1_DP4_M2C_P  GTYP_201
set_property   -dict {PACKAGE_PIN BT62                                                } [get_ports stx_n[5]           ]    ;  ## FMCP1_DP5_M2C_N  GTYP_201
set_property   -dict {PACKAGE_PIN BT61                                                } [get_ports stx_p[5]           ]    ;  ## FMCP1_DP5_M2C_P  GTYP_201
set_property   -dict {PACKAGE_PIN BR64                                                } [get_ports stx_n[6]           ]    ;  ## FMCP1_DP6_M2C_N  GTYP_201
set_property   -dict {PACKAGE_PIN BR63                                                } [get_ports stx_p[6]           ]    ;  ## FMCP1_DP6_M2C_P  GTYP_201
set_property   -dict {PACKAGE_PIN BR60                                                } [get_ports stx_n[7]           ]    ;  ## FMCP1_DP7_M2C_N  GTYP_201
set_property   -dict {PACKAGE_PIN BR59                                                } [get_ports stx_p[7]           ]    ;  ## FMCP1_DP7_M2C_P  GTYP_201

set_property   -dict {PACKAGE_PIN CD55                                                } [get_ports srx_n[0]           ]    ;  ## FMCP1_DP0_C2M_N  GTYP_200
set_property   -dict {PACKAGE_PIN CD54                                                } [get_ports srx_p[0]           ]    ;  ## FMCP1_DP0_C2M_P  GTYP_200
set_property   -dict {PACKAGE_PIN CD59                                                } [get_ports srx_n[1]           ]    ;  ## FMCP1_DP1_C2M_N  GTYP_200
set_property   -dict {PACKAGE_PIN CD58                                                } [get_ports srx_p[1]           ]    ;  ## FMCP1_DP1_C2M_P  GTYP_200
set_property   -dict {PACKAGE_PIN CC57                                                } [get_ports srx_n[2]           ]    ;  ## FMCP1_DP2_C2M_N  GTYP_200
set_property   -dict {PACKAGE_PIN CC56                                                } [get_ports srx_p[2]           ]    ;  ## FMCP1_DP2_C2M_P  GTYP_200
set_property   -dict {PACKAGE_PIN CB59                                                } [get_ports srx_n[3]           ]    ;  ## FMCP1_DP3_C2M_N  GTYP_200
set_property   -dict {PACKAGE_PIN CB58                                                } [get_ports srx_p[3]           ]    ;  ## FMCP1_DP3_C2M_P  GTYP_200
set_property   -dict {PACKAGE_PIN CB55                                                } [get_ports srx_n[4]           ]    ;  ## FMCP1_DP4_C2M_N  GTYP_201
set_property   -dict {PACKAGE_PIN CB54                                                } [get_ports srx_p[4]           ]    ;  ## FMCP1_DP4_C2M_P  GTYP_201
set_property   -dict {PACKAGE_PIN CA57                                                } [get_ports srx_n[5]           ]    ;  ## FMCP1_DP5_C2M_N  GTYP_201
set_property   -dict {PACKAGE_PIN CA56                                                } [get_ports srx_p[5]           ]    ;  ## FMCP1_DP5_C2M_P  GTYP_201
set_property   -dict {PACKAGE_PIN BY59                                                } [get_ports srx_n[6]           ]    ;  ## FMCP1_DP6_C2M_N  GTYP_201
set_property   -dict {PACKAGE_PIN BY58                                                } [get_ports srx_p[6]           ]    ;  ## FMCP1_DP6_C2M_P  GTYP_201
set_property   -dict {PACKAGE_PIN BY55                                                } [get_ports srx_n[7]           ]    ;  ## FMCP1_DP7_C2M_N  GTYP_201
set_property   -dict {PACKAGE_PIN BY54                                                } [get_ports srx_p[7]           ]    ;  ## FMCP1_DP7_C2M_P  GTYP_201

set_property   -dict {PACKAGE_PIN CA44  IOSTANDARD LVCMOS15                           } [get_ports gpio[15]		        ]    ;  ## FMCP1_LA06_P
set_property   -dict {PACKAGE_PIN CB45  IOSTANDARD LVCMOS15                           } [get_ports gpio[16]		        ]    ;  ## FMCP1_LA06_N
set_property   -dict {PACKAGE_PIN BY51  IOSTANDARD LVCMOS15                           } [get_ports gpio[23]		        ]    ;  ## FMCP1_LA14_P
set_property   -dict {PACKAGE_PIN CA52  IOSTANDARD LVCMOS15                           } [get_ports gpio[24]		        ]    ;  ## FMCP1_LA14_N
set_property   -dict {PACKAGE_PIN BW39  IOSTANDARD LVCMOS15                           } [get_ports gpio[27]	          ]    ;  ## FMCP1_LA18_CC_P
set_property   -dict {PACKAGE_PIN BY39  IOSTANDARD LVCMOS15                           } [get_ports gpio[28]	          ]    ;  ## FMCP1_LA18_CC_N
set_property   -dict {PACKAGE_PIN BW49  IOSTANDARD LVCMOS15                           } [get_ports gpio[21]		        ]    ;  ## FMCP1_LA12_P
set_property   -dict {PACKAGE_PIN BW50  IOSTANDARD LVCMOS15                           } [get_ports gpio[22]		        ]    ;  ## FMCP1_LA12_N
set_property   -dict {PACKAGE_PIN CB49  IOSTANDARD LVCMOS15                           } [get_ports gpio[17]		        ]    ;  ## FMCP1_LA07_P
set_property   -dict {PACKAGE_PIN CC50  IOSTANDARD LVCMOS15                           } [get_ports gpio[18]		        ]    ;  ## FMCP1_LA07_N
set_property   -dict {PACKAGE_PIN CB51  IOSTANDARD LVCMOS15                           } [get_ports gpio[19]		        ]    ;  ## FMCP1_LA11_P
set_property   -dict {PACKAGE_PIN CC52  IOSTANDARD LVCMOS15                           } [get_ports gpio[20]		        ]    ;  ## FMCP1_LA11_N
set_property   -dict {PACKAGE_PIN CD51  IOSTANDARD LVCMOS15                           } [get_ports gpio[25]		        ]    ;  ## FMCP1_LA15_P
set_property   -dict {PACKAGE_PIN CD52  IOSTANDARD LVCMOS15                           } [get_ports gpio[26]		        ]    ;  ## FMCP1_LA15_N
set_property   -dict {PACKAGE_PIN BN40  IOSTANDARD LVCMOS15                           } [get_ports gpio[29]	          ]    ;  ## FMCP1_LA19_P
set_property   -dict {PACKAGE_PIN BP40  IOSTANDARD LVCMOS15                           } [get_ports gpio[30]	          ]    ;  ## FMCP1_LA19_N
set_property   -dict {PACKAGE_PIN CA41  IOSTANDARD LVCMOS15                           } [get_ports aux_gpio	          ]    ;  ## FMCP1_LA32_N

set_property   -dict {PACKAGE_PIN BR42  IOSTANDARD LVCMOS15                           } [get_ports syncinb_a1_p_gpio  ]    ;  ## FMCP1_LA20_P
set_property   -dict {PACKAGE_PIN BT41  IOSTANDARD LVCMOS15                           } [get_ports syncinb_a1_n_gpio  ]    ;  ## FMCP1_LA20_N
set_property   -dict {PACKAGE_PIN CD42  IOSTANDARD LVCMOS15                           } [get_ports syncinb_b1_p_gpio  ]    ;  ## FMCP1_LA22_P
set_property   -dict {PACKAGE_PIN CD43  IOSTANDARD LVCMOS15                           } [get_ports syncinb_b1_n_gpio  ]    ;  ## FMCP1_LA22_N
set_property   -dict {PACKAGE_PIN CD40  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_a1_p_gpio ]    ;  ## FMCP1_LA21_P
set_property   -dict {PACKAGE_PIN CD41  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_a1_n_gpio ]    ;  ## FMCP1_LA21_N
set_property   -dict {PACKAGE_PIN CB40  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_b1_p_gpio ]    ;  ## FMCP1_LA23_P
set_property   -dict {PACKAGE_PIN CC40  IOSTANDARD LVCMOS15                           } [get_ports syncoutb_b1_n_gpio ]    ;  ## FMCP1_LA23_N

set_property   -dict {PACKAGE_PIN CA49  IOSTANDARD LVDS15                             } [get_ports syncinb_a0_p       ]    ;  ## FMCP1_LA04_P
set_property   -dict {PACKAGE_PIN CB50  IOSTANDARD LVDS15                             } [get_ports syncinb_a0_n       ]    ;  ## FMCP1_LA04_N
set_property   -dict {PACKAGE_PIN BY49  IOSTANDARD LVDS15                             } [get_ports syncinb_b0_p       ]    ;  ## FMCP1_LA08_P
set_property   -dict {PACKAGE_PIN BY50  IOSTANDARD LVDS15                             } [get_ports syncinb_b0_n       ]    ;  ## FMCP1_LA08_N
set_property   -dict {PACKAGE_PIN CC43  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_a0_p	    ]    ;  ## FMCP1_LA05_P
set_property   -dict {PACKAGE_PIN CB44  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_a0_n	    ]    ;  ## FMCP1_LA05_N
set_property   -dict {PACKAGE_PIN CC45  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_b0_p	    ]    ;  ## FMCP1_LA09_P
set_property   -dict {PACKAGE_PIN CD46  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports syncoutb_b0_n	    ]    ;  ## FMCP1_LA09_N

set_property   -dict {PACKAGE_PIN AT48                                                } [get_ports ref_clk_p    	    ]    ;  ## FMCP1_GBTCLK0_M2C_C_P  GTYP_REFCLKP0_200
set_property   -dict {PACKAGE_PIN AT49                                                } [get_ports ref_clk_n          ]    ;  ## FMCP1_GBTCLK0_M2C_C_N  GTYP_REFCLKN0_200

set_property   -dict {PACKAGE_PIN CA51  IOSTANDARD LVDS15                             } [get_ports sysref_a_p	        ]    ;  ## FMCP1_LA16_P
set_property   -dict {PACKAGE_PIN CB52  IOSTANDARD LVDS15                             } [get_ports sysref_a_n	        ]    ;  ## FMCP1_LA16_N
set_property   -dict {PACKAGE_PIN BU41  IOSTANDARD LVDS15                             } [get_ports sysref_b_p         ]    ;  ## FMCP1_LA17_CC_P
set_property   -dict {PACKAGE_PIN BU42  IOSTANDARD LVDS15                             } [get_ports sysref_b_n         ]    ;  ## FMCP1_LA17_CC_N
set_property   -dict {PACKAGE_PIN BV49  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_p	          ]    ;  ## FMCP1_LA00_CC_P
set_property   -dict {PACKAGE_PIN BV50  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_n	          ]    ;  ## FMCP1_LA00_CC_N
set_property   -dict {PACKAGE_PIN BV41  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_in_p        ]    ;  ## FMCP1_LA33_P
set_property   -dict {PACKAGE_PIN BW41  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports sysref_in_n        ]    ;  ## FMCP1_LA33_N

set_property   -dict {PACKAGE_PIN BY40  IOSTANDARD LVCMOS15	                          } [get_ports spi2_sclk	        ]    ;  ## FMCP1_LA24_P
set_property   -dict {PACKAGE_PIN CA39  IOSTANDARD LVCMOS15	                          } [get_ports spi2_sdio	        ]    ;  ## FMCP1_LA24_N
set_property   -dict {PACKAGE_PIN CB41  IOSTANDARD LVCMOS15	                          } [get_ports spi2_sdo	          ]    ;  ## FMCP1_LA26_P
set_property   -dict {PACKAGE_PIN CC42  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[0]	        ]    ;  ## FMCP1_LA26_N
set_property   -dict {PACKAGE_PIN BY38  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[1]	        ]    ;  ## FMCP1_LA29_P
set_property   -dict {PACKAGE_PIN CA37  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[2]	        ]    ;  ## FMCP1_LA29_N
set_property   -dict {PACKAGE_PIN BR39  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[3]	        ]    ;  ## FMCP1_LA30_P
set_property   -dict {PACKAGE_PIN BT39  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[4]	        ]    ;  ## FMCP1_LA30_N
set_property   -dict {PACKAGE_PIN BY41  IOSTANDARD LVCMOS15	                          } [get_ports spi2_cs[5]	        ]    ;  ## FMCP1_LA32_P

set_property   -dict {PACKAGE_PIN CD47  IOSTANDARD LVCMOS15	                          } [get_ports dut_sdio	          ]    ;  ## FMCP1_LA03_P
set_property   -dict {PACKAGE_PIN CD48  IOSTANDARD LVCMOS15	                          } [get_ports dut_sdo	          ]    ;  ## FMCP1_LA03_N
set_property   -dict {PACKAGE_PIN CB46  IOSTANDARD LVCMOS15	                          } [get_ports dut_sclk	          ]    ;  ## FMCP1_LA02_P
set_property   -dict {PACKAGE_PIN CC47  IOSTANDARD LVCMOS15	                          } [get_ports dut_csb	          ]    ;  ## FMCP1_LA02_N

set_property   -dict {PACKAGE_PIN BY43  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_p[0]	      ]    ;  ## FMCP1_CLK0_M2C_P
set_property   -dict {PACKAGE_PIN BY44  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_n[0]	      ]    ;  ## FMCP1_CLK0_M2C_N
set_property   -dict {PACKAGE_PIN BN39  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_p[1]	      ]    ;  ## FMCP1_CLK1_M2C_P
set_property   -dict {PACKAGE_PIN BP38  IOSTANDARD LVDS15     DIFF_TERM_ADV TERM_100  } [get_ports clk_m2c_n[1]	      ]    ;  ## FMCP1_CLK1_M2C_N

set_property   -dict {PACKAGE_PIN CC44  IOSTANDARD LVCMOS15	                          } [get_ports trig_a[0]	        ]    ;  ## FMCP1_LA10_P
set_property   -dict {PACKAGE_PIN CD45  IOSTANDARD LVCMOS15	                          } [get_ports trig_a[1]	        ]    ;  ## FMCP1_LA10_N
set_property   -dict {PACKAGE_PIN CC49  IOSTANDARD LVCMOS15	                          } [get_ports trig_b[0]	        ]    ;  ## FMCP1_LA13_P
set_property   -dict {PACKAGE_PIN CD50  IOSTANDARD LVCMOS15	                          } [get_ports trig_b[1]	        ]    ;  ## FMCP1_LA13_N
set_property   -dict {PACKAGE_PIN BW52  IOSTANDARD LVCMOS15	                          } [get_ports trig_in	          ]    ;  ## FMCP1_LA01_CC_N
set_property   -dict {PACKAGE_PIN BW51  IOSTANDARD LVCMOS15	                          } [get_ports resetb	            ]    ;  ## FMCP1_LA01_CC_P

set_property   -dict {PACKAGE_PIN CA38  IOSTANDARD LVDS15	                            } [get_ports hsci_ckin_p	      ]    ;  ## FMCP1_LA27_P  BANK 709
set_property   -dict {PACKAGE_PIN CB39  IOSTANDARD LVDS15	                            } [get_ports hsci_ckin_n	      ]    ;  ## FMCP1_LA27_N  BANK 709
set_property   -dict {PACKAGE_PIN CC38  IOSTANDARD LVDS15	                            } [get_ports hsci_din_p	        ]    ;  ## FMCP1_LA25_P  BANK 709
set_property   -dict {PACKAGE_PIN CC39  IOSTANDARD LVDS15	                            } [get_ports hsci_din_n	        ]    ;  ## FMCP1_LA25_N  BANK 709
set_property   -dict {PACKAGE_PIN BR41  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports hsci_cko_p	        ]    ;  ## FMCP1_LA31_P  BANK 709
set_property   -dict {PACKAGE_PIN BT40  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports hsci_cko_n	        ]    ;  ## FMCP1_LA31_N  BANK 709
set_property   -dict {PACKAGE_PIN BR37  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports hsci_do_p	        ]    ;  ## FMCP1_LA28_P  BANK 709
set_property   -dict {PACKAGE_PIN BR38  IOSTANDARD LVDS15	    DIFF_TERM_ADV TERM_100  } [get_ports hsci_do_n	        ]    ;  ## FMCP1_LA28_N  BANK 709

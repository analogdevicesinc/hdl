
# lldk

set_property  -dict {PACKAGE_PIN L21 IOSTANDARD LVDS_25               } [get_ports rx_cnv_p[1]]                    ; ## C10 LA_06_P
set_property  -dict {PACKAGE_PIN L22 IOSTANDARD LVDS_25               } [get_ports rx_cnv_n[1]]                    ; ## C11 LA_06_N
set_property  -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25              } [get_ports tx_cs[0]]                     ; ## C14 LA_10_P
set_property  -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25              } [get_ports tx_sclk[0]]                   ; ## C15 LA_10_N
#set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVDS_25               } [get_ports fmc_la14_p]                    ; ## C18 LA_14_P
#set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVDS_25               } [get_ports fmc_la14_n]                    ; ## C19 LA_14_N
set_property  -dict {PACKAGE_PIN D20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_p[3]]                    ; ## C22 LA_18_P_CC
set_property  -dict {PACKAGE_PIN C20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_n[3]]                    ; ## C23 LA_18_N_CC
set_property  -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25              } [get_ports tx_cs[1]]                     ; ## C26 LA_27_P
set_property  -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS25              } [get_ports tx_sclk[1]]                   ; ## C27 LA_27_N
set_property  -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_p[1]]                    ; ## D08 LA_01_P_CC
set_property  -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_n[1]]                    ; ## D09 LA_01_N_CC
set_property  -dict {PACKAGE_PIN J18 IOSTANDARD LVDS_25               } [get_ports rx_clk_p[1]]                    ; ## D11 LA_05_P
set_property  -dict {PACKAGE_PIN K18 IOSTANDARD LVDS_25               } [get_ports rx_clk_n[1]]                    ; ## D12 LA_05_N
set_property  -dict {PACKAGE_PIN R20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_p[1]]                     ; ## D14 LA_09_P
set_property  -dict {PACKAGE_PIN R21 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_n[1]]                     ; ## D15 LA_09_N
set_property  -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25              } [get_ports spi_miso]                    ; ## D17 LA_13_P
set_property  -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25              } [get_ports spi_mosi]                    ; ## D18 LA_13_N
set_property  -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_p[2]]                    ; ## D20 LA_17_P_CC
set_property  -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_n[2]]                    ; ## D21 LA_17_N_CC
set_property  -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25               } [get_ports rx_clk_p[3]]                    ; ## D23 LA_23_P
set_property  -dict {PACKAGE_PIN D15 IOSTANDARD LVDS_25               } [get_ports rx_clk_n[3]]                    ; ## D24 LA_23_N
set_property  -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_p[3]]                     ; ## D26 LA_26_P
set_property  -dict {PACKAGE_PIN E18 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_n[3]]                     ; ## D27 LA_26_N
set_property  -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_p[0]]                    ; ## G06 LA_00_P_CC
set_property  -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_dco_n[0]]                    ; ## G07 LA_00_N_CC
set_property  -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_p[0]]                     ; ## G09 LA_03_P
set_property  -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_n[0]]                     ; ## G10 LA_03_N
set_property  -dict {PACKAGE_PIN J21 IOSTANDARD LVDS_25               } [get_ports rx_cnv_p[0]]                    ; ## G12 LA_08_P
set_property  -dict {PACKAGE_PIN J22 IOSTANDARD LVDS_25               } [get_ports rx_cnv_n[0]]                    ; ## G13 LA_08_N
set_property  -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25              } [get_ports tx_sdio2[0]]                  ; ## G15 LA_12_P
set_property  -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25              } [get_ports tx_sdio3[0]]                  ; ## G16 LA_12_N
#set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25              } [get_ports alert_1]                       ; ## G18 LA_16_P
#set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS25              } [get_ports ladc_1]                        ; ## G19 LA_16_N
set_property  -dict {PACKAGE_PIN G20 IOSTANDARD LVDS_25               } [get_ports rx_cnv_p[2]]                    ; ## G21 LA_20_P
set_property  -dict {PACKAGE_PIN G21 IOSTANDARD LVDS_25               } [get_ports rx_cnv_n[2]]                    ; ## G22 LA_20_N
set_property  -dict {PACKAGE_PIN G19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_p[2]]                     ; ## G24 LA_22_P
set_property  -dict {PACKAGE_PIN F19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_db_n[2]]                     ; ## G25 LA_22_N
set_property  -dict {PACKAGE_PIN D22 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_p[3]]                     ; ## G27 LA_25_P
set_property  -dict {PACKAGE_PIN C22 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_n[3]]                     ; ## G28 LA_25_N
set_property  -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25              } [get_ports tx_sdio2[1]]                  ; ## G30 LA_29_P
set_property  -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25              } [get_ports tx_sdio3[1]]                  ; ## G31 LA_29_N
#set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports fmc_la31_p]                    ; ## G33 LA_31_P
#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS_25               } [get_ports fmc_la31_n]                    ; ## G34 LA_31_N
#set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS25              } [get_ports alert_2]                      ; ## G36 LA_33_P
#set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25              } [get_ports ldac_2]                        ; ## G37 LA_33_N
set_property  -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_p[0]]                     ; ## H07 LA_02_P
set_property  -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_n[0]]                     ; ## H08 LA_02_N
set_property  -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25               } [get_ports rx_clk_p[0]]                    ; ## H10 LA_04_P
set_property  -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25               } [get_ports rx_clk_n[0]]                    ; ## H11 LA_04_N
set_property  -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_p[1]]                     ; ## H13 LA_07_P
set_property  -dict {PACKAGE_PIN T17 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_n[1]]                     ; ## H14 LA_07_N
set_property  -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25              } [get_ports tx_sdio0[0]]                  ; ## H16 LA_11_P
set_property  -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25              } [get_ports tx_sdio1[0]]                  ; ## H17 LA_11_N
set_property  -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS25              } [get_ports spi_sck]                     ; ## H19 LA_15_P
set_property  -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS25              } [get_ports spi_csb]                    ; ## H20 LA_15_N
set_property  -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25               } [get_ports rx_clk_p[2]]                    ; ## H22 LA_19_P
set_property  -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25               } [get_ports rx_clk_n[2]]                    ; ## H23 LA_19_N
set_property  -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_p[2]]                     ; ## H25 LA_21_P
set_property  -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25   DIFF_TERM 1 } [get_ports rx_da_n[2]]                     ; ## H26 LA_21_N
set_property  -dict {PACKAGE_PIN A18 IOSTANDARD LVDS_25               } [get_ports rx_cnv_p[3]]                    ; ## H28 LA_24_P
set_property  -dict {PACKAGE_PIN A19 IOSTANDARD LVDS_25               } [get_ports rx_cnv_n[3]]                    ; ## H29 LA_24_N
set_property  -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25              } [get_ports tx_sdio0[1]]                  ; ## H31 LA_28_P
set_property  -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS25              } [get_ports tx_sdio1[1]]                  ; ## H32 LA_28_N
#set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVDS_25               } [get_ports fmc_la30_p]                    ; ## H34 LA_30_P
#set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVDS_25               } [get_ports fmc_la30_n]                    ; ## H35 LA_30_N
#set_property -dict {PACKAGE_PIN A21  IOSTANDARD LVDS_25              } [get_ports fmc_la32_p]                    ; ## H37 LA_32_P
#set_property -dict {PACKAGE_PIN A22  IOSTANDARD LVDS_25              } [get_ports fmc_la32_n]                    ; ## H38 LA_32_N




# clocks

#create_generated_clock -name dco0 [get_ports rx_clk_p[0]]
#create_generated_clock -name dco1 [get_ports rx_clk_p[1]]
#create_generated_clock -name dco2 [get_ports rx_clk_p[2]]
#create_generated_clock -name dco3 [get_ports rx_clk_p[3]]

#create_clock -period 8.333 -name dco0 [get_ports rx_dco_p[0]]
#create_clock -period 8.333 -name dco1 [get_ports rx_dco_p[1]]
#create_clock -period 8.333 -name dco2 [get_ports rx_dco_p[2]]
#create_clock -period 8.333 -name dco3 [get_ports rx_dco_p[3]]

create_generated_clock -name dco0 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[0]] -objects [get_ports rx_clk_p[0]]
create_generated_clock -name dco1 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[1]] -objects [get_ports rx_clk_p[1]]
create_generated_clock -name dco2 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[2]] -objects [get_ports rx_clk_p[2]]
create_generated_clock -name dco3 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_dco_p[3]] -objects [get_ports rx_clk_p[3]]




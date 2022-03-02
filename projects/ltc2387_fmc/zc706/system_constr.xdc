
# ltc2387

set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVDS_25             } [get_ports rx_1_cnv_p]                    ; ## C10 LA_06_P
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVDS_25             } [get_ports rx_1_cnv_n]                    ; ## C11 LA_06_N
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_cs]                     ; ## C14 LA_10_P
set_property -dict {PACKAGE_PIN AC13 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_sclk]                   ; ## C15 LA_10_N
#set_property -dict {PACKAGE_PIN AF18 IOSTANDARD LVDS_25             } [get_ports fmc_la14_p]                    ; ## C18 LA_14_P
#set_property -dict {PACKAGE_PIN AF17 IOSTANDARD LVDS_25             } [get_ports fmc_la14_n]                    ; ## C19 LA_14_N
set_property -dict {PACKAGE_PIN AE27 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_dco_p]                    ; ## C22 LA_18_P_CC
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_dco_n]                    ; ## C23 LA_18_N_CC
set_property -dict {PACKAGE_PIN AJ28 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_cs]                     ; ## C26 LA_27_P
set_property -dict {PACKAGE_PIN AJ29 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_sclk]                   ; ## C27 LA_27_N
set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_dco_p]                    ; ## D08 LA_01_P_CC
set_property -dict {PACKAGE_PIN AG15 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_dco_n]                    ; ## D09 LA_01_N_CC
set_property -dict {PACKAGE_PIN AE16 IOSTANDARD LVDS_25             } [get_ports rx_1_clk_p]                    ; ## D11 LA_05_P
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVDS_25             } [get_ports rx_1_clk_n]                    ; ## D12 LA_05_N
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_db_p]                     ; ## D14 LA_09_P
set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_db_n]                     ; ## D15 LA_09_N
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS25            } [get_ports spi_0_miso]                    ; ## D17 LA_13_P
set_property -dict {PACKAGE_PIN AH16 IOSTANDARD LVCMOS25            } [get_ports spi_0_mosi]                    ; ## D18 LA_13_N
set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_dco_p]                    ; ## D20 LA_17_P_CC
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_dco_n]                    ; ## D21 LA_17_N_CC
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVDS_25             } [get_ports rx_3_clk_p]                    ; ## D23 LA_23_P
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVDS_25             } [get_ports rx_3_clk_n]                    ; ## D24 LA_23_N
set_property -dict {PACKAGE_PIN AJ30 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_db_p]                     ; ## D26 LA_26_P
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_db_n]                     ; ## D27 LA_26_N
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_dco_p]                    ; ## G06 LA_00_P_CC
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_dco_n]                    ; ## G07 LA_00_N_CC
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_db_p]                     ; ## G09 LA_03_P
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_db_n]                     ; ## G10 LA_03_N
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVDS_25             } [get_ports rx_0_cnv_p]                    ; ## G12 LA_08_P
set_property -dict {PACKAGE_PIN AD13 IOSTANDARD LVDS_25             } [get_ports rx_0_cnv_n]                    ; ## G13 LA_08_N
set_property -dict {PACKAGE_PIN AD16 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_sdio2]                  ; ## G15 LA_12_P
set_property -dict {PACKAGE_PIN AD15 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_sdio3]                  ; ## G16 LA_12_N
#set_property -dict {PACKAGE_PIN AE18 IOSTANDARD LVCMOS25            } [get_ports alert_1]                       ; ## G18 LA_16_P
#set_property -dict {PACKAGE_PIN AE17 IOSTANDARD LVCMOS25            } [get_ports ladc_1]                        ; ## G19 LA_16_N
set_property -dict {PACKAGE_PIN AG26 IOSTANDARD LVDS_25             } [get_ports rx_2_cnv_p]                    ; ## G21 LA_20_P
set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVDS_25             } [get_ports rx_2_cnv_n]                    ; ## G22 LA_20_N
set_property -dict {PACKAGE_PIN AK27 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_db_p]                     ; ## G24 LA_22_P
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_db_n]                     ; ## G25 LA_22_N
set_property -dict {PACKAGE_PIN AF29 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_da_p]                     ; ## G27 LA_25_P
set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_3_da_n]                     ; ## G28 LA_25_N
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_sdio2]                  ; ## G30 LA_29_P
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_sdio3]                  ; ## G31 LA_29_N
#set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports fmc_la31_p]                    ; ## G33 LA_31_P
#set_property -dict {PACKAGE_PIN AD29 IOSTANDARD LVDS_25             } [get_ports fmc_la31_n]                    ; ## G34 LA_31_N
#set_property -dict {PACKAGE_PIN Y30 IOSTANDARD LVCMOS25             }  [get_ports alert_2]                      ; ## G36 LA_33_P
#set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS25            } [get_ports ldac_2]                        ; ## G37 LA_33_N
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_da_p]                     ; ## H07 LA_02_P
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_0_da_n]                     ; ## H08 LA_02_N
set_property -dict {PACKAGE_PIN AJ15 IOSTANDARD LVDS_25             } [get_ports rx_0_clk_p]                    ; ## H10 LA_04_P
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVDS_25             } [get_ports rx_0_clk_n]                    ; ## H11 LA_04_N
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_da_p]                     ; ## H13 LA_07_P
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_1_da_n]                     ; ## H14 LA_07_N
set_property -dict {PACKAGE_PIN AJ16 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_sdio0]                  ; ## H16 LA_11_P
set_property -dict {PACKAGE_PIN AK16 IOSTANDARD LVCMOS25            } [get_ports tx_0_1_sdio1]                  ; ## H17 LA_11_N
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS25            } [get_ports spi_0_sck]                     ; ## H19 LA_15_P
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS25            } [get_ports spi_0_csb0]                    ; ## H20 LA_15_N
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVDS_25             } [get_ports rx_2_clk_p]                    ; ## H22 LA_19_P
set_property -dict {PACKAGE_PIN AH27 IOSTANDARD LVDS_25             } [get_ports rx_2_clk_n]                    ; ## H23 LA_19_N
set_property -dict {PACKAGE_PIN AH28 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_da_p]                     ; ## H25 LA_21_P
set_property -dict {PACKAGE_PIN AH29 IOSTANDARD LVDS_25 DIFF_TERM 1 } [get_ports rx_2_da_n]                     ; ## H26 LA_21_N
set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVDS_25             } [get_ports rx_3_cnv_p]                    ; ## H28 LA_24_P
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVDS_25             } [get_ports rx_3_cnv_n]                    ; ## H29 LA_24_N
set_property -dict {PACKAGE_PIN AD25 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_sdio0]                  ; ## H31 LA_28_P
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS25            } [get_ports tx_2_3_sdio1]                  ; ## H32 LA_28_N
#set_property -dict {PACKAGE_PIN AB29 IOSTANDARD LVDS_25             } [get_ports fmc_la30_p]                    ; ## H34 LA_30_P
#set_property -dict {PACKAGE_PIN AB30 IOSTANDARD LVDS_25             } [get_ports fmc_la30_n]                    ; ## H35 LA_30_N
#set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVDS_25              } [get_ports fmc_la32_p]                    ; ## H37 LA_32_P
#set_property -dict {PACKAGE_PIN Y27 IOSTANDARD LVDS_25              } [get_ports fmc_la32_n]                    ; ## H38 LA_32_N




# clocks

#create_generated_clock -name dco0 [get_ports rx_0_clk_p]
#create_generated_clock -name dco1 [get_ports rx_1_clk_p]
#create_generated_clock -name dco2 [get_ports rx_2_clk_p]
#create_generated_clock -name dco3 [get_ports rx_3_clk_p]

#create_clock -period 8.333 -name dco0 [get_ports rx_0_dco_p]
#create_clock -period 8.333 -name dco1 [get_ports rx_1_dco_p]
#create_clock -period 8.333 -name dco2 [get_ports rx_2_dco_p]
#create_clock -period 8.333 -name dco3 [get_ports rx_3_dco_p]

create_generated_clock -name dco0 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_0_dco_p] -objects [get_ports rx_0_clk_p]
create_generated_clock -name dco1 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_1_dco_p] -objects [get_ports rx_1_clk_p]
create_generated_clock -name dco2 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_2_dco_p] -objects [get_ports rx_2_clk_p]
create_generated_clock -name dco3 -divide_by 1 -add -master_clock mmcm_clk_0_s -source [get_ports rx_3_dco_p] -objects [get_ports rx_3_clk_p]




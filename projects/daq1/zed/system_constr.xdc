
# daq1

set_property  -dict {PACKAGE_PIN  D18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports dac_clk_in_p]            ; ##  G02  FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  C19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports dac_clk_in_n]            ; ##  G03  FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN  D22  IOSTANDARD LVDS_25 } [get_ports dac_clk_out_p]                          ; ##  G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  C22  IOSTANDARD LVDS_25 } [get_ports dac_clk_out_n]                          ; ##  G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  A21   IOSTANDARD LVDS_25 } [get_ports dac_frame_out_p]                       ; ##  H37  FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN  A22   IOSTANDARD LVDS_25 } [get_ports dac_frame_out_n]                       ; ##  H38  FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[0]]                      ; ##  H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  J17  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[0]]                      ; ##  H20  FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[1]]                      ; ##  G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  G21  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[1]]                      ; ##  G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[2]]                      ; ##  H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[2]]                      ; ##  H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  B19  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[3]]                      ; ##  D20  FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[3]]                      ; ##  D21  FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  E15  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[4]]                      ; ##  D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  D15  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[4]]                      ; ##  D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  G19  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[5]]                      ; ##  G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  F19  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[5]]                      ; ##  G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[6]]                      ; ##  C22  FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  C20  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[6]]                      ; ##  C23  FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  E19  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[7]]                      ; ##  H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  E20  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[7]]                      ; ##  H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  F18  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[8]]                      ; ##  D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  E18  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[8]]                      ; ##  D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  A18  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[9]]                      ; ##  A18  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  A19  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[9]]                      ; ##  H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  E21  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[10]]                     ; ##  C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  D21  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[10]]                     ; ##  C27  FMC_LPC_LA27_N
set_property  -dict {PACKAGE_PIN  C17  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[11]]                     ; ##  G30  FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN  C18  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[11]]                     ; ##  G31  FMC_LPC_LA29_N
set_property  -dict {PACKAGE_PIN  A16  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[12]]                     ; ##  H31  FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN  A17  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[12]]                     ; ##  H32  FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN  B16  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[13]]                     ; ##  G33  FMC_LPC_LA31_P
set_property  -dict {PACKAGE_PIN  B17  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[13]]                     ; ##  G34  FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN  C15  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[14]]                     ; ##  H34  FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN  B15  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[14]]                     ; ##  H35  FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN  B21  IOSTANDARD LVDS_25 } [get_ports dac_data_out_p[15]]                     ; ##  G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  B22  IOSTANDARD LVDS_25 } [get_ports dac_data_out_n[15]]                     ; ##  G37  FMC_LPC_LA33_N

set_property  -dict {PACKAGE_PIN  M19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_clk_in_p]            ; ##  G06  FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  M20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_clk_in_n]            ; ##  G07  FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  R19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]        ; ##  C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  T19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]        ; ##  C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  K19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]        ; ##  C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  K20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]        ; ##  C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  L17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]        ; ##  D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  M17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]        ; ##  D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  N17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]        ; ##  H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  N18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]        ; ##  H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  P20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]        ; ##  G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  P21  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]        ; ##  G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  R20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]        ; ##  D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  R21  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]        ; ##  D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  T16  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]        ; ##  H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  T17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]        ; ##  H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  J21  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]        ; ##  G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  J22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]        ; ##  G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  J18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[8]]        ; ##  D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  K18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[8]]        ; ##  D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  M21  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[9]]        ; ##  H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  M22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[9]]        ; ##  H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  N22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[10]]       ; ##  G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  P22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[10]]       ; ##  G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  L21  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[11]]       ; ##  C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  L22  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[11]]       ; ##  C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  P17  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[12]]       ; ##  H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  P18  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[12]]       ; ##  H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  N19  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_p[13]]       ; ##  D08  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  N20  IOSTANDARD LVDS_25  DIFF_TERM TRUE} [get_ports adc_data_in_n[13]]       ; ##  D09  FMC_LPC_LA01_CC_N

set_property  -dict {PACKAGE_PIN  L18  IOSTANDARD LVCMOS25} [get_ports spi_clk]                                ; ##  H04  FMC_LPC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN  L19  IOSTANDARD LVCMOS25} [get_ports spi_csn]                                ; ##  H05  FMC_LPC_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN  J20  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                               ; ##  G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  K21  IOSTANDARD LVCMOS25} [get_ports spi_int]                                ; ##  G19  FMC_LPC_LA16_N

# clocks

create_clock -name dac_clk_in   -period  2.222 [get_ports dac_clk_in_p]
create_clock -name adc_clk_in   -period  2.222 [get_ports adc_clk_in_p]


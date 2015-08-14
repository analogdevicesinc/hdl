
# reference

set_property  -dict {PACKAGE_PIN B19   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_out_p]       ; ## FMC1_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN B20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_out_n]       ; ## FMC1_LPC_LA17_CC_N

# dac 

set_property  -dict {PACKAGE_PIN L18   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dac_clk_in_p]        ; ## FMC1_LPC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN L19   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dac_clk_in_n]        ; ## FMC1_LPC_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN F21   IOSTANDARD LVDS_25} [get_ports dac_clk_out_p]                      ; ## FMC1_LPC_LA21_P
set_property  -dict {PACKAGE_PIN F22   IOSTANDARD LVDS_25} [get_ports dac_clk_out_n]                      ; ## FMC1_LPC_LA21_N
set_property  -dict {PACKAGE_PIN R20   IOSTANDARD LVDS_25} [get_ports dac_frame_out_p]                    ; ## FMC1_LPC_LA11_P
set_property  -dict {PACKAGE_PIN R21   IOSTANDARD LVDS_25} [get_ports dac_frame_out_n]                    ; ## FMC1_LPC_LA11_N
set_property  -dict {PACKAGE_PIN B21   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[0]]                  ; ## FMC1_LPC_LA32_P
set_property  -dict {PACKAGE_PIN B22   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[0]]                  ; ## FMC1_LPC_LA32_N
set_property  -dict {PACKAGE_PIN A18   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[1]]                  ; ## FMC1_LPC_LA33_P
set_property  -dict {PACKAGE_PIN A19   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[1]]                  ; ## FMC1_LPC_LA33_N
set_property  -dict {PACKAGE_PIN E21   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[2]]                  ; ## FMC1_LPC_LA30_P
set_property  -dict {PACKAGE_PIN D21   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[2]]                  ; ## FMC1_LPC_LA30_N
set_property  -dict {PACKAGE_PIN D22   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[3]]                  ; ## FMC1_LPC_LA28_P
set_property  -dict {PACKAGE_PIN C22   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[3]]                  ; ## FMC1_LPC_LA28_N
set_property  -dict {PACKAGE_PIN A16   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[4]]                  ; ## FMC1_LPC_LA31_P
set_property  -dict {PACKAGE_PIN A17   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[4]]                  ; ## FMC1_LPC_LA31_N
set_property  -dict {PACKAGE_PIN B16   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[5]]                  ; ## FMC1_LPC_LA29_P
set_property  -dict {PACKAGE_PIN B17   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[5]]                  ; ## FMC1_LPC_LA29_N
set_property  -dict {PACKAGE_PIN A21   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[6]]                  ; ## FMC1_LPC_LA24_P
set_property  -dict {PACKAGE_PIN A22   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[6]]                  ; ## FMC1_LPC_LA24_N
set_property  -dict {PACKAGE_PIN C15   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[7]]                  ; ## FMC1_LPC_LA25_P
set_property  -dict {PACKAGE_PIN B15   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[7]]                  ; ## FMC1_LPC_LA25_N
set_property  -dict {PACKAGE_PIN G17   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[8]]                  ; ## FMC1_LPC_LA22_P
set_property  -dict {PACKAGE_PIN F17   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[8]]                  ; ## FMC1_LPC_LA22_N
set_property  -dict {PACKAGE_PIN C17   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[9]]                  ; ## FMC1_LPC_LA27_P
set_property  -dict {PACKAGE_PIN C18   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[9]]                  ; ## FMC1_LPC_LA27_N
set_property  -dict {PACKAGE_PIN F18   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[10]]                 ; ## FMC1_LPC_LA26_P
set_property  -dict {PACKAGE_PIN E18   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[10]]                 ; ## FMC1_LPC_LA26_N
set_property  -dict {PACKAGE_PIN G15   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[11]]                 ; ## FMC1_LPC_LA23_P
set_property  -dict {PACKAGE_PIN G16   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[11]]                 ; ## FMC1_LPC_LA23_N
set_property  -dict {PACKAGE_PIN E19   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[12]]                 ; ## FMC1_LPC_LA19_P
set_property  -dict {PACKAGE_PIN E20   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[12]]                 ; ## FMC1_LPC_LA19_N
set_property  -dict {PACKAGE_PIN G20   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[13]]                 ; ## FMC1_LPC_LA20_P
set_property  -dict {PACKAGE_PIN G21   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[13]]                 ; ## FMC1_LPC_LA20_N
set_property  -dict {PACKAGE_PIN P20   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[14]]                 ; ## FMC1_LPC_LA15_P
set_property  -dict {PACKAGE_PIN P21   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[14]]                 ; ## FMC1_LPC_LA15_N
set_property  -dict {PACKAGE_PIN N15   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[15]]                 ; ## FMC1_LPC_LA16_P
set_property  -dict {PACKAGE_PIN P15   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[15]]                 ; ## FMC1_LPC_LA16_N

# adc 

set_property  -dict {PACKAGE_PIN M19   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]        ; ## FMC1_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN M20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]        ; ## FMC1_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN K19   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_in_p]         ; ## FMC1_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN K20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_in_n]         ; ## FMC1_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN D20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]    ; ## FMC1_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN C20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]    ; ## FMC1_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN J16   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]    ; ## FMC1_LPC_LA14_P
set_property  -dict {PACKAGE_PIN J17   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]    ; ## FMC1_LPC_LA14_N
set_property  -dict {PACKAGE_PIN P16   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]    ; ## FMC1_LPC_LA13_P
set_property  -dict {PACKAGE_PIN R16   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]    ; ## FMC1_LPC_LA13_N
set_property  -dict {PACKAGE_PIN J20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]    ; ## FMC1_LPC_LA03_P
set_property  -dict {PACKAGE_PIN K21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]    ; ## FMC1_LPC_LA03_N
set_property  -dict {PACKAGE_PIN N17   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]    ; ## FMC1_LPC_LA05_P
set_property  -dict {PACKAGE_PIN N18   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]    ; ## FMC1_LPC_LA05_N
set_property  -dict {PACKAGE_PIN L17   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]    ; ## FMC1_LPC_LA10_P
set_property  -dict {PACKAGE_PIN M17   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]    ; ## FMC1_LPC_LA10_N
set_property  -dict {PACKAGE_PIN N22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]    ; ## FMC1_LPC_LA12_P
set_property  -dict {PACKAGE_PIN P22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]    ; ## FMC1_LPC_LA12_N
set_property  -dict {PACKAGE_PIN J15   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]    ; ## FMC1_LPC_LA07_P
set_property  -dict {PACKAGE_PIN K15   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]    ; ## FMC1_LPC_LA07_N
set_property  -dict {PACKAGE_PIN L21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[8]]    ; ## FMC1_LPC_LA02_P
set_property  -dict {PACKAGE_PIN L22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[8]]    ; ## FMC1_LPC_LA02_N
set_property  -dict {PACKAGE_PIN M21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[9]]    ; ## FMC1_LPC_LA04_P
set_property  -dict {PACKAGE_PIN M22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[9]]    ; ## FMC1_LPC_LA04_N
set_property  -dict {PACKAGE_PIN M15   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[10]]   ; ## FMC1_LPC_LA09_P
set_property  -dict {PACKAGE_PIN M16   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[10]]   ; ## FMC1_LPC_LA09_N
set_property  -dict {PACKAGE_PIN J21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[11]]   ; ## FMC1_LPC_LA08_P
set_property  -dict {PACKAGE_PIN J22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[11]]   ; ## FMC1_LPC_LA08_N
set_property  -dict {PACKAGE_PIN J18   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[12]]   ; ## FMC1_LPC_LA06_P
set_property  -dict {PACKAGE_PIN K18   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[12]]   ; ## FMC1_LPC_LA06_N
set_property  -dict {PACKAGE_PIN N19   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[13]]   ; ## FMC1_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN N20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[13]]   ; ## FMC1_LPC_LA01_CC_N

# clocks

create_clock -name dac_clk_in   -period  2.16 [get_ports dac_clk_in_p]
create_clock -name adc_clk_in   -period  4.00 [get_ports adc_clk_in_p]

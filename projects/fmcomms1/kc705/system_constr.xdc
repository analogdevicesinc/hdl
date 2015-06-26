
# reference

set_property  -dict {PACKAGE_PIN AB27   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_out_p]      ; ## FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN AC27   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_out_n]      ; ## FMC_LPC_LA17_CC_N

# dac 

set_property  -dict {PACKAGE_PIN AF22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dac_clk_in_p]       ; ## FMC_LPC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN AG23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dac_clk_in_n]       ; ## FMC_LPC_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN AG27   IOSTANDARD LVDS_25} [get_ports dac_clk_out_p]                     ; ## FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN AG28   IOSTANDARD LVDS_25} [get_ports dac_clk_out_n]                     ; ## FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN AE25   IOSTANDARD LVDS_25} [get_ports dac_frame_out_p]                   ; ## FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN AF25   IOSTANDARD LVDS_25} [get_ports dac_frame_out_n]                   ; ## FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN Y30    IOSTANDARD LVDS_25} [get_ports dac_data_out_p[0]]                 ; ## FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN AA30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[0]]                ; ## FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN AC29   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[1]]                 ; ## FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN AC30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[1]]                 ; ## FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN AB29   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[2]]                 ; ## FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN AB30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[2]]                 ; ## FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN AE30   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[3]]                 ; ## FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN AF30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[3]]                 ; ## FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN AD29   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[4]]                 ; ## FMC_LPC_LA31_P
set_property  -dict {PACKAGE_PIN AE29   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[4]]                 ; ## FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN AE28   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[5]]                 ; ## FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN AF28   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[5]]                 ; ## FMC_LPC_LA29_N
set_property  -dict {PACKAGE_PIN AG30   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[6]]                 ; ## FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN AH30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[6]]                 ; ## FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN AC26   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[7]]                 ; ## FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN AD26   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[7]]                 ; ## FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN AJ27   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[8]]                 ; ## FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN AK28   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[8]]                 ; ## FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN AJ28   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[9]]                 ; ## FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN AJ29   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[9]]                 ; ## FMC_LPC_LA27_N
set_property  -dict {PACKAGE_PIN AK29   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[10]]                ; ## FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN AK30   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[10]]                ; ## FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN AH26   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[11]]                ; ## FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN AH27   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[11]]                ; ## FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN AJ26   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[12]]                ; ## FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN AK26   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[12]]                ; ## FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN AF26   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[13]]                ; ## FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN AF27   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[13]]                ; ## FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN AC24   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[14]]                ; ## FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN AD24   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[14]]                ; ## FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN AC22   IOSTANDARD LVDS_25} [get_ports dac_data_out_p[15]]                ; ## FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN AD22   IOSTANDARD LVDS_25} [get_ports dac_data_out_n[15]]                ; ## FMC_LPC_LA16_N

# adc 

set_property  -dict {PACKAGE_PIN AG29   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]       ; ## FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN AH29   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]       ; ## FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN AD23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_in_p]        ; ## FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN AE24   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_in_n]        ; ## FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN AD27   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]   ; ## FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN AD28   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]   ; ## FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN AD21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]   ; ## FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN AE21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]   ; ## FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN AB24   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]   ; ## FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN AC25   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]   ; ## FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN AG20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]   ; ## FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN AH20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]   ; ## FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN AG22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]   ; ## FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN AH22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]   ; ## FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN AJ24   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]   ; ## FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN AK25   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]   ; ## FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN AA20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]   ; ## FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN AB20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]   ; ## FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN AG25   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]   ; ## FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN AH25   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]   ; ## FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN AF20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[8]]   ; ## FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN AF21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[8]]   ; ## FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN AH21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[9]]   ; ## FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN AJ21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[9]]   ; ## FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN AK23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[10]]  ; ## FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN AK24   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[10]]  ; ## FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN AJ22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[11]]  ; ## FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN AJ23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[11]]  ; ## FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN AK20   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[12]]  ; ## FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN AK21   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[12]]  ; ## FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN AE23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[13]]  ; ## FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN AF23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[13]]  ; ## FMC_LPC_LA01_CC_N

# clocks

create_clock -name dac_clk_in   -period  2.00  [get_ports dac_clk_in_p]
create_clock -name adc_clk_in   -period  4.00  [get_ports adc_clk_in_p]

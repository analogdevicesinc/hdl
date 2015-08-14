
# reference

set_property  -dict {PACKAGE_PIN U37    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports ref_clk_out_p]      ; ## FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN U38    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports ref_clk_out_n]      ; ## FMC_LPC_LA17_CC_N

# dac 

set_property  -dict {PACKAGE_PIN AF39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports dac_clk_in_p]       ; ## FMC_LPC_CLK0_M2C_P
set_property  -dict {PACKAGE_PIN AF40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports dac_clk_in_n]       ; ## FMC_LPC_CLK0_M2C_N
set_property  -dict {PACKAGE_PIN P35    IOSTANDARD LVDS} [get_ports dac_clk_out_p]                     ; ## FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN P36    IOSTANDARD LVDS} [get_ports dac_clk_out_n]                     ; ## FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN Y42    IOSTANDARD LVDS} [get_ports dac_frame_out_p]                   ; ## FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN AA42   IOSTANDARD LVDS} [get_ports dac_frame_out_n]                   ; ## FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN P37    IOSTANDARD LVDS} [get_ports dac_data_out_p[0]]                 ; ## FMC_LPC_LA32_P
set_property  -dict {PACKAGE_PIN P38    IOSTANDARD LVDS} [get_ports dac_data_out_n[0]]                ; ## FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN T36    IOSTANDARD LVDS} [get_ports dac_data_out_p[1]]                 ; ## FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN R37    IOSTANDARD LVDS} [get_ports dac_data_out_n[1]]                 ; ## FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN T32    IOSTANDARD LVDS} [get_ports dac_data_out_p[2]]                 ; ## FMC_LPC_LA30_P
set_property  -dict {PACKAGE_PIN R32    IOSTANDARD LVDS} [get_ports dac_data_out_n[2]]                 ; ## FMC_LPC_LA30_N
set_property  -dict {PACKAGE_PIN V35    IOSTANDARD LVDS} [get_ports dac_data_out_p[3]]                 ; ## FMC_LPC_LA28_P
set_property  -dict {PACKAGE_PIN V36    IOSTANDARD LVDS} [get_ports dac_data_out_n[3]]                 ; ## FMC_LPC_LA28_N
set_property  -dict {PACKAGE_PIN V39    IOSTANDARD LVDS} [get_ports dac_data_out_p[4]]                 ; ## FMC_LPC_LA31_P
set_property  -dict {PACKAGE_PIN V40    IOSTANDARD LVDS} [get_ports dac_data_out_n[4]]                 ; ## FMC_LPC_LA31_N
set_property  -dict {PACKAGE_PIN W36    IOSTANDARD LVDS} [get_ports dac_data_out_p[5]]                 ; ## FMC_LPC_LA29_P
set_property  -dict {PACKAGE_PIN W37    IOSTANDARD LVDS} [get_ports dac_data_out_n[5]]                 ; ## FMC_LPC_LA29_N
set_property  -dict {PACKAGE_PIN U34    IOSTANDARD LVDS} [get_ports dac_data_out_p[6]]                 ; ## FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN T35    IOSTANDARD LVDS} [get_ports dac_data_out_n[6]]                 ; ## FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN R33    IOSTANDARD LVDS} [get_ports dac_data_out_p[7]]                 ; ## FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN R34    IOSTANDARD LVDS} [get_ports dac_data_out_n[7]]                 ; ## FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN W32    IOSTANDARD LVDS} [get_ports dac_data_out_p[8]]                 ; ## FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN W33    IOSTANDARD LVDS} [get_ports dac_data_out_n[8]]                 ; ## FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN P32    IOSTANDARD LVDS} [get_ports dac_data_out_p[9]]                 ; ## FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN P33    IOSTANDARD LVDS} [get_ports dac_data_out_n[9]]                 ; ## FMC_LPC_LA27_N
set_property  -dict {PACKAGE_PIN N33    IOSTANDARD LVDS} [get_ports dac_data_out_p[10]]                ; ## FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN N34    IOSTANDARD LVDS} [get_ports dac_data_out_n[10]]                ; ## FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN R38    IOSTANDARD LVDS} [get_ports dac_data_out_p[11]]                ; ## FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN R39    IOSTANDARD LVDS} [get_ports dac_data_out_n[11]]                ; ## FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN U32    IOSTANDARD LVDS} [get_ports dac_data_out_p[12]]                ; ## FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN U33    IOSTANDARD LVDS} [get_ports dac_data_out_n[12]]                ; ## FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN V33    IOSTANDARD LVDS} [get_ports dac_data_out_p[13]]                ; ## FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN V34    IOSTANDARD LVDS} [get_ports dac_data_out_n[13]]                ; ## FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN AC38   IOSTANDARD LVDS} [get_ports dac_data_out_p[14]]                ; ## FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN AC39   IOSTANDARD LVDS} [get_ports dac_data_out_n[14]]                ; ## FMC_LPC_LA15_N
set_property  -dict {PACKAGE_PIN AJ40   IOSTANDARD LVDS} [get_ports dac_data_out_p[15]]                ; ## FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN AJ41   IOSTANDARD LVDS} [get_ports dac_data_out_n[15]]                ; ## FMC_LPC_LA16_N

# adc 

set_property  -dict {PACKAGE_PIN U39    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_clk_in_p]       ; ## FMC_LPC_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN T39    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_clk_in_n]       ; ## FMC_LPC_CLK1_M2C_N
set_property  -dict {PACKAGE_PIN AD40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_or_in_p]        ; ## FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN AD41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_or_in_n]        ; ## FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN U36    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]   ; ## FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN T37    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]   ; ## FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN AB38   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]   ; ## FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN AB39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]   ; ## FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN W40    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]   ; ## FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN Y40    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]   ; ## FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN AJ42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]   ; ## FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN AK42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]   ; ## FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN AF42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]   ; ## FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN AG42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]   ; ## FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN AB41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]   ; ## FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN AB42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]   ; ## FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN Y39    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]   ; ## FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN AA39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]   ; ## FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN AC40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]   ; ## FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN AC41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]   ; ## FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN AK39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[8]]   ; ## FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN AL39   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[8]]   ; ## FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN AL41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[9]]   ; ## FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN AL42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[9]]   ; ## FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN AJ38   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[10]]  ; ## FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN AK38   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[10]]  ; ## FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN AD42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[11]]  ; ## FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN AE42   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[11]]  ; ## FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN AD38   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[12]]  ; ## FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN AE38   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[12]]  ; ## FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN AF41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_p[13]]  ; ## FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN AG41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports adc_data_in_n[13]]  ; ## FMC_LPC_LA01_CC_N

# clocks

create_clock -name dac_clk_in   -period  2.00  [get_ports dac_clk_in_p]
create_clock -name adc_clk_in   -period  4.00  [get_ports adc_clk_in_p]

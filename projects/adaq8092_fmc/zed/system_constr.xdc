###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# adaq8092
set_property -dict {PACKAGE_PIN M19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]        ; #G06   FMC_LPC_LA00_P 
set_property -dict {PACKAGE_PIN M20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]        ; #G07   FMC_LPC_LA00_N 
set_property -dict {PACKAGE_PIN P17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[0]]   ; #H07   FMC_LPC_LA02_P D1_0
set_property -dict {PACKAGE_PIN P18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[0]]   ; #H08   FMC_LPC_LA02_N D1_1 
set_property -dict {PACKAGE_PIN N22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[1]]   ; #G09   FMC_LPC_LA03_P D1_2
set_property -dict {PACKAGE_PIN P22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[1]]   ; #G10  FMC_LPC_LA03_N D1_3
set_property -dict {PACKAGE_PIN M21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[2]]   ; #H10  FMC_LPC_LA04_P D1_4
set_property -dict {PACKAGE_PIN M22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[2]]   ; #H11  FMC_LPC_LA04_N D1_5
set_property -dict {PACKAGE_PIN J18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[3]]   ; #D11  FMC_LPC_LA05_P D1_6
set_property -dict {PACKAGE_PIN K18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[3]]   ; #D12  FMC_LPC_LA05_N D1_7
set_property -dict {PACKAGE_PIN L21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[4]]   ; #C10  FMC_LPC_LA06_P D1_8
set_property -dict {PACKAGE_PIN L22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[4]]   ; #C11  FMC_LPC_LA06_N D1_9
set_property -dict {PACKAGE_PIN T16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[5]]   ; #H13  FMC_LPC_LA07_P D1_10
set_property -dict {PACKAGE_PIN T17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[5]]   ; #H14  FMC_LPC_LA07_N D1_11
set_property -dict {PACKAGE_PIN J21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_p[6]]   ; #G12 FMC_LPC_LA08_P D1_12
set_property -dict {PACKAGE_PIN J22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in1_n[6]]   ; #G13  FMC_LPC_LA08_N D1_13
  
set_property -dict {PACKAGE_PIN R20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[0]]   ; #D14  FMC_LPC_LA09_P D2_0
set_property -dict {PACKAGE_PIN R21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[0]]   ; #D15  FMC_LPC_LA09_N D2_1 
set_property -dict {PACKAGE_PIN R19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[1]]   ; #C14  FMC_LPC_LA10_P D2_2
set_property -dict {PACKAGE_PIN T19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[1]]   ; #C15  FMC_LPC_LA10_N D2_3
set_property -dict {PACKAGE_PIN N17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[2]]   ; #H16  FMC_LPC_LA11_P D2_4
set_property -dict {PACKAGE_PIN N18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[2]]   ; #H17  FMC_LPC_LA11_N D2_5
set_property -dict {PACKAGE_PIN P20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[3]]   ; #G15  FMC_LPC_LA12_P D2_6
set_property -dict {PACKAGE_PIN P21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[3]]   ; #G16  FMC_LPC_LA12_N D2_7
set_property -dict {PACKAGE_PIN L17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[4]]   ; #D17  FMC_LPC_LA13_P D2_8
set_property -dict {PACKAGE_PIN M17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[4]]   ; #D18  FMC_LPC_LA13_N D2_9
set_property -dict {PACKAGE_PIN K19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[5]]   ; #C18  FMC_LPC_LA14_P D2_10
set_property -dict {PACKAGE_PIN K20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[5]]   ; #C19  FMC_LPC_LA14_N D2_11
set_property -dict {PACKAGE_PIN J16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_p[6]]   ; #H19  FMC_LPC_LA15_P D2_12
set_property -dict {PACKAGE_PIN J17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in2_n[6]]   ; #H20  FMC_LPC_LA15_N D2_13
  
set_property -dict {PACKAGE_PIN J20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]       ; #G18  FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]       ; #G19  FMC_LPC_LA16_N
  
# spi  
  
set_property -dict {PACKAGE_PIN B20    IOSTANDARD LVCMOS25} [get_ports spi_csn]                           ; #D21  FMC_LPC_LA17_N
set_property -dict {PACKAGE_PIN D20    IOSTANDARD LVCMOS25} [get_ports spi_clk]                           ; #C22  FMC_LPC_LA18_P
set_property -dict {PACKAGE_PIN B19    IOSTANDARD LVCMOS25} [get_ports spi_mosi]                          ; #D20  FMC_LPC_LA17_P
set_property -dict {PACKAGE_PIN C20    IOSTANDARD LVCMOS25} [get_ports spi_miso]                          ; #C23  FMC_LPC_LA18_N
  
# other  
  
set_property -dict {PACKAGE_PIN G20    IOSTANDARD LVCMOS25} [get_ports adc_par_ser]                       ; #G21  FMC_LPC_LA20_P
set_property -dict {PACKAGE_PIN G21    IOSTANDARD LVCMOS25} [get_ports en_1p8]                            ; #H23  FMC_LPC_LA20_N
set_property -dict {PACKAGE_PIN G15    IOSTANDARD LVCMOS25} [get_ports adc_pd1]                           ; #H22  FMC_LPC_LA19_P
set_property -dict {PACKAGE_PIN G16    IOSTANDARD LVCMOS25} [get_ports adc_pd2]                           ; #H23  FMC_LPC_LA19_N

# clocks

create_clock -name adc_clk_adaq      -period 9.523 [get_ports adc_clk_in_p]

# Input Delay Constraint

set rise_min            4.761;       # period/2 - skew_bre(=0)       
set rise_max            5.361;       # period/2 + skew_are(=0.6)       
set fall_min            4.761;       # period/2 - skew_bfe(=0)        
set fall_max            5.361;       # period/2 - skew_are(=0.6)         

#channel 1 

set_input_delay -clock adc_clk_adaq -max  $rise_max  [get_ports adc_data_in1_p[*]];
set_input_delay -clock adc_clk_adaq -min  $rise_min  [get_ports adc_data_in1_p[*]];
set_input_delay -clock adc_clk_adaq -max  $fall_max  [get_ports adc_data_in1_p[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk_adaq -min  $fall_min  [get_ports adc_data_in1_p[*]] -clock_fall -add_delay;

set_input_delay -clock adc_clk_adaq -max  $rise_max  [get_ports adc_data_in1_n[*]];                       
set_input_delay -clock adc_clk_adaq -min  $rise_min  [get_ports adc_data_in1_n[*]];                       
set_input_delay -clock adc_clk_adaq -max  $fall_max  [get_ports adc_data_in1_n[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk_adaq -min  $fall_min  [get_ports adc_data_in1_n[*]] -clock_fall -add_delay;
			   				   
#channel 2             
					   
set_input_delay -clock adc_clk_adaq -max  $rise_max  [get_ports adc_data_in2_p[*]];
set_input_delay -clock adc_clk_adaq -min  $rise_min  [get_ports adc_data_in2_p[*]];
set_input_delay -clock adc_clk_adaq -max  $fall_max  [get_ports adc_data_in2_p[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk_adaq -min  $fall_min  [get_ports adc_data_in2_p[*]] -clock_fall -add_delay;

set_input_delay -clock adc_clk_adaq -max  $rise_max  [get_ports adc_data_in2_n[*]];                       
set_input_delay -clock adc_clk_adaq -min  $rise_min  [get_ports adc_data_in2_n[*]];                       
set_input_delay -clock adc_clk_adaq -max  $fall_max  [get_ports adc_data_in2_n[*]] -clock_fall -add_delay;															  
set_input_delay -clock adc_clk_adaq -min  $fall_min  [get_ports adc_data_in2_n[*]] -clock_fall -add_delay;

set_input_delay -clock adc_clk_adaq -max  $rise_max  [get_ports adc_data_or_*];                       
set_input_delay -clock adc_clk_adaq -min  $rise_min  [get_ports adc_data_or_*];                       
set_input_delay -clock adc_clk_adaq -max  $fall_max  [get_ports adc_data_or_*] -clock_fall -add_delay;
set_input_delay -clock adc_clk_adaq -min  $fall_min  [get_ports adc_data_or_*] -clock_fall -add_delay;

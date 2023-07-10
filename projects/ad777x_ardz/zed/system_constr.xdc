###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property  -dict {PACKAGE_PIN AB9   IOSTANDARD LVCMOS33}  [get_ports adc_clk_in]     ; #DCLK          P24_P9    JA1_9 
set_property  -dict {PACKAGE_PIN AB10  IOSTANDARD LVCMOS33}  [get_ports adc_ready_in]   ; #DRDY_N        P24_P8    JA1_8 
set_property  -dict {PACKAGE_PIN AA8   IOSTANDARD LVCMOS33}  [get_ports adc_data_in[0]] ; #DOUT0         P24_P10   JA1_10  
set_property  -dict {PACKAGE_PIN AB6   IOSTANDARD LVCMOS33}  [get_ports adc_data_in[1]] ; #DOUT1         P30_P2    JC1_1_N
set_property  -dict {PACKAGE_PIN Y4    IOSTANDARD LVCMOS33}  [get_ports adc_data_in[2]] ; #DOUT2         P30_P3    JC1_2_P
set_property  -dict {PACKAGE_PIN AA4   IOSTANDARD LVCMOS33}  [get_ports adc_data_in[3]] ; #DOUT3         P30_P4    JC1_2_N

set_property  -dict {PACKAGE_PIN R6    IOSTANDARD LVCMOS33}  [get_ports reset_n]        ; #RESET_N       P30_P7    JC1_3_P
set_property  -dict {PACKAGE_PIN AB7   IOSTANDARD LVCMOS33}  [get_ports start_n]        ; #START_N       P30_P1    JC1_1_P
set_property  -dict {PACKAGE_PIN T6    IOSTANDARD LVCMOS33}  [get_ports sdp_convst]     ; #CONVST        P30_P8    JC1_3_N
set_property  -dict {PACKAGE_PIN W12   IOSTANDARD LVCMOS33}  [get_ports alert]          ; #ALERT         P16_P1    JB1_1  
set_property  -dict {PACKAGE_PIN W11   IOSTANDARD LVCMOS33}  [get_ports sync_adc_miso]  ; #SYNC_OUT_N    P16_P2    JB1_2  
set_property  -dict {PACKAGE_PIN V10   IOSTANDARD LVCMOS33}  [get_ports sync_adc_mosi]  ; #SYNC_IN_N     P16_P3    JB1_3  
set_property  -dict {PACKAGE_PIN V12   IOSTANDARD LVCMOS33}  [get_ports gpio0]          ; #GPIO0         P16_P7    JB1_7  
set_property  -dict {PACKAGE_PIN W10   IOSTANDARD LVCMOS33}  [get_ports gpio1]          ; #GPIO1         P16_P8    JB1_8  
set_property  -dict {PACKAGE_PIN V9    IOSTANDARD LVCMOS33}  [get_ports gpio2]          ; #GPIO2         P16_P9    JB1_9 
set_property  -dict {PACKAGE_PIN AB11  IOSTANDARD LVCMOS33}  [get_ports sdp_mclk]       ; #EXT_MCLK?     P24_P7    JA1_7  

set_property  -dict {PACKAGE_PIN Y11   IOSTANDARD LVCMOS33}  [get_ports spi_csn]        ; #CS_N          P24_P1    JA1_1  
set_property  -dict {PACKAGE_PIN AA11  IOSTANDARD LVCMOS33}  [get_ports spi_mosi]       ; #SDI           P24_P2    JA1_2   
set_property  -dict {PACKAGE_PIN Y10   IOSTANDARD LVCMOS33}  [get_ports spi_miso]       ; #SDO           P24_P3    JA1_3  
set_property  -dict {PACKAGE_PIN AA9   IOSTANDARD LVCMOS33}  [get_ports spi_clk]        ; #SCLK          P24_P4    JA1_4 


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets adc_clk_in]    
create_clock -name adc_clk -period 488   [get_ports adc_clk_in] 

set fall_min            224;       # period/2(=244) - skew_bfe(=20)        
set fall_max            264;       # period/2(=244) + skew_are(=20)  

set_input_delay -clock adc_clk -max  $fall_max  [get_ports adc_data_in[*]] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_data_in[*]] -clock_fall -add_delay;

set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_ready_in  ] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min  $fall_min  [get_ports adc_ready_in  ] -clock_fall -add_delay;

set_input_delay -clock adc_clk -min  $fall_min  [get_ports sync_adc_miso ] -clock_fall -add_delay;
set_input_delay -clock adc_clk -min  $fall_min  [get_ports sync_adc_miso ] -clock_fall -add_delay;


# constraints

set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fmc_clk0_p]         ; ## IO_L13P_T2_MRCC_12       
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fmc_clk0_n]         ; ## IO_L13N_T2_MRCC_12       
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fmc_clk1_p]         ; ## IO_L13P_T2_MRCC_13       
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports fmc_clk1_n]         ; ## IO_L13N_T2_MRCC_13       

set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS25} [get_ports fmc_prstn]                        ; ## IO_25_13                 
set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[0]]                      ; ## IO_L12P_T1_MRCC_12       
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[0]]                      ; ## IO_L12N_T1_MRCC_12       
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[1]]                      ; ## IO_L11P_T1_SRCC_12       
set_property  -dict {PACKAGE_PIN  AD11  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[1]]                      ; ## IO_L11N_T1_SRCC_12       
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD LVCMOS25} [get_ports fmc_la_p[2]]                      ; ## IO_L1P_T0_12             
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS25} [get_ports fmc_la_n[2]]                      ; ## IO_L1N_T0_12             
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[3]]                      ; ## IO_L2P_T0_12             
set_property  -dict {PACKAGE_PIN  AC11  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[3]]                      ; ## IO_L2N_T0_12             
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVCMOS25} [get_ports fmc_la_p[4]]                      ; ## IO_L3P_T0_DQS_12         
set_property  -dict {PACKAGE_PIN  AA10  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[4]]                      ; ## IO_L3N_T0_DQS_12         
set_property  -dict {PACKAGE_PIN  AB11  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[5]]                      ; ## IO_L4P_T0_12             
set_property  -dict {PACKAGE_PIN  AB10  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[5]]                      ; ## IO_L4N_T0_12             
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS25} [get_ports fmc_la_p[6]]                      ; ## IO_L5P_T0_12             
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS25} [get_ports fmc_la_n[6]]                      ; ## IO_L5N_T0_12             
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[7]]                      ; ## IO_L6P_T0_12             
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[7]]                      ; ## IO_L6N_T0_VREF_12        
set_property  -dict {PACKAGE_PIN  AE10  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[8]]                      ; ## IO_L7P_T1_12             
set_property  -dict {PACKAGE_PIN  AD10  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[8]]                      ; ## IO_L7N_T1_12             
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[9]]                      ; ## IO_L8P_T1_12             
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[9]]                      ; ## IO_L8N_T1_12             
set_property  -dict {PACKAGE_PIN  AE11  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[10]]                     ; ## IO_L9P_T1_DQS_12         
set_property  -dict {PACKAGE_PIN  AF10  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[10]]                     ; ## IO_L9N_T1_DQS_12         
set_property  -dict {PACKAGE_PIN  AE13  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[11]]                     ; ## IO_L10P_T1_12            
set_property  -dict {PACKAGE_PIN  AF13  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[11]]                     ; ## IO_L10N_T1_12            
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[12]]                     ; ## IO_L14P_T2_SRCC_12       
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[12]]                     ; ## IO_L14N_T2_SRCC_12       
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[13]]                     ; ## IO_L15P_T2_DQS_12        
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[13]]                     ; ## IO_L15N_T2_DQS_12        
set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[14]]                     ; ## IO_L16P_T2_12            
set_property  -dict {PACKAGE_PIN  AF14  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[14]]                     ; ## IO_L16N_T2_12            
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[15]]                     ; ## IO_L17P_T2_12            
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[15]]                     ; ## IO_L17N_T2_12            
set_property  -dict {PACKAGE_PIN  AE17  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[16]]                     ; ## IO_L18P_T2_12            
set_property  -dict {PACKAGE_PIN  AF17  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[16]]                     ; ## IO_L18N_T2_12            
set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[17]]                     ; ## IO_L12P_T1_MRCC_13       
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[17]]                     ; ## IO_L12N_T1_MRCC_13       
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[18]]                     ; ## IO_L11P_T1_SRCC_13       
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[18]]                     ; ## IO_L11N_T1_SRCC_13       
set_property  -dict {PACKAGE_PIN  AA25  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[19]]                     ; ## IO_L1P_T0_13             
set_property  -dict {PACKAGE_PIN  AB25  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[19]]                     ; ## IO_L1N_T0_13             
set_property  -dict {PACKAGE_PIN  AB26  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[20]]                     ; ## IO_L2P_T0_13             
set_property  -dict {PACKAGE_PIN  AC26  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[20]]                     ; ## IO_L2N_T0_13             
set_property  -dict {PACKAGE_PIN  AE25  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[21]]                     ; ## IO_L3P_T0_DQS_13         
set_property  -dict {PACKAGE_PIN  AE26  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[21]]                     ; ## IO_L3N_T0_DQS_13         
set_property  -dict {PACKAGE_PIN  AD25  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[22]]                     ; ## IO_L4P_T0_13             
set_property  -dict {PACKAGE_PIN  AD26  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[22]]                     ; ## IO_L4N_T0_13             
set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[23]]                     ; ## IO_L6P_T0_13             
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[23]]                     ; ## IO_L6N_T0_VREF_13        
set_property  -dict {PACKAGE_PIN  AE22  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[24]]                     ; ## IO_L7P_T1_13             
set_property  -dict {PACKAGE_PIN  AF22  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[24]]                     ; ## IO_L7N_T1_13             
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[25]]                     ; ## IO_L8P_T1_13             
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[25]]                     ; ## IO_L8N_T1_13             
set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[26]]                     ; ## IO_L9P_T1_DQS_13         
set_property  -dict {PACKAGE_PIN  AB22  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[26]]                     ; ## IO_L9N_T1_DQS_13         
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[27]]                     ; ## IO_L10P_T1_13            
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[27]]                     ; ## IO_L10N_T1_13            
set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[28]]                     ; ## IO_L14P_T2_SRCC_13       
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[28]]                     ; ## IO_L14N_T2_SRCC_13       
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[29]]                     ; ## IO_L15P_T2_DQS_13        
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[29]]                     ; ## IO_L15N_T2_DQS_13        
set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[30]]                     ; ## IO_L16P_T2_13            
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[30]]                     ; ## IO_L16N_T2_13            
set_property  -dict {PACKAGE_PIN  AD18  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[31]]                     ; ## IO_L17P_T2_13            
set_property  -dict {PACKAGE_PIN  AD19  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[31]]                     ; ## IO_L17N_T2_13            
set_property  -dict {PACKAGE_PIN  AE18  IOSTANDARD LVCMOS25} [get_ports fmc_la_p[32]]                     ; ## IO_L18P_T2_13            
set_property  -dict {PACKAGE_PIN  AF18  IOSTANDARD LVCMOS25} [get_ports fmc_la_n[32]]                     ; ## IO_L18N_T2_13            
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS25} [get_ports fmc_la_p[33]]                     ; ## IO_L19P_T3_13            
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS25} [get_ports fmc_la_n[33]]                     ; ## IO_L19N_T3_VREF_13       
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS25} [get_ports pmod0[0]]                         ; ## IO_L21P_T3_DQS_13        
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS25} [get_ports pmod0[1]]                         ; ## IO_L21N_T3_DQS_13        
set_property  -dict {PACKAGE_PIN  AA19  IOSTANDARD LVCMOS25} [get_ports pmod0[2]]                         ; ## IO_L22P_T3_13            
set_property  -dict {PACKAGE_PIN  AB19  IOSTANDARD LVCMOS25} [get_ports pmod0[3]]                         ; ## IO_L22N_T3_13            
set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS25} [get_ports pmod0[4]]                         ; ## IO_L23P_T3_13            
set_property  -dict {PACKAGE_PIN  W19   IOSTANDARD LVCMOS25} [get_ports pmod0[5]]                         ; ## IO_L23N_T3_13            
set_property  -dict {PACKAGE_PIN  Y18   IOSTANDARD LVCMOS25} [get_ports pmod0[6]]                         ; ## IO_L24P_T3_13            
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS25} [get_ports pmod0[7]]                         ; ## IO_L24N_T3_13            
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS18} [get_ports pmod1[0]]                         ; ## IO_L19P_T3_34            
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS18} [get_ports pmod1[1]]                         ; ## IO_L19N_T3_VREF_34       
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS18} [get_ports pmod1[2]]                         ; ## IO_L20P_T3_34            
set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS18} [get_ports pmod1[3]]                         ; ## IO_L20N_T3_34            
set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports pmod1[4]]                         ; ## IO_L21P_T3_DQS_34        
set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS18} [get_ports pmod1[5]]                         ; ## IO_L21N_T3_DQS_34        
set_property  -dict {PACKAGE_PIN  A4    IOSTANDARD LVCMOS18} [get_ports pmod1[6]]                         ; ## IO_L22P_T3_34            
set_property  -dict {PACKAGE_PIN  A3    IOSTANDARD LVCMOS18} [get_ports pmod1[7]]                         ; ## IO_L22N_T3_34            

set_property  -dict {PACKAGE_PIN  W6}   [get_ports fmc_gt_ref_clk_p]                                      ; ## MGTREFCLK0P_111          
set_property  -dict {PACKAGE_PIN  W5}   [get_ports fmc_gt_ref_clk_n]                                      ; ## MGTREFCLK0N_111          
set_property  -dict {PACKAGE_PIN  AF8}  [get_ports fmc_gt_tx_p]                                           ; ## MGTXTXP0_111             
set_property  -dict {PACKAGE_PIN  AF7}  [get_ports fmc_gt_tx_n]                                           ; ## MGTXTXN0_111             
set_property  -dict {PACKAGE_PIN  AD8}  [get_ports fmc_gt_rx_p]                                           ; ## MGTXRXP0_111             
set_property  -dict {PACKAGE_PIN  AD7}  [get_ports fmc_gt_rx_n]                                           ; ## MGTXRXN0_111             

# clocks

create_clock -name ref_clk      -period  4.00 [get_ports fmc_gt_ref_clk_p]
create_clock -name tx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/RXOUTCLK]


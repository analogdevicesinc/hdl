
# rf-board

set_property  -dict {PACKAGE_PIN  K10  IOSTANDARD LVCMOS18} [get_ports gpio_rfpwr_enable]              ; ## IO_25_VRP_34
set_property  -dict {PACKAGE_PIN  AA20 IOSTANDARD LVCMOS25} [get_ports gpio_rf0]                       ; ## IO_L20_13_JX2_P
set_property  -dict {PACKAGE_PIN  AB20 IOSTANDARD LVCMOS25} [get_ports gpio_rf1]                       ; ## IO_L20_13_JX2_N
set_property  -dict {PACKAGE_PIN  AA14 IOSTANDARD LVCMOS25} [get_ports gpio_rf2]                       ; ## IO_L22_12_JX2_N
set_property  -dict {PACKAGE_PIN  J9   IOSTANDARD LVCMOS18} [get_ports gpio_rf3]                       ; ## IO_L05_34_JX4_N

# ethernet-1

set_property  -dict {PACKAGE_PIN  B10   IOSTANDARD LVCMOS18} [get_ports eth1_mdc]                      ; ## IO_L16P_T2_34      
set_property  -dict {PACKAGE_PIN  A10   IOSTANDARD LVCMOS18} [get_ports eth1_mdio]                     ; ## IO_L16N_T2_34      
set_property  -dict {PACKAGE_PIN  G7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxclk]              ; ## IO_L12P_T1_MRCC_34 
set_property  -dict {PACKAGE_PIN  F7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxctl]              ; ## IO_L12N_T1_MRCC_34 
set_property  -dict {PACKAGE_PIN  E6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[0]]          ; ## IO_L10P_T1_34      
set_property  -dict {PACKAGE_PIN  D5    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[1]]          ; ## IO_L10N_T1_34      
set_property  -dict {PACKAGE_PIN  F8    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[2]]          ; ## IO_L11P_T1_SRCC_34 
set_property  -dict {PACKAGE_PIN  E7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_rxdata[3]]          ; ## IO_L11N_T1_SRCC_34 
set_property  -dict {PACKAGE_PIN  C8    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txclk]              ; ## IO_L13P_T2_MRCC_34 
set_property  -dict {PACKAGE_PIN  C7    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txctl]              ; ## IO_L13N_T2_MRCC_34 
set_property  -dict {PACKAGE_PIN  D6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[0]]          ; ## IO_L14P_T2_SRCC_34 
set_property  -dict {PACKAGE_PIN  C6    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[1]]          ; ## IO_L14N_T2_SRCC_34 
set_property  -dict {PACKAGE_PIN  C9    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[2]]          ; ## IO_L15P_T2_DQS_34  
set_property  -dict {PACKAGE_PIN  B9    IOSTANDARD LVCMOS18} [get_ports eth1_rgmii_txdata[3]]          ; ## IO_L15N_T2_DQS_34  

# hdmi

set_property  -dict {PACKAGE_PIN  L3    IOSTANDARD LVCMOS18}             [get_ports hdmi_out_clk]      ; ## IO_L11P_T1_SRCC_33       
set_property  -dict {PACKAGE_PIN  D4    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_vsync]        ; ## IO_L2P_T0_33             
set_property  -dict {PACKAGE_PIN  D3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_hsync]        ; ## IO_L2N_T0_33             
set_property  -dict {PACKAGE_PIN  K3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data_e]       ; ## IO_L11N_T1_SRCC_33       
set_property  -dict {PACKAGE_PIN  G2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[0]]      ; ## IO_L3P_T0_DQS_33         
set_property  -dict {PACKAGE_PIN  F2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[1]]      ; ## IO_L3N_T0_DQS_33         
set_property  -dict {PACKAGE_PIN  D1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[2]]      ; ## IO_L4P_T0_33             
set_property  -dict {PACKAGE_PIN  C1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[3]]      ; ## IO_L4N_T0_33             
set_property  -dict {PACKAGE_PIN  E2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[4]]      ; ## IO_L5P_T0_33             
set_property  -dict {PACKAGE_PIN  E1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[5]]      ; ## IO_L5N_T0_33             
set_property  -dict {PACKAGE_PIN  F3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[6]]      ; ## IO_L6P_T0_33             
set_property  -dict {PACKAGE_PIN  E3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[7]]      ; ## IO_L6N_T0_VREF_33        
set_property  -dict {PACKAGE_PIN  J1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[8]]      ; ## IO_L7P_T1_33             
set_property  -dict {PACKAGE_PIN  H1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[9]]      ; ## IO_L7N_T1_33             
set_property  -dict {PACKAGE_PIN  H4    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[10]]     ; ## IO_L8P_T1_33             
set_property  -dict {PACKAGE_PIN  H3    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[11]]     ; ## IO_L8N_T1_33             
set_property  -dict {PACKAGE_PIN  K2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[12]]     ; ## IO_L9P_T1_DQS_33         
set_property  -dict {PACKAGE_PIN  K1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[13]]     ; ## IO_L9N_T1_DQS_33         
set_property  -dict {PACKAGE_PIN  H2    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[14]]     ; ## IO_L10P_T1_33            
set_property  -dict {PACKAGE_PIN  G1    IOSTANDARD LVCMOS18    IOB TRUE} [get_ports hdmi_data[15]]     ; ## IO_L10N_T1_33 
set_property  -dict {PACKAGE_PIN  L9    IOSTANDARD LVCMOS18}             [get_ports hdmi_pd]           ; ## IO_0_VRN_33              
set_property  -dict {PACKAGE_PIN  N8    IOSTANDARD LVCMOS18}             [get_ports hdmi_intn]         ; ## IO_25_VRP_33             

# hdmi-spdif

set_property  -dict {PACKAGE_PIN  G4    IOSTANDARD LVCMOS18} [get_ports spdif]                         ; ## IO_L1P_T0_33             
set_property  -dict {PACKAGE_PIN  F4    IOSTANDARD LVCMOS18} [get_ports spdif_in]                      ; ## IO_L1N_T0_33             

# audio

set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD LVCMOS18} [get_ports i2s_mclk]                      ; ## IO_L6P_T0_34             
set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports i2s_bclk]                      ; ## IO_L6N_T0_VREF_34        
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]                     ; ## IO_L7P_T1_34             
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]                 ; ## IO_L7N_T1_34             
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]                  ; ## IO_L8P_T1_34             

# ad9517

set_property  -dict {PACKAGE_PIN  B4    IOSTANDARD LVCMOS18} [get_ports ad9517_csn]                    ; ## IO_L20N_T3_34             
set_property  -dict {PACKAGE_PIN  C4    IOSTANDARD LVCMOS18} [get_ports ad9517_clk]                    ; ## IO_L19P_T3_34             
set_property  -dict {PACKAGE_PIN  C3    IOSTANDARD LVCMOS18} [get_ports ad9517_mosi]                   ; ## IO_L19N_T3_VREF_34        
set_property  -dict {PACKAGE_PIN  B5    IOSTANDARD LVCMOS18} [get_ports ad9517_miso]                   ; ## IO_L20P_T3_34             
set_property  -dict {PACKAGE_PIN  B6    IOSTANDARD LVCMOS18} [get_ports ad9517_pdn]                    ; ## IO_L21P_T3_DQS_34         
set_property  -dict {PACKAGE_PIN  A5    IOSTANDARD LVCMOS18} [get_ports ad9517_ref_sel]                ; ## IO_L21N_T3_DQS_34         
set_property  -dict {PACKAGE_PIN  A4    IOSTANDARD LVCMOS18} [get_ports ad9517_ld]                     ; ## IO_L22P_T3_34             
set_property  -dict {PACKAGE_PIN  A3    IOSTANDARD LVCMOS18} [get_ports ad9517_status]                 ; ## IO_L22N_T3_34             

# clocks

create_clock -period 8.000 -name eth1_rgmii_rxclk [get_ports eth1_rgmii_rxclk]

# bad ip- we have to do this

set_property IDELAY_VALUE 16 \
  [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rx_ctl}]

set_property IODELAY_GROUP gmii2rgmii_iodelay_group\
  [get_cells -hier -filter {name =~ *idelayctrl}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}] \
  [get_cells -hier -filter {name =~ *delay_rgmii_rx_ctl}]


# unused io (gpio/gt)

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
set_property  -dict {PACKAGE_PIN  W19   IOSTANDARD LVCMOS25} [get_ports pmod0[5]]                         ; ## IO_L23N_T3_13 (TDD_SYNC)            
set_property  -dict {PACKAGE_PIN  Y18   IOSTANDARD LVCMOS25} [get_ports pmod0[6]]                         ; ## IO_L24P_T3_13            
set_property  -dict {PACKAGE_PIN  AA18  IOSTANDARD LVCMOS25} [get_ports pmod0[7]]                         ; ## IO_L24N_T3_13            

set_property  -dict {PACKAGE_PIN  W6}   [get_ports fmc_gt_ref_clk_p]                                      ; ## MGTREFCLK0P_111          
set_property  -dict {PACKAGE_PIN  W5}   [get_ports fmc_gt_ref_clk_n]                                      ; ## MGTREFCLK0N_111          
set_property  -dict {PACKAGE_PIN  AF8}  [get_ports fmc_gt_tx_p]                                           ; ## MGTXTXP0_111             
set_property  -dict {PACKAGE_PIN  AF7}  [get_ports fmc_gt_tx_n]                                           ; ## MGTXTXN0_111             
set_property  -dict {PACKAGE_PIN  AD8}  [get_ports fmc_gt_rx_p]                                           ; ## MGTXRXP0_111             
set_property  -dict {PACKAGE_PIN  AD7}  [get_ports fmc_gt_rx_n]                                           ; ## MGTXRXN0_111             

set_property  -dict {PACKAGE_PIN  AA6}  [get_ports ad9517_gt_ref_clk_p]                                   ; ## MGTREFCLK1P_111          
set_property  -dict {PACKAGE_PIN  AA5}  [get_ports ad9517_gt_ref_clk_n]                                   ; ## MGTREFCLK1N_111          
set_property  -dict {PACKAGE_PIN  AF4}  [get_ports sfp_gt_tx_p]                                           ; ## MGTXTXP1_111             
set_property  -dict {PACKAGE_PIN  AF3}  [get_ports sfp_gt_tx_n]                                           ; ## MGTXTXN1_111             
set_property  -dict {PACKAGE_PIN  AE6}  [get_ports sfp_gt_rx_p]                                           ; ## MGTXRXP1_111             
set_property  -dict {PACKAGE_PIN  AE5}  [get_ports sfp_gt_rx_n]                                           ; ## MGTXRXN1_111             

set_property  -dict {PACKAGE_PIN  M6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[0]]                      ; ## IO_L13P_T2_MRCC_33        
set_property  -dict {PACKAGE_PIN  M5    IOSTANDARD LVCMOS18} [get_ports cam_gpio[1]]                      ; ## IO_L13N_T2_MRCC_33        
set_property  -dict {PACKAGE_PIN  L5    IOSTANDARD LVCMOS18} [get_ports cam_gpio[2]]                      ; ## IO_L14P_T2_SRCC_33        
set_property  -dict {PACKAGE_PIN  L4    IOSTANDARD LVCMOS18} [get_ports cam_gpio[3]]                      ; ## IO_L14N_T2_SRCC_33        
set_property  -dict {PACKAGE_PIN  N3    IOSTANDARD LVCMOS18} [get_ports cam_gpio[4]]                      ; ## IO_L15P_T2_DQS_33         
set_property  -dict {PACKAGE_PIN  N2    IOSTANDARD LVCMOS18} [get_ports cam_gpio[5]]                      ; ## IO_L15N_T2_DQS_33         
set_property  -dict {PACKAGE_PIN  M2    IOSTANDARD LVCMOS18} [get_ports cam_gpio[6]]                      ; ## IO_L16P_T2_33             
set_property  -dict {PACKAGE_PIN  L2    IOSTANDARD LVCMOS18} [get_ports cam_gpio[7]]                      ; ## IO_L16N_T2_33             
set_property  -dict {PACKAGE_PIN  N4    IOSTANDARD LVCMOS18} [get_ports cam_gpio[8]]                      ; ## IO_L17P_T2_33             
set_property  -dict {PACKAGE_PIN  M4    IOSTANDARD LVCMOS18} [get_ports cam_gpio[9]]                      ; ## IO_L17N_T2_33             
set_property  -dict {PACKAGE_PIN  N1    IOSTANDARD LVCMOS18} [get_ports cam_gpio[10]]                     ; ## IO_L18P_T2_33             
set_property  -dict {PACKAGE_PIN  M1    IOSTANDARD LVCMOS18} [get_ports cam_gpio[11]]                     ; ## IO_L18N_T2_33             
set_property  -dict {PACKAGE_PIN  M7    IOSTANDARD LVCMOS18} [get_ports cam_gpio[12]]                     ; ## IO_L19P_T3_33             
set_property  -dict {PACKAGE_PIN  L7    IOSTANDARD LVCMOS18} [get_ports cam_gpio[13]]                     ; ## IO_L19N_T3_VREF_33        
set_property  -dict {PACKAGE_PIN  K5    IOSTANDARD LVCMOS18} [get_ports cam_gpio[14]]                     ; ## IO_L20P_T3_33             
set_property  -dict {PACKAGE_PIN  J5    IOSTANDARD LVCMOS18} [get_ports cam_gpio[15]]                     ; ## IO_L20N_T3_33             
set_property  -dict {PACKAGE_PIN  M8    IOSTANDARD LVCMOS18} [get_ports cam_gpio[16]]                     ; ## IO_L21P_T3_DQS_33         
set_property  -dict {PACKAGE_PIN  L8    IOSTANDARD LVCMOS18} [get_ports cam_gpio[17]]                     ; ## IO_L21N_T3_DQS_33         
set_property  -dict {PACKAGE_PIN  K6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[18]]                     ; ## IO_L22P_T3_33             
set_property  -dict {PACKAGE_PIN  J6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[19]]                     ; ## IO_L22N_T3_33             
set_property  -dict {PACKAGE_PIN  N7    IOSTANDARD LVCMOS18} [get_ports cam_gpio[20]]                     ; ## IO_L23P_T3_33             
set_property  -dict {PACKAGE_PIN  N6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[21]]                     ; ## IO_L23N_T3_33             
set_property  -dict {PACKAGE_PIN  K8    IOSTANDARD LVCMOS18} [get_ports cam_gpio[22]]                     ; ## IO_L24P_T3_33             
set_property  -dict {PACKAGE_PIN  K7    IOSTANDARD LVCMOS18} [get_ports cam_gpio[23]]                     ; ## IO_L24N_T3_33             
set_property  -dict {PACKAGE_PIN  J11   IOSTANDARD LVCMOS18} [get_ports cam_gpio[24]]                     ; ## IO_L1P_T0_34              
set_property  -dict {PACKAGE_PIN  H11   IOSTANDARD LVCMOS18} [get_ports cam_gpio[25]]                     ; ## IO_L1N_T0_34              
set_property  -dict {PACKAGE_PIN  G6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[26]]                     ; ## IO_L2P_T0_34              
set_property  -dict {PACKAGE_PIN  G5    IOSTANDARD LVCMOS18} [get_ports cam_gpio[27]]                     ; ## IO_L2N_T0_34              
set_property  -dict {PACKAGE_PIN  H9    IOSTANDARD LVCMOS18} [get_ports cam_gpio[28]]                     ; ## IO_L3P_T0_DQS_PUDC_B_34   
set_property  -dict {PACKAGE_PIN  G9    IOSTANDARD LVCMOS18} [get_ports cam_gpio[29]]                     ; ## IO_L3N_T0_DQS_34          
set_property  -dict {PACKAGE_PIN  H7    IOSTANDARD LVCMOS18} [get_ports cam_gpio[30]]                     ; ## IO_L4P_T0_34              
set_property  -dict {PACKAGE_PIN  H6    IOSTANDARD LVCMOS18} [get_ports cam_gpio[31]]                     ; ## IO_L4N_T0_34              
set_property  -dict {PACKAGE_PIN  J10   IOSTANDARD LVCMOS18} [get_ports cam_gpio[32]]                     ; ## IO_L5P_T0_34              
set_property  -dict {PACKAGE_PIN  J4    IOSTANDARD LVCMOS18} [get_ports cam_gpio[33]]                     ; ## IO_L12P_T1_MRCC_33        
set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD LVCMOS25} [get_ports sfp_gpio[0]]                      ; ## IO_L19P_T3_12             
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[1]]                      ; ## IO_L19N_T3_VREF_12        
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[2]]                      ; ## IO_L20P_T3_12             
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[3]]                      ; ## IO_L20N_T3_12             
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[4]]                      ; ## IO_L21P_T3_DQS_12         
set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[5]]                      ; ## IO_L21N_T3_DQS_12         
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS25} [get_ports sfp_gpio[6]]                      ; ## IO_L22P_T3_12             

# clocks

create_clock -name ref_clk      -period  4.00 [get_ports fmc_gt_ref_clk_p]
create_clock -name tx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/RXOUTCLK]

create_clock -name ref_clk      -period  4.00 [get_ports fmc_gt_ref_clk_p]
create_clock -name tx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/TXOUTCLK]
create_clock -name rx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_pzslb_gt/inst/g_lane_1[0].i_channel/i_gt/i_gtxe2_channel/RXOUTCLK]



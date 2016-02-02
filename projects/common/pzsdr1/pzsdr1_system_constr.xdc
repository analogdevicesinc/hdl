
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  K17  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_clk_in_p]       ; ## IO_L12P_T1_MRCC_35       
set_property  -dict {PACKAGE_PIN  K18  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_clk_in_n]       ; ## IO_L12N_T1_MRCC_35       
set_property  -dict {PACKAGE_PIN  M19  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_frame_in_p]     ; ## IO_L7P_T1_AD2P_35        
set_property  -dict {PACKAGE_PIN  M20  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_frame_in_n]     ; ## IO_L7N_T1_AD2N_35        
set_property  -dict {PACKAGE_PIN  C20  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]   ; ## IO_L1P_T0_AD0P_35        
set_property  -dict {PACKAGE_PIN  B20  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]   ; ## IO_L1N_T0_AD0N_35        
set_property  -dict {PACKAGE_PIN  B19  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]   ; ## IO_L2P_T0_AD8P_35        
set_property  -dict {PACKAGE_PIN  A20  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]   ; ## IO_L2N_T0_AD8N_35        
set_property  -dict {PACKAGE_PIN  E17  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]   ; ## IO_L3P_T0_DQS_AD1P_35    
set_property  -dict {PACKAGE_PIN  D18  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]   ; ## IO_L3N_T0_DQS_AD1N_35    
set_property  -dict {PACKAGE_PIN  D19  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]   ; ## IO_L4P_T0_35             
set_property  -dict {PACKAGE_PIN  D20  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]   ; ## IO_L4N_T0_35             
set_property  -dict {PACKAGE_PIN  E18  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]   ; ## IO_L5P_T0_AD9P_35        
set_property  -dict {PACKAGE_PIN  E19  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]   ; ## IO_L5N_T0_AD9N_35        
set_property  -dict {PACKAGE_PIN  F16  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]   ; ## IO_L6P_T0_35             
set_property  -dict {PACKAGE_PIN  F17  IOSTANDARD LVDS_25   DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]   ; ## IO_L6N_T0_VREF_35        
set_property  -dict {PACKAGE_PIN  M17  IOSTANDARD LVDS_25}  [get_ports tx_clk_out_p]                      ; ## IO_L8P_T1_AD10P_35       
set_property  -dict {PACKAGE_PIN  M18  IOSTANDARD LVDS_25}  [get_ports tx_clk_out_n]                      ; ## IO_L8N_T1_AD10N_35       
set_property  -dict {PACKAGE_PIN  L19  IOSTANDARD LVDS_25}  [get_ports tx_frame_out_p]                    ; ## IO_L9P_T1_DQS_AD3P_35    
set_property  -dict {PACKAGE_PIN  L20  IOSTANDARD LVDS_25}  [get_ports tx_frame_out_n]                    ; ## IO_L9N_T1_DQS_AD3N_35    
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[0]]                  ; ## IO_L13P_T2_MRCC_35       
set_property  -dict {PACKAGE_PIN  H17  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[0]]                  ; ## IO_L13N_T2_MRCC_35       
set_property  -dict {PACKAGE_PIN  J18  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[1]]                  ; ## IO_L14P_T2_AD4P_SRCC_35  
set_property  -dict {PACKAGE_PIN  H18  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[1]]                  ; ## IO_L14N_T2_AD4N_SRCC_35  
set_property  -dict {PACKAGE_PIN  F19  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[2]]                  ; ## IO_L15P_T2_DQS_AD12P_35  
set_property  -dict {PACKAGE_PIN  F20  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[2]]                  ; ## IO_L15N_T2_DQS_AD12N_35  
set_property  -dict {PACKAGE_PIN  G17  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[3]]                  ; ## IO_L16P_T2_35            
set_property  -dict {PACKAGE_PIN  G18  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[3]]                  ; ## IO_L16N_T2_35            
set_property  -dict {PACKAGE_PIN  J20  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[4]]                  ; ## IO_L17P_T2_AD5P_35       
set_property  -dict {PACKAGE_PIN  H20  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[4]]                  ; ## IO_L17N_T2_AD5N_35       
set_property  -dict {PACKAGE_PIN  G19  IOSTANDARD LVDS_25}  [get_ports tx_data_out_p[5]]                  ; ## IO_L18P_T2_AD13P_35      
set_property  -dict {PACKAGE_PIN  G20  IOSTANDARD LVDS_25}  [get_ports tx_data_out_n[5]]                  ; ## IO_L18N_T2_AD13N_35      
set_property  -dict {PACKAGE_PIN  L16  IOSTANDARD LVCMOS25} [get_ports enable]                            ; ## IO_L11P_T1_SRCC_35       
set_property  -dict {PACKAGE_PIN  L17  IOSTANDARD LVCMOS25} [get_ports txnrx]                             ; ## IO_L11N_T1_SRCC_35       

set_property  -dict {PACKAGE_PIN  H15  IOSTANDARD LVCMOS25} [get_ports gpio_status[0]]                    ; ## IO_L19P_T3_35            
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS25} [get_ports gpio_status[1]]                    ; ## IO_L19N_T3_VREF_35       
set_property  -dict {PACKAGE_PIN  K14  IOSTANDARD LVCMOS25} [get_ports gpio_status[2]]                    ; ## IO_L20P_T3_AD6P_35       
set_property  -dict {PACKAGE_PIN  J14  IOSTANDARD LVCMOS25} [get_ports gpio_status[3]]                    ; ## IO_L20N_T3_AD6N_35       
set_property  -dict {PACKAGE_PIN  N15  IOSTANDARD LVCMOS25} [get_ports gpio_status[4]]                    ; ## IO_L21P_T3_DQS_AD14P_35  
set_property  -dict {PACKAGE_PIN  N16  IOSTANDARD LVCMOS25} [get_ports gpio_status[5]]                    ; ## IO_L21N_T3_DQS_AD14N_35  
set_property  -dict {PACKAGE_PIN  L14  IOSTANDARD LVCMOS25} [get_ports gpio_status[6]]                    ; ## IO_L22P_T3_AD7P_35       
set_property  -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS25} [get_ports gpio_status[7]]                    ; ## IO_L22N_T3_AD7N_35       
set_property  -dict {PACKAGE_PIN  N17  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[0]]                       ; ## IO_L23P_T3_34            
set_property  -dict {PACKAGE_PIN  P18  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[1]]                       ; ## IO_L23N_T3_34            
set_property  -dict {PACKAGE_PIN  P15  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[2]]                       ; ## IO_L24P_T3_34            
set_property  -dict {PACKAGE_PIN  P16  IOSTANDARD LVCMOS25} [get_ports gpio_ctl[3]]                       ; ## IO_L24N_T3_34            
set_property  -dict {PACKAGE_PIN  K19  IOSTANDARD LVCMOS25} [get_ports gpio_en_agc]                       ; ## IO_L10P_T1_AD11P_35      
set_property  -dict {PACKAGE_PIN  J19  IOSTANDARD LVCMOS25} [get_ports gpio_sync]                         ; ## IO_L10N_T1_AD11N_35      
set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS25} [get_ports gpio_resetb]                       ; ## IO_0_35                  
set_property  -dict {PACKAGE_PIN  R19  IOSTANDARD LVCMOS25} [get_ports gpio_clksel]                       ; ## IO_0_34                  

set_property  -dict {PACKAGE_PIN  M14  IOSTANDARD LVCMOS25  PULLTYPE PULLUP} [get_ports spi_csn]          ; ## IO_L23P_T3_35        
set_property  -dict {PACKAGE_PIN  M15  IOSTANDARD LVCMOS25} [get_ports spi_clk]                           ; ## IO_L23N_T3_35        
set_property  -dict {PACKAGE_PIN  K16  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                          ; ## IO_L24P_T3_AD15P_35  
set_property  -dict {PACKAGE_PIN  J16  IOSTANDARD LVCMOS25} [get_ports spi_miso]                          ; ## IO_L24N_T3_AD15N_35  

set_property  -dict {PACKAGE_PIN  J15  IOSTANDARD LVCMOS25} [get_ports clk_out]                           ; ## IO_25_35

# iic

set_property  -dict {PACKAGE_PIN  W6   IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]           ; ## IO_L22N_T3_13              
set_property  -dict {PACKAGE_PIN  V6   IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]           ; ## IO_L22P_T3_13              

# gpio

set_property  -dict {PACKAGE_PIN  Y14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]                        ; ## (pb)  IO_L8N_T1_34        
set_property  -dict {PACKAGE_PIN  T16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]                        ; ## (pb)  IO_L9P_T1_DQS_34    
set_property  -dict {PACKAGE_PIN  U17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]                        ; ## (pb)  IO_L9N_T1_DQS_34    
set_property  -dict {PACKAGE_PIN  Y19  IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]                        ; ## (led) IO_L17N_T2_34       

# clocks

create_clock -name rx_clk       -period  4 [get_ports rx_clk_in_p]
create_clock -name ad9361_clk   -period  4 [get_pins i_system_wrapper/system_i/axi_ad9361/clk]



# constraints
# ad9361

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


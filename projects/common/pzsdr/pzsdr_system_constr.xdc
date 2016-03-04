
# constraints
# ad9361

set_property  -dict {PACKAGE_PIN  G14  IOSTANDARD LVCMOS18} [get_ports enable]                            ; ## IO_L11P_T1_SRCC_35
set_property  -dict {PACKAGE_PIN  F14  IOSTANDARD LVCMOS18} [get_ports txnrx]                             ; ## IO_L11N_T1_SRCC_35

set_property  -dict {PACKAGE_PIN  D13  IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                    ; ## IO_L19P_T3_35
set_property  -dict {PACKAGE_PIN  C13  IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                    ; ## IO_L19N_T3_VREF_35
set_property  -dict {PACKAGE_PIN  C14  IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                    ; ## IO_L20P_T3_AD6P_35
set_property  -dict {PACKAGE_PIN  B14  IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                    ; ## IO_L20N_T3_AD6N_35
set_property  -dict {PACKAGE_PIN  A15  IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                    ; ## IO_L21P_T3_DQS_AD14P_35
set_property  -dict {PACKAGE_PIN  A14  IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                    ; ## IO_L21N_T3_DQS_AD14N_35
set_property  -dict {PACKAGE_PIN  C12  IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                    ; ## IO_L22P_T3_AD7P_35
set_property  -dict {PACKAGE_PIN  B12  IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                    ; ## IO_L22N_T3_AD7N_35
set_property  -dict {PACKAGE_PIN  C2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                       ; ## IO_L23P_T3_34
set_property  -dict {PACKAGE_PIN  B1   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                       ; ## IO_L23N_T3_34
set_property  -dict {PACKAGE_PIN  B2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                       ; ## IO_L24P_T3_34
set_property  -dict {PACKAGE_PIN  A2   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                       ; ## IO_L24N_T3_34
set_property  -dict {PACKAGE_PIN  G16  IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                       ; ## IO_L10P_T1_AD11P_35
set_property  -dict {PACKAGE_PIN  G15  IOSTANDARD LVCMOS18} [get_ports gpio_sync]                         ; ## IO_L10N_T1_AD11N_35
set_property  -dict {PACKAGE_PIN  H16  IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                       ; ## IO_0_VRN_35
set_property  -dict {PACKAGE_PIN  K11  IOSTANDARD LVCMOS18} [get_ports gpio_clksel]                       ; ## IO_0_VRN_34

set_property  -dict {PACKAGE_PIN  C11  IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn]          ; ## IO_L23P_T3_35
set_property  -dict {PACKAGE_PIN  B11  IOSTANDARD LVCMOS18} [get_ports spi_clk]                           ; ## IO_L23N_T3_35
set_property  -dict {PACKAGE_PIN  A13  IOSTANDARD LVCMOS18} [get_ports spi_mosi]                          ; ## IO_L24P_T3_AD15P_35
set_property  -dict {PACKAGE_PIN  A12  IOSTANDARD LVCMOS18} [get_ports spi_miso]                          ; ## IO_L24N_T3_AD15N_35

set_property  -dict {PACKAGE_PIN  K12  IOSTANDARD LVCMOS18} [get_ports clk_out]                           ; ## IO_25_VRP_35

# iic

set_property  -dict {PACKAGE_PIN  AF24 IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]           ; ## IO_L5P_T0_13             
set_property  -dict {PACKAGE_PIN  AF25 IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]           ; ## IO_L5N_T0_13             

# gpio

set_property  -dict {PACKAGE_PIN  J3   IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]                        ; ## (pb)  IO_L12N_T1_MRCC_33       
set_property  -dict {PACKAGE_PIN  D8   IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]                        ; ## (pb)  IO_L8N_T1_34             
set_property  -dict {PACKAGE_PIN  F9   IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]                        ; ## (pb)  IO_L9P_T1_DQS_34         
set_property  -dict {PACKAGE_PIN  E8   IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]                        ; ## (pb)  IO_L9N_T1_DQS_34         
set_property  -dict {PACKAGE_PIN  A8   IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]                        ; ## (led) IO_L17N_T2_34            
set_property  -dict {PACKAGE_PIN  W14  IOSTANDARD LVCMOS25} [get_ports gpio_bd[5]]                        ; ## (led) IO_0_12                  
set_property  -dict {PACKAGE_PIN  W17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]                        ; ## (led) IO_25_12                 
set_property  -dict {PACKAGE_PIN  Y16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]                        ; ## (led) IO_L23P_T3_12            
set_property  -dict {PACKAGE_PIN  Y15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]                        ; ## (dip) IO_L23N_T3_12            
set_property  -dict {PACKAGE_PIN  W16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]                        ; ## (dip) IO_L24P_T3_12            
set_property  -dict {PACKAGE_PIN  W15  IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]                       ; ## (dip) IO_L24N_T3_12            
set_property  -dict {PACKAGE_PIN  V19  IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]                       ; ## (dip) IO_0_13                  


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

# hdmi-iic

set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]       ; ## IO_L5P_T0_13             
set_property  -dict {PACKAGE_PIN  AF25  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]       ; ## IO_L5N_T0_13             

# audio

set_property  -dict {PACKAGE_PIN  J8    IOSTANDARD LVCMOS18} [get_ports i2s_mclk]                      ; ## IO_L6P_T0_34             
set_property  -dict {PACKAGE_PIN  H8    IOSTANDARD LVCMOS18} [get_ports i2s_bclk]                      ; ## IO_L6N_T0_VREF_34        
set_property  -dict {PACKAGE_PIN  F5    IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]                     ; ## IO_L7P_T1_34             
set_property  -dict {PACKAGE_PIN  E5    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]                 ; ## IO_L7N_T1_34             
set_property  -dict {PACKAGE_PIN  D9    IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]                  ; ## IO_L8P_T1_34             

# gpio

set_property  -dict {PACKAGE_PIN  J3    IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]                    ; ## (pb)  IO_L12N_T1_MRCC_33       
set_property  -dict {PACKAGE_PIN  D8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]                    ; ## (pb)  IO_L8N_T1_34             
set_property  -dict {PACKAGE_PIN  F9    IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]                    ; ## (pb)  IO_L9P_T1_DQS_34         
set_property  -dict {PACKAGE_PIN  E8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]                    ; ## (pb)  IO_L9N_T1_DQS_34         
set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]                    ; ## (led) IO_L17N_T2_34            
set_property  -dict {PACKAGE_PIN  W14   IOSTANDARD LVCMOS25} [get_ports gpio_bd[5]]                    ; ## (led) IO_0_12                  
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]                    ; ## (led) IO_25_12                 
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]                    ; ## (led) IO_L23P_T3_12            
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]                    ; ## (dip) IO_L23N_T3_12            
set_property  -dict {PACKAGE_PIN  W16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]                    ; ## (dip) IO_L24P_T3_12            
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]                   ; ## (dip) IO_L24N_T3_12            
set_property  -dict {PACKAGE_PIN  V19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]                   ; ## (dip) IO_0_13                  

# clocks

create_clock -period 8.000 -name eth1_rgmii_rxclk [get_ports eth1_rgmii_rxclk]

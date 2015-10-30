
# rf-board

set_property  -dict {PACKAGE_PIN  K10  IOSTANDARD LVCMOS18} [get_ports gpio_rfpwr_enable]              ; ## IO_25_VRP_34
set_property  -dict {PACKAGE_PIN  AA20 IOSTANDARD LVCMOS25} [get_ports gpio_rf0]                       ; ## IO_L20_13_JX2_P
set_property  -dict {PACKAGE_PIN  AB20 IOSTANDARD LVCMOS25} [get_ports gpio_rf1]                       ; ## IO_L20_13_JX2_N
set_property  -dict {PACKAGE_PIN  AA14 IOSTANDARD LVCMOS25} [get_ports gpio_rf2]                       ; ## IO_L22_12_JX2_N
set_property  -dict {PACKAGE_PIN  J9   IOSTANDARD LVCMOS18} [get_ports gpio_rf3]                       ; ## IO_L05_34_JX4_N

# tdd-sync

set_property  -dict {PACKAGE_PIN  W19  IOSTANDARD LVCMOS25} [get_ports tdd_sync]                       ; ## IO_L23_13_JX2_N

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



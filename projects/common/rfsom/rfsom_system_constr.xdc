# ethernet-1

set_property  -dict {PACKAGE_PIN  AA20  IOSTANDARD LVCMOS18} [get_ports ETH1_MDC]                      ; ## IO_L20P_T3_13            
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS18} [get_ports ETH1_MDIO]                     ; ## IO_L20N_T3_13            
set_property  -dict {PACKAGE_PIN  AD20  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxclk]              ; ## IO_L13P_T2_MRCC_13       
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxctl]              ; ## IO_L13N_T2_MRCC_13       
set_property  -dict {PACKAGE_PIN  AC23  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[0]]          ; ## IO_L12P_T1_MRCC_13       
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[1]]          ; ## IO_L12N_T1_MRCC_13       
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[2]]          ; ## IO_L11P_T1_SRCC_13       
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_rxdata[3]]          ; ## IO_L11N_T1_SRCC_13       
set_property  -dict {PACKAGE_PIN  AC18  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txclk]              ; ## IO_L21P_T3_DQS_13        
set_property  -dict {PACKAGE_PIN  AC19  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txctl]              ; ## IO_L21N_T3_DQS_13        
set_property  -dict {PACKAGE_PIN  W20   IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[0]]          ; ## IO_L19P_T3_13            
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[1]]          ; ## IO_L19N_T3_VREF_13       
set_property  -dict {PACKAGE_PIN  AE20  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[2]]          ; ## IO_L16P_T2_13            
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS18} [get_ports ETH1_RGMII_txdata[3]]          ; ## IO_L16N_T2_13            

# uart

set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS18} [get_ports UART0_rxd]                     ; ## IO_L23N_T3_12
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS18} [get_ports UART0_txd]                     ; ## IO_L23P_T3_12

# hdmi

set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS18} [get_ports hdmi_out_clk]                  ; ## IO_L14P_T2_SRCC_12       
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS18} [get_ports hdmi_vsync]                    ; ## IO_L22N_T3_12            
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVCMOS18} [get_ports hdmi_hsync]                    ; ## IO_L22P_T3_12            
set_property  -dict {PACKAGE_PIN  AB14  IOSTANDARD LVCMOS18} [get_ports hdmi_data_e]                   ; ## IO_L14N_T2_SRCC_12       
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD LVCMOS18} [get_ports hdmi_data[0]]                  ; ## IO_L1P_T0_12             
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS18} [get_ports hdmi_data[1]]                  ; ## IO_L1N_T0_12             
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS18} [get_ports hdmi_data[2]]                  ; ## IO_L2P_T0_12             
set_property  -dict {PACKAGE_PIN  AC11  IOSTANDARD LVCMOS18} [get_ports hdmi_data[3]]                  ; ## IO_L2N_T0_12             
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVCMOS18} [get_ports hdmi_data[4]]                  ; ## IO_L3P_T0_DQS_12         
set_property  -dict {PACKAGE_PIN  AA10  IOSTANDARD LVCMOS18} [get_ports hdmi_data[5]]                  ; ## IO_L3N_T0_DQS_12         
set_property  -dict {PACKAGE_PIN  AB11  IOSTANDARD LVCMOS18} [get_ports hdmi_data[6]]                  ; ## IO_L4P_T0_12             
set_property  -dict {PACKAGE_PIN  AB10  IOSTANDARD LVCMOS18} [get_ports hdmi_data[7]]                  ; ## IO_L4N_T0_12             
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS18} [get_ports hdmi_data[8]]                  ; ## IO_L5P_T0_12             
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS18} [get_ports hdmi_data[9]]                  ; ## IO_L5N_T0_12             
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[10]]                 ; ## IO_L6P_T0_12             
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS18} [get_ports hdmi_data[11]]                 ; ## IO_L6N_T0_VREF_12        
set_property  -dict {PACKAGE_PIN  AE10  IOSTANDARD LVCMOS18} [get_ports hdmi_data[12]]                 ; ## IO_L7P_T1_12             
set_property  -dict {PACKAGE_PIN  AD10  IOSTANDARD LVCMOS18} [get_ports hdmi_data[13]]                 ; ## IO_L7N_T1_12             
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVCMOS18} [get_ports hdmi_data[14]]                 ; ## IO_L8P_T1_12             
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVCMOS18} [get_ports hdmi_data[15]]                 ; ## IO_L8N_T1_12             

# hdmi-spdif

set_property  -dict {PACKAGE_PIN  AE11  IOSTANDARD LVCMOS18} [get_ports spdif]                         ; ## IO_L9P_T1_DQS_12         

# hdmi-iic

set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_scl[0]]    ; ## IO_L10P_T1_13            
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_sda[0]]    ; ## IO_L10N_T1_13            

# audio

set_property  -dict {PACKAGE_PIN  Y17   IOSTANDARD LVCMOS18} [get_ports i2s_mclk]                      ; ## IO_L19P_T3_12            
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS18} [get_ports i2s_bclk]                      ; ## IO_L20P_T3_12            
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]                     ; ## IO_L19N_T3_VREF_12       
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]                 ; ## IO_L20N_T3_12            
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]                  ; ## IO_L21P_T3_DQS_12        

# audio-iic

set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_scl[1]]    ; ## IO_L14P_T2_SRCC_13
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS18 PULLTYPE PULLUP} [get_ports iic_sda[1]]    ; ## IO_L14N_T2_SRCC_13



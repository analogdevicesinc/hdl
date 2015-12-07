

set_property  -dict {PACKAGE_PIN L18  IOSTANDARD LVCMOS25}  [get_ports clk_in]              ; ## H04  FMC_LPC_CLK0_M2C_P IO_L12P_T1_MRCC_34 
set_property  -dict {PACKAGE_PIN M19  IOSTANDARD LVCMOS25}  [get_ports ready_in]            ; ## G06  FMC_LPC_LA00_CC_P  IO_L13P_T2_MRCC_34 
set_property  -dict {PACKAGE_PIN M20  IOSTANDARD LVCMOS25}  [get_ports data_in[0]]          ; ## G07  FMC_LPC_LA00_CC_N  IO_L13N_T2_MRCC_34 
set_property  -dict {PACKAGE_PIN L22  IOSTANDARD LVCMOS25}  [get_ports data_in[1]]          ; ## C11  FMC_LPC_LA06_N     IO_L10N_T1_34      
set_property  -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS25}  [get_ports data_in[2]]          ; ## H07  FMC_LPC_LA02_P     IO_L20P_T3_34      
set_property  -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS25}  [get_ports data_in[3]]          ; ## H08  FMC_LPC_LA02_N     IO_L20N_T3_34      
set_property  -dict {PACKAGE_PIN J21  IOSTANDARD LVCMOS25}  [get_ports data_in[4]]          ; ## G12  FMC_LPC_LA08_P     IO_L8P_T1_34       
set_property  -dict {PACKAGE_PIN J22  IOSTANDARD LVCMOS25}  [get_ports data_in[5]]          ; ## G13  FMC_LPC_LA08_N     IO_L8N_T1_34       
set_property  -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS25}  [get_ports data_in[6]]          ; ## D14  FMC_LPC_LA09_P     IO_L17P_T2_34      
set_property  -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS25}  [get_ports data_in[7]]          ; ## D15  FMC_LPC_LA09_N     IO_L17N_T2_34      
set_property  -dict {PACKAGE_PIN J18  IOSTANDARD LVCMOS25}  [get_ports spi_csn]             ; ## D11  FMC_LPC_LA05_P     IO_L7P_T1_34       
set_property  -dict {PACKAGE_PIN N19  IOSTANDARD LVCMOS25}  [get_ports spi_clk]             ; ## D08  FMC_LPC_LA01_CC_P  IO_L14P_T2_SRCC_34 
set_property  -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS25}  [get_ports spi_mosi]            ; ## H11  FMC_LPC_LA04_N     IO_L15N_T2_DQS_34  
set_property  -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS25}  [get_ports spi_miso]            ; ## G09  FMC_LPC_LA03_P     IO_L16P_T2_34      
set_property  -dict {PACKAGE_PIN T19  IOSTANDARD LVCMOS25}  [get_ports gpio_0_mode_0]       ; ## C15  FMC_LPC_LA10_N     IO_L22N_T3_34             
set_property  -dict {PACKAGE_PIN T16  IOSTANDARD LVCMOS25}  [get_ports gpio_1_mode_1]       ; ## H13  FMC_LPC_LA07_P     IO_L21P_T3_DQS_34         
set_property  -dict {PACKAGE_PIN T17  IOSTANDARD LVCMOS25}  [get_ports gpio_2_mode_2]       ; ## H14  FMC_LPC_LA07_N     IO_L21N_T3_DQS_34         
set_property  -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS25}  [get_ports gpio_3_mode_3]       ; ## H16  FMC_LPC_LA11_P     IO_L5P_T0_34              
set_property  -dict {PACKAGE_PIN R19  IOSTANDARD LVCMOS25}  [get_ports gpio_4_filter]       ; ## C14  FMC_LPC_LA10_P     IO_L22P_T3_34             
set_property  -dict {PACKAGE_PIN L21  IOSTANDARD LVCMOS25}  [get_ports reset_n]             ; ## C10  FMC_LPC_LA06_P     IO_L10P_T1_34             
set_property  -dict {PACKAGE_PIN P22  IOSTANDARD LVCMOS25}  [get_ports start_n]             ; ## G10  FMC_LPC_LA03_N     IO_L16N_T2_34             
set_property  -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS25}  [get_ports sync_n]              ; ## H10  FMC_LPC_LA04_P     IO_L15P_T2_DQS_34         
set_property  -dict {PACKAGE_PIN K18  IOSTANDARD LVCMOS25}  [get_ports sync_in_n]           ; ## D12  FMC_LPC_LA05_N     IO_L7N_T1_34              
set_property  -dict {PACKAGE_PIN N20  IOSTANDARD LVCMOS25}  [get_ports mclk]                ; ## D09  FMC_LPC_LA01_CC_N  IO_L14N_T2_SRCC_34        

create_clock -name adc_clk -period 20 [get_ports clk_in]


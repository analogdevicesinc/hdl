
# constraints
# ultrasound 

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p]                              ; ## D04  FMC_HPC_GBTCLK0_M2C_P      
set_property  -dict {PACKAGE_PIN  AD9}  [get_ports rx_ref_clk_n]                              ; ## D05  FMC_HPC_GBTCLK0_M2C_N      
set_property  -dict {PACKAGE_PIN  AE8}  [get_ports rx_data_p[0]]                              ; ## A10  FMC_HPC_DP3_M2C_P          
set_property  -dict {PACKAGE_PIN  AE7}  [get_ports rx_data_n[0]]                              ; ## A11  FMC_HPC_DP3_M2C_N          
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[1]]                              ; ## C06  FMC_HPC_DP0_M2C_P          
set_property  -dict {PACKAGE_PIN  AH9}  [get_ports rx_data_n[1]]                              ; ## C07  FMC_HPC_DP0_M2C_N          
set_property  -dict {PACKAGE_PIN  AG8}  [get_ports rx_data_p[2]]                              ; ## A06  FMC_HPC_DP2_M2C_P          
set_property  -dict {PACKAGE_PIN  AG7}  [get_ports rx_data_n[2]]                              ; ## A07  FMC_HPC_DP2_M2C_N          
set_property  -dict {PACKAGE_PIN  AJ8}  [get_ports rx_data_p[3]]                              ; ## A02  FMC_HPC_DP1_M2C_P          
set_property  -dict {PACKAGE_PIN  AJ7}  [get_ports rx_data_n[3]]                              ; ## A03  FMC_HPC_DP1_M2C_N          
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25} [get_ports rx_sysref_p]           ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25} [get_ports rx_sysref_n]           ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_p]             ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_n]             ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports reset_ad9516]         ; ## G15  FMC_HPC_LA12_P    
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS25} [get_ports reset_ad9671]         ; ## C27  FMC_HPC_LA27_N    
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports trig]                 ; ## H17  FMC_HPC_LA11_N    
set_property  -dict {PACKAGE_PIN  AC24  IOSTANDARD LVCMOS25} [get_ports prci_sck]             ; ## C18  FMC_HPC_LA14_P    
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports prci_cnv]             ; ## C14  FMC_HPC_LA10_P    
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25} [get_ports prci_sdo]             ; ## C22  FMC_HPC_LA18_CC_P 
set_property  -dict {PACKAGE_PIN  AD24  IOSTANDARD LVCMOS25} [get_ports prcq_sck]             ; ## C19  FMC_HPC_LA14_N    
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports prcq_cnv]             ; ## C15  FMC_HPC_LA10_N    
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25} [get_ports prcq_sdo]             ; ## C23  FMC_HPC_LA18_CC_N 

set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVCMOS25} [get_ports spi_ad9671_csn]       ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_ad9671_clk]       ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_ad9671_sdio]      ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports spi_ad9516_csn]       ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports spi_ad9516_clk]       ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports spi_ad9516_sdio]      ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports spi_ad9553_csn]       ; ## G10  FMC_HPC_LA03_N
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports spi_ad9553_clk]       ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports spi_ad9553_sdio]      ; ## H13  FMC_HPC_LA07_P

# clocks

create_clock -name rx_ref_clk   -period 12.50 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period 12.50 [get_nets i_system_wrapper/system_i/axi_ad9671_gt_rx_clk]
create_clock -name fmc_dma_clk  -period  5.00 [get_pins i_system_wrapper/system_i/sys_ps7/FCLK_CLK2]

set_clock_groups -asynchronous -group {rx_div_clk}
set_clock_groups -asynchronous -group {fmc_dma_clk}

set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_drp_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_gt_pll_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_gt_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_gt_tx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9671_gt/inst/i_up_gt/i_tx_rst_reg/i_rst_reg/PRE]

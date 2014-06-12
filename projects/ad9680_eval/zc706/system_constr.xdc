
# ad9680

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AE8 } [get_ports rx_data_p[0]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AE7 } [get_ports rx_data_n[0]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AG8 } [get_ports rx_data_p[1]]                                      ; ## A6   FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AG7 } [get_ports rx_data_n[1]]                                      ; ## A7   FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AH10} [get_ports rx_data_p[2]]                                      ; ## C6   FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AH9 } [get_ports rx_data_n[2]]                                      ; ## C7   FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AJ8 } [get_ports rx_data_p[3]]                                      ; ## A2   FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AJ7 } [get_ports rx_data_n[3]]                                      ; ## A3   FMC_HPC_DP1_M2C_N

set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## H10  FMC_HPC_LA04_P 
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## H11  FMC_HPC_LA04_N 
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## D11  FMC_HPC_LA05_P 
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## D12  FMC_HPC_LA05_N 

set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_csn]                      ; ## C10  FMC_HPC_LA06_P    
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D8   FMC_HPC_LA01_CC_P 
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## H7   FMC_HPC_LA02_P    

# clocks

create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  4.00 [get_nets i_system_wrapper/system_i/axi_ad9680_gt_rx_clk]
create_clock -name fmc_dma_clk  -period  5.00 [get_pins i_system_wrapper/system_i/sys_ps7/FCLK_CLK2]

set_clock_groups -asynchronous -group {rx_div_clk}
set_clock_groups -asynchronous -group {fmc_dma_clk}

set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_drp_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_gt_pll_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_gt_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_gt_tx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9680_gt/inst/i_up_gt/i_tx_rst_reg/i_rst_reg/PRE]


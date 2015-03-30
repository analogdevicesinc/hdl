
# ad9250

set_property  -dict {PACKAGE_PIN  A10 } [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9  } [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  D8}   [get_ports rx_data_p[0]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  D7}   [get_ports rx_data_n[0]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  C6 }  [get_ports rx_data_p[1]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  C5 }  [get_ports rx_data_n[1]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  B8 }  [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  B7 }  [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  A6 }  [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  A5 }  [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  U31   IOSTANDARD LVCMOS18} [get_ports rx_sync]                      ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  T31   IOSTANDARD LVCMOS18} [get_ports rx_sysref]                    ; ## G37  FMC_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  M29   IOSTANDARD LVCMOS18} [get_ports spi_csn_0]                    ; ## G34  FMC_HPC_LA31_N
set_property  -dict {PACKAGE_PIN  M28   IOSTANDARD LVCMOS18} [get_ports spi_clk]                      ; ## G33  FMC_HPC_LA31_P
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS18} [get_ports spi_sdio]                     ; ## H37  FMC_HPC_LA32_P

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  8.80 [get_nets i_system_wrapper/system_i/axi_ad9250_gt_rx_clk]

set_clock_groups -asynchronous -group {rx_div_clk}

set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_drp_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_gt_pll_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_gt_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_gt_tx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_rx_rst_reg/i_rst_reg/PRE]
set_false_path -through [get_pins i_system_wrapper/system_i/axi_ad9250_gt/inst/i_up_gt/i_tx_rst_reg/i_rst_reg/PRE]

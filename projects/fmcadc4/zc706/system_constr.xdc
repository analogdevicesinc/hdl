
# fmcadc4

set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVDS_25} [get_ports rx_sync_0_p]                   ; ## G15  FMC_HPC_LA12_P             
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVDS_25} [get_ports rx_sync_0_n]                   ; ## G16  FMC_HPC_LA12_N             
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_1_p]                   ; ## H10  FMC_HPC_LA04_P             
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_1_n]                   ; ## H11  FMC_HPC_LA04_N             
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## D08  FMC_HPC_LA01_CC_P          
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## D09  FMC_HPC_LA01_CC_N          

set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports ad9528_csn]                   ; ## G13  FMC_HPC_LA08_N             
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports ada4961_1a_csn]               ; ## G09  FMC_HPC_LA03_P             
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports ada4961_1b_csn]               ; ## G10  FMC_HPC_LA03_N             
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports ad9680_1_csn]                 ; ## H13  FMC_HPC_LA07_P             
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports ada4961_2a_csn]               ; ## C10  FMC_HPC_LA06_P             
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports ada4961_2b_csn]               ; ## C11  FMC_HPC_LA06_N             
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports ad9680_2_csn]                 ; ## H14  FMC_HPC_LA07_N             
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D18  FMC_HPC_LA13_N             
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D17  FMC_HPC_LA13_P             

set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports ad9528_rstn]                  ; ## D15  FMC_HPC_LA09_N             
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports ad9528_status]                ; ## D14  FMC_HPC_LA09_P             
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports ad9680_1_fda]                 ; ## C14  FMC_HPC_LA10_P             
set_property  -dict {PACKAGE_PIN  AG25  IOSTANDARD LVCMOS25} [get_ports ad9680_1_fdb]                 ; ## C15  FMC_HPC_LA10_N             
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports ad9680_2_fda]                 ; ## H16  FMC_HPC_LA11_P             
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports ad9680_2_fdb]                 ; ## H17  FMC_HPC_LA11_N             

# clocks

create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_fmcadc4_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc4_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[5]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[7]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[6]    A06/A07   FMC_HPC_DP2_M2C   AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[4]    A10/A11   FMC_HPC_DP3_M2C   AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# rx_data[0]    A14/A15   FMC_HPC_DP4_M2C   AH6/AH5   rx_data[4]  GTXE2_CHANNEL_X0Y4
# rx_data[1]    A18/A19   FMC_HPC_DP5_M2C   AG4/AG3   rx_data[5]  GTXE2_CHANNEL_X0Y5
# rx_data[2]    B16/B17   FMC_HPC_DP6_M2C   AF6/AF5   rx_data[6]  GTXE2_CHANNEL_X0Y6
# rx_data[3]    B12/B13   FMC_HPC_DP7_M2C   AD6/AD5   rx_data[7]  GTXE2_CHANNEL_X0Y7
# -----------------------------------------------------------------------------------


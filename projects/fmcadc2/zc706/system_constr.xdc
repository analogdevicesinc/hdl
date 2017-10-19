
# ad9625

set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## D12  FMC_HPC_LA05_N

set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVCMOS25} [get_ports spi_adc_csn]                  ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVCMOS25} [get_ports spi_adc_clk]                  ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVCMOS25} [get_ports spi_adc_sdio]                 ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_data_or_csn_0]    ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_clk_or_csn_1]     ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_le_or_clk]        ; ## G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVCMOS25} [get_ports spi_adf4355_ce_or_sdio]       ; ## G07  FMC_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports adc_irq]                      ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports adc_fd]                       ; ## G10  FMC_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/axi_ad9625_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[0]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9 rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[1]    A02/A03   FMC_HPC_DP1_M2C   AJ8 /AJ7 rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   AG8 /AG7 rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   AE8 /AE7 rx_data[3]  GTXE2_CHANNEL_X0Y3
# rx_data[5]    A14/A15   FMC_HPC_DP4_M2C   AH6 /AH5 rx_data[4]  GTXE2_CHANNEL_X0Y4
# rx_data[7]    A18/A19   FMC_HPC_DP5_M2C   AG4 /AG3 rx_data[5]  GTXE2_CHANNEL_X0Y5
# rx_data[6]    B16/B17   FMC_HPC_DP6_M2C   AF6 /AF5 rx_data[6]  GTXE2_CHANNEL_X0Y6
# rx_data[4]    B12/B13   FMC_HPC_DP7_M2C   AD6 /AD5 rx_data[7]  GTXE2_CHANNEL_X0Y7
# -----------------------------------------------------------------------------------

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]


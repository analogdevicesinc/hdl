
# ad9625

set_property  -dict {PACKAGE_PIN  H40   IOSTANDARD LVDS} [get_ports rx_sync_p]                          ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  H41   IOSTANDARD LVDS} [get_ports rx_sync_n]                          ; ## H11  FMC1_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  M41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_p]         ; ## D11  FMC1_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_sysref_n]         ; ## D12  FMC1_HPC_LA05_N

set_property  -dict {PACKAGE_PIN  N41  IOSTANDARD LVCMOS18} [get_ports spi_adc_csn]                     ; ## H08  FMC1_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  J40  IOSTANDARD LVCMOS18} [get_ports spi_adc_clk]                     ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41  IOSTANDARD LVCMOS18} [get_ports spi_adc_sdio]                    ; ## D09  FMC1_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  P41  IOSTANDARD LVCMOS18} [get_ports spi_adf4355_data_or_csn_0]       ; ## H07  FMC1_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  K42  IOSTANDARD LVCMOS18} [get_ports spi_adf4355_clk_or_csn_1]        ; ## C10  FMC1_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  K39  IOSTANDARD LVCMOS18} [get_ports spi_adf4355_le_or_clk]           ; ## G06  FMC1_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  K40  IOSTANDARD LVCMOS18} [get_ports spi_adf4355_ce_or_sdio]          ; ## G07  FMC1_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  M42  IOSTANDARD LVCMOS18} [get_ports adc_irq]                         ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  L42  IOSTANDARD LVCMOS18} [get_ports adc_fd]                          ; ## G10  FMC1_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/axi_ad9625_xcvr_rx_bufg/U0/BUFG_O]

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]
set_property IOB false [get_cells -hierarchical -filter {name =~ *SCK_O_NE_4_FDRE_INST}]

# reference clocks

set_property  -dict {PACKAGE_PIN  A10 } [get_ports rx_ref_clk_p] ; ## D04  FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9  } [get_ports rx_ref_clk_n] ; ## D05  FMC1_HPC_GBTCLK0_M2C_N

# xcvr channels

set_property LOC GTXE2_CHANNEL_X1Y20 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y21 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y22 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y23 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y24 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y25 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y26 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y27 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[5]    A14/A15   FMC_HPC_DP4_M2C   H8/H7 rx_data[0]      GTXE2_CHANNEL_X1Y20
# rx_data[7]    A18/A19   FMC_HPC_DP5_M2C   G6/G5 rx_data[1]      GTXE2_CHANNEL_X1Y21
# rx_data[6]    B16/B17   FMC_HPC_DP6_M2C   F8/F7 rx_data[2]      GTXE2_CHANNEL_X1Y22
# rx_data[4]    B12/B13   FMC_HPC_DP7_M2C   E6/E5 rx_data[3]      GTXE2_CHANNEL_X1Y23
# rx_data[0]    C06/C07   FMC_HPC_DP0_M2C   D8/D7 rx_data[4]      GTXE2_CHANNEL_X1Y24
# rx_data[1]    A02/A03   FMC_HPC_DP1_M2C   C6/C5 rx_data[5]      GTXE2_CHANNEL_X1Y25
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   B8/B7 rx_data[6]      GTXE2_CHANNEL_X1Y26
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   A6/A5 rx_data[7]      GTXE2_CHANNEL_X1Y27
# -----------------------------------------------------------------------------------


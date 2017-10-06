
# daq2

set_property  -dict {PACKAGE_PIN  D26 IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  C26 IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  H26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  H27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  H24 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  H25 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  G28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_p]    ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  F28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_n]    ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  G29 IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  D29 IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                  ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  A30 IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                  ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  F30 IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  B30 IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  E30 IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## G13  FMC_HPC_LA08_N

set_property  -dict {PACKAGE_PIN  E29 IOSTANDARD LVCMOS25} [get_ports clkd_sync]                    ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  C30 IOSTANDARD LVCMOS25} [get_ports dac_reset]                    ; ## C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  B29 IOSTANDARD LVCMOS25} [get_ports dac_txen]                     ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  H30 IOSTANDARD LVCMOS25} [get_ports adc_pd]                       ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  A25 IOSTANDARD LVCMOS25} [get_ports clkd_status[0]]               ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  A26 IOSTANDARD LVCMOS25} [get_ports clkd_status[1]]               ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  C29 IOSTANDARD LVCMOS25} [get_ports dac_irq]                      ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  G27 IOSTANDARD LVCMOS25} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  F27 IOSTANDARD LVCMOS25} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  E28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_p]         ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  D28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_n]         ; ## H14  FMC_HPC_LA07_N

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_xcvr_tx_bufg/U0/BUFG_O]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  C8} [get_ports tx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  C7} [get_ports tx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  E8} [get_ports rx_ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  E7} [get_ports rx_ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y12 [get_cells -hierarchical -filter {NAME =~ *axi_daq2_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y13 [get_cells -hierarchical -filter {NAME =~ *axi_daq2_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y14 [get_cells -hierarchical -filter {NAME =~ *axi_daq2_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y15 [get_cells -hierarchical -filter {NAME =~ *axi_daq2_xcvr*gt3*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[1]    C06/C07   FMC_HPC_DP0_M2C   E4/E3     rx_data[0]  GTXE2_CHANNEL_X0Y12
# rx_data[3]    A02/A03   FMC_HPC_DP1_M2C   D6/D5     rx_data[1]  GTXE2_CHANNEL_X0Y13
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   B6/B5     rx_data[2]  GTXE2_CHANNEL_X0Y14
# rx_data[0]    A10/A11   FMC_HPC_DP3_M2C   A8/A7     rx_data[3]  GTXE2_CHANNEL_X0Y15
# -----------------------------------------------------------------------------------
# tx_data[3]    C02/C03   FMC_HPC_DP0_C2M   D2/D1     tx_data[0]  GTXE2_CHANNEL_X0Y12
# tx_data[2]    A22/A23   FMC_HPC_DP1_C2M   C4/C3     tx_data[1]  GTXE2_CHANNEL_X0Y13
# tx_data[1]    A26/A27   FMC_HPC_DP2_C2M   B2/B1     tx_data[2]  GTXE2_CHANNEL_X0Y14
# tx_data[0]    A30/A31   FMC_HPC_DP3_C2M   A4/A3     tx_data[3]  GTXE2_CHANNEL_X0Y15
# -----------------------------------------------------------------------------------



# daq3

set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_p]      ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync_n]      ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_p]    ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_n]    ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                  ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                  ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## C11  FMC_HPC_LA06_N

set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVDS_25}  [get_ports sysref_p]                     ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVDS_25}  [get_ports sysref_n]                     ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports dac_txen]                     ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports adc_pd]                       ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports clkd_status[0]]               ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports clkd_status[1]]               ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports dac_irq]                      ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_p]         ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_n]         ; ## H14  FMC_HPC_LA07_N

# clocks

create_clock -name tx_ref_clk   -period  1.60 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  3.20 [get_pins i_system_wrapper/system_i/axi_daq3_xcvr_tx_bufg/U0/BUFG_O]
create_clock -name rx_div_clk   -period  3.20 [get_pins i_system_wrapper/system_i/axi_daq3_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports tx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports tx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AA8 } [get_ports rx_ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P (IBUFDS_GTE2_X0Y2)
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports rx_ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N (IBUFDS_GTE2_X0Y2)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_daq3_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_daq3_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_daq3_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_daq3_xcvr*gt3*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[1]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[3]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[0]    A10/A11   FMC_HPC_DP3_M2C   AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------
# tx_data[3]    C02/C03   FMC_HPC_DP0_C2M   AK10/AK9  tx_data[0]  GTXE2_CHANNEL_X0Y0
# tx_data[2]    A22/A23   FMC_HPC_DP1_C2M   AK6/AK5   tx_data[1]  GTXE2_CHANNEL_X0Y1
# tx_data[1]    A26/A27   FMC_HPC_DP2_C2M   AJ4/AJ3   tx_data[2]  GTXE2_CHANNEL_X0Y2
# tx_data[0]    A30/A31   FMC_HPC_DP3_C2M   AK2/AK1   tx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------


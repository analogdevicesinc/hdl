# fmcomms7

set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync0_p]     ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync0_n]     ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  Y22   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync1_p]     ; ## H19  FMC_HPC_LA15_P
set_property  -dict {PACKAGE_PIN  Y23   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sync1_n]     ; ## H20  FMC_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_p]    ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports tx_sysref_n]    ; ## H11  FMC_HPC_LA04_N

# spi (clock, dac and adc only & sdio)

set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                  ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  AG24  IOSTANDARD LVCMOS25} [get_ports spi_csn_dac]                  ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AE21  IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                  ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AD21  IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports spi_dir]                      ; ## C10  FMC_HPC_LA06_P

# spi (others, sdi and/or sdo)

set_property  -dict {PACKAGE_PIN  T24   IOSTANDARD LVCMOS25} [get_ports spi2_csn_adf4355_1]           ; ## H22  FMC_HPC_LA19_P
set_property  -dict {PACKAGE_PIN  T25   IOSTANDARD LVCMOS25} [get_ports spi2_csn_adf4355_2]           ; ## H23  FMC_HPC_LA19_N
set_property  -dict {PACKAGE_PIN  W29   IOSTANDARD LVCMOS25} [get_ports spi2_csn_hmc1044_1]           ; ## H25  FMC_HPC_LA21_P
set_property  -dict {PACKAGE_PIN  W30   IOSTANDARD LVCMOS25} [get_ports spi2_csn_hmc1044_2]           ; ## H26  FMC_HPC_LA21_N
set_property  -dict {PACKAGE_PIN  AB24  IOSTANDARD LVCMOS25} [get_ports spi2_csn_hmc1044_3]           ; ## G19  FMC_HPC_LA16_N
set_property  -dict {PACKAGE_PIN  V23   IOSTANDARD LVCMOS25} [get_ports spi2_csn_adl5240_1]           ; ## D20  FMC_HPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN  W24   IOSTANDARD LVCMOS25} [get_ports spi2_csn_adl5240_2]           ; ## D21  FMC_HPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN  U25   IOSTANDARD LVCMOS25} [get_ports spi2_csn_hmc271_1]            ; ## G21  FMC_HPC_LA20_P
set_property  -dict {PACKAGE_PIN  V26   IOSTANDARD LVCMOS25} [get_ports spi2_csn_hmc271_2]            ; ## G22  FMC_HPC_LA20_N
set_property  -dict {PACKAGE_PIN  V28   IOSTANDARD LVCMOS25} [get_ports spi2_clk]                     ; ## C26  FMC_HPC_LA27_P
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS25} [get_ports spi2_sdo]                     ; ## C27  FMC_HPC_LA27_N
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS25} [get_ports spi2_sdi_hmc271_1]            ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AA23  IOSTANDARD LVCMOS25} [get_ports spi2_sdi_hmc271_2]            ; ## D18  FMC_HPC_LA13_N

# external trigger

set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_p]         ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports trig_n]         ; ## H14  FMC_HPC_LA07_N

# clock gpio

set_property  -dict {PACKAGE_PIN  T29   IOSTANDARD LVCMOS25} [get_ports clk_gpio[0]]                  ; ## G27  FMC_HPC_LA25_P
set_property  -dict {PACKAGE_PIN  U29   IOSTANDARD LVCMOS25} [get_ports clk_gpio[1]]                  ; ## G28  FMC_HPC_LA25_N
set_property  -dict {PACKAGE_PIN  T30   IOSTANDARD LVCMOS25} [get_ports clk_gpio[2]]                  ; ## H28  FMC_HPC_LA24_P
set_property  -dict {PACKAGE_PIN  U30   IOSTANDARD LVCMOS25} [get_ports clk_gpio[3]]                  ; ## H29  FMC_HPC_LA24_N

# status

set_property  -dict {PACKAGE_PIN  AD23  IOSTANDARD LVCMOS25} [get_ports adc_fda]                      ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AE23  IOSTANDARD LVCMOS25} [get_ports adc_fdb]                      ; ## H17  FMC_HPC_LA11_N
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports dac_irq]                      ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  R28   IOSTANDARD LVCMOS25} [get_ports adf4355_1_ld]                 ; ## D26  FMC_HPC_LA26_P
set_property  -dict {PACKAGE_PIN  T28   IOSTANDARD LVCMOS25} [get_ports adf4355_2_ld]                 ; ## D27  FMC_HPC_LA26_N

# control

set_property  -dict {PACKAGE_PIN  AA24  IOSTANDARD LVCMOS25} [get_ports xo_en]                        ; ## G18  FMC_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports clk_sync]                     ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  W25   IOSTANDARD LVCMOS25} [get_ports adf4355_2_pd]                 ; ## C22  FMC_HPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN  AF23  IOSTANDARD LVCMOS25} [get_ports dac_txen0]                    ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  AF24  IOSTANDARD LVCMOS25} [get_ports dac_txen1]                    ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  V27   IOSTANDARD LVCMOS25} [get_ports hmc271_1_reset]               ; ## G24  FMC_HPC_LA22_P
set_property  -dict {PACKAGE_PIN  W28   IOSTANDARD LVCMOS25} [get_ports hmc271_2_reset]               ; ## G25  FMC_HPC_LA22_N
set_property  -dict {PACKAGE_PIN  W26   IOSTANDARD LVCMOS25} [get_ports hmc349_sel]                   ; ## C23  FMC_HPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN  P25   IOSTANDARD LVCMOS25} [get_ports hmc922_a]                     ; ## D23  FMC_HPC_LA23_P
set_property  -dict {PACKAGE_PIN  P26   IOSTANDARD LVCMOS25} [get_ports hmc922_b]                     ; ## D24  FMC_HPC_LA23_N

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_fmcomms7_xcvr_tx_bufg/U0/BUFG_O]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_fmcomms7_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AA8 } [get_ports rx_ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AA7 } [get_ports rx_ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N
set_property  -dict {PACKAGE_PIN  AD10} [get_ports tx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports tx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *axi_fmcomms7_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[1]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[3]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[0]    A10/A11   FMC_HPC_DP3_M2C   AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------
# tx_data[3]    C02/C03   FMC_HPC_DP0_C2M   AK10/AK9  tx_data[0]  GTXE2_CHANNEL_X0Y0
# tx_data[7]    A22/A23   FMC_HPC_DP1_C2M   AK6/AK5   tx_data[1]  GTXE2_CHANNEL_X0Y1
# tx_data[6]    A26/A27   FMC_HPC_DP2_C2M   AJ4/AJ3   tx_data[2]  GTXE2_CHANNEL_X0Y2
# tx_data[5]    A30/A31   FMC_HPC_DP3_C2M   AK2/AK1   tx_data[3]  GTXE2_CHANNEL_X0Y3
# tx_data[2]    A34/A35   FMC_HPC_DP4_C2M   AH2/AH1   tx_data[4]  GTXE2_CHANNEL_X0Y4
# tx_data[0]    A38/A39   FMC_HPC_DP5_C2M   AF2/AF1   tx_data[5]  GTXE2_CHANNEL_X0Y5
# tx_data[1]    B36/B37   FMC_HPC_DP6_C2M   AE4/AE3   tx_data[6]  GTXE2_CHANNEL_X0Y6
# tx_data[4]    B32/B33   FMC_HPC_DP7_C2M   AD2/AD1   tx_data[7]  GTXE2_CHANNEL_X0Y7
# -----------------------------------------------------------------------------------


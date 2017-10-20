
# ad9625

set_property  -dict {PACKAGE_PIN  K39   IOSTANDARD LVDS} [get_ports rx_sysref_p]                  ; ## G06  FMC1_HPC_LA00_CC_P       
set_property  -dict {PACKAGE_PIN  K40   IOSTANDARD LVDS} [get_ports rx_sysref_n]                  ; ## G07  FMC1_HPC_LA00_CC_N       
set_property  -dict {PACKAGE_PIN  J40   IOSTANDARD LVDS} [get_ports rx_sync_0_p]                  ; ## D08  FMC1_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  J41   IOSTANDARD LVDS} [get_ports rx_sync_0_n]                  ; ## D09  FMC1_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  P41   IOSTANDARD LVDS} [get_ports rx_sync_1_p]                  ; ## H07  FMC1_HPC_LA02_P       
set_property  -dict {PACKAGE_PIN  N41   IOSTANDARD LVDS} [get_ports rx_sync_1_n]                  ; ## H08  FMC1_HPC_LA02_N       

set_property  -dict {PACKAGE_PIN  M41   IOSTANDARD LVCMOS18} [get_ports spi_csn_0]                ; ## D11  FMC1_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  L41   IOSTANDARD LVCMOS18} [get_ports spi_csn_1]                ; ## D12  FMC1_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  N38   IOSTANDARD LVCMOS18} [get_ports spi_clk]                  ; ## C14  FMC1_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  M39   IOSTANDARD LVCMOS18} [get_ports spi_sdio]                 ; ## C15  FMC1_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  M36   IOSTANDARD LVCMOS18} [get_ports spi_dirn]                 ; ## H19  FMC1_HPC_LA15_P

set_property  -dict {PACKAGE_PIN  G41   IOSTANDARD LVCMOS18} [get_ports pwdn_0]                   ; ## H13  FMC1_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  K42   IOSTANDARD LVCMOS18} [get_ports rst_0]                    ; ## C10  FMC1_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  M37   IOSTANDARD LVCMOS18} [get_ports drst_0]                   ; ## G12  FMC1_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  R42   IOSTANDARD LVCMOS18} [get_ports arst_0]                   ; ## D14  FMC1_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  H40   IOSTANDARD LVCMOS18} [get_ports fd_0]                     ; ## H10  FMC1_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  M42   IOSTANDARD LVCMOS18} [get_ports irq_0]                    ; ## G09  FMC1_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  G42   IOSTANDARD LVCMOS18} [get_ports pwdn_1]                   ; ## H14  FMC1_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  J42   IOSTANDARD LVCMOS18} [get_ports rst_1]                    ; ## C11  FMC1_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  M38   IOSTANDARD LVCMOS18} [get_ports drst_1]                   ; ## G13  FMC1_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  P42   IOSTANDARD LVCMOS18} [get_ports arst_1]                   ; ## D15  FMC1_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  H41   IOSTANDARD LVCMOS18} [get_ports fd_1]                     ; ## H11  FMC1_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  L42   IOSTANDARD LVCMOS18} [get_ports irq_1]                    ; ## G10  FMC1_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  L37   IOSTANDARD LVCMOS18} [get_ports pwr_good]                 ; ## H20  FMC1_HPC_LA15_N
set_property  -dict {PACKAGE_PIN  F40   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports trig_p]        ; ## H16  FMC1_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  F41   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports trig_n]        ; ## H17  FMC1_HPC_LA11_N
set_property  -dict {PACKAGE_PIN  K37   IOSTANDARD LVDS} [get_ports vdither_p]                    ; ## G18  FMC1_HPC_LA16_P
set_property  -dict {PACKAGE_PIN  K38   IOSTANDARD LVDS} [get_ports vdither_n]                    ; ## G19  FMC1_HPC_LA16_N

set_property  -dict {PACKAGE_PIN  H39   IOSTANDARD LVCMOS18} [get_ports dac_clk]                  ; ## D17  FMC1_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  G39   IOSTANDARD LVCMOS18} [get_ports dac_data]                 ; ## D18  FMC1_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  N39   IOSTANDARD LVCMOS18} [get_ports dac_sync_0]               ; ## C18  FMC1_HPC_LA14_P
set_property  -dict {PACKAGE_PIN  N40   IOSTANDARD LVCMOS18} [get_ports dac_sync_1]               ; ## C19  FMC1_HPC_LA14_N

set_property  -dict {PACKAGE_PIN  R40   IOSTANDARD LVCMOS18} [get_ports psync_0]                  ; ## G15  FMC1_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  P40   IOSTANDARD LVCMOS18} [get_ports psync_1]                  ; ## G16  FMC1_HPC_LA12_N

# clocks

create_clock -name rx_ref_clk_0   -period  1.60 [get_ports rx_ref_clk_0_p]
create_clock -name rx_ref_clk_1   -period  1.60 [get_ports rx_ref_clk_1_p]
create_clock -name rx_div_clk     -period  6.40 [get_pins i_system_wrapper/system_i/axi_ad9625_0_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  A10} [get_ports rx_ref_clk_0_p] ; ## D04  FMC1_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9 } [get_ports rx_ref_clk_0_n] ; ## D05  FMC1_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  K8 } [get_ports rx_ref_clk_1_p] ; ## D04  FMC2_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  K7 } [get_ports rx_ref_clk_1_n] ; ## D05  FMC2_HPC_GBTCLK0_M2C_N

set_property IOB false [get_cells -hierarchical -filter {name =~ *SCK_O_NE_4_FDRE_INST}]

# xcvr channels

set_property LOC GTXE2_CHANNEL_X1Y20 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y21 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y22 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y23 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y24 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y25 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y26 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y27 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_0_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[2]    A14/A15   FMC_HPC_DP4_M2C   H8/H7    rx_data[0]   GTXE2_CHANNEL_X1Y20
# rx_data[0]    A18/A19   FMC_HPC_DP5_M2C   G6/G5    rx_data[1]   GTXE2_CHANNEL_X1Y21
# rx_data[1]    B16/B17   FMC_HPC_DP6_M2C   F8/F7    rx_data[2]   GTXE2_CHANNEL_X1Y22
# rx_data[3]    B12/B13   FMC_HPC_DP7_M2C   E6/E5    rx_data[3]   GTXE2_CHANNEL_X1Y23
# rx_data[6]    C06/C07   FMC_HPC_DP0_M2C   D8/D7    rx_data[4]   GTXE2_CHANNEL_X1Y24
# rx_data[7]    A02/A03   FMC_HPC_DP1_M2C   C6/C5    rx_data[5]   GTXE2_CHANNEL_X1Y25
# rx_data[5]    A06/A07   FMC_HPC_DP2_M2C   B8/B7    rx_data[6]   GTXE2_CHANNEL_X1Y26
# rx_data[4]    A10/A11   FMC_HPC_DP3_M2C   A6/A5    rx_data[7]   GTXE2_CHANNEL_X1Y27
# -----------------------------------------------------------------------------------

set_property LOC GTXE2_CHANNEL_X1Y12 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y13 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y14 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y15 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt3*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y16 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt4*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y17 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt5*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y18 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt6*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y19 [get_cells -hierarchical -filter {NAME =~ *axi_ad9625_1_xcvr*gt7*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[2]    A14/A15   FMC_HPC_DP4_M2C   W6/W5    rx_data[0]   GTXE2_CHANNEL_X1Y12
# rx_data[0]    A18/A19   FMC_HPC_DP5_M2C   V4/V3    rx_data[1]   GTXE2_CHANNEL_X1Y13
# rx_data[1]    B16/B17   FMC_HPC_DP6_M2C   U6/U5    rx_data[2]   GTXE2_CHANNEL_X1Y14
# rx_data[3]    B12/B13   FMC_HPC_DP7_M2C   R6/R5    rx_data[3]   GTXE2_CHANNEL_X1Y15
# rx_data[6]    C06/C07   FMC_HPC_DP0_M2C   P8/P7    rx_data[4]   GTXE2_CHANNEL_X1Y16
# rx_data[7]    A02/A03   FMC_HPC_DP1_M2C   N6/N5    rx_data[5]   GTXE2_CHANNEL_X1Y17
# rx_data[5]    A06/A07   FMC_HPC_DP2_M2C   L6/L5    rx_data[6]   GTXE2_CHANNEL_X1Y18
# rx_data[4]    A10/A11   FMC_HPC_DP3_M2C   J6/J5    rx_data[7]   GTXE2_CHANNEL_X1Y19
# -----------------------------------------------------------------------------------


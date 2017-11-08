
# ad9250

set_property  -dict {PACKAGE_PIN  U31   IOSTANDARD LVCMOS18} [get_ports rx_sync]                      ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  T31   IOSTANDARD LVCMOS18} [get_ports rx_sysref]                    ; ## G37  FMC_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  M29   IOSTANDARD LVCMOS18} [get_ports spi_csn_0]                    ; ## G34  FMC_HPC_LA31_N
set_property  -dict {PACKAGE_PIN  M28   IOSTANDARD LVCMOS18} [get_ports spi_clk]                      ; ## G33  FMC_HPC_LA31_P
set_property  -dict {PACKAGE_PIN  V29   IOSTANDARD LVCMOS18} [get_ports spi_sdio]                     ; ## H37  FMC_HPC_LA32_P

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/axi_fmcadc1_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  A10} [get_ports rx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  A9 } [get_ports rx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N

# xcvr channels

set_property LOC GTXE2_CHANNEL_X1Y24 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y25 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y26 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X1Y27 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt3*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[0]    C06/C07   FMC_HPC_DP0_M2C   D8/D7     rx_data[0]  GTXE2_CHANNEL_X0Y12
# rx_data[1]    A02/A03   FMC_HPC_DP1_M2C   C6/C5     rx_data[1]  GTXE2_CHANNEL_X0Y13
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   B8/B7     rx_data[2]  GTXE2_CHANNEL_X0Y14
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   A6/A5     rx_data[3]  GTXE2_CHANNEL_X0Y15
# -----------------------------------------------------------------------------------

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]


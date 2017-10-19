
# ad9250

set_property  -dict {PACKAGE_PIN  N26   IOSTANDARD LVCMOS25} [get_ports rx_sync]                      ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  N27   IOSTANDARD LVCMOS25} [get_ports rx_sysref]                    ; ## G37  FMC_HPC_LA33_N
set_property  -dict {PACKAGE_PIN  P29   IOSTANDARD LVCMOS25} [get_ports spi_csn]                      ; ## G34  FMC_HPC_LA31_N
set_property  -dict {PACKAGE_PIN  N29   IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## G33  FMC_HPC_LA31_P
set_property  -dict {PACKAGE_PIN  P21   IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## H37  FMC_HPC_LA32_P

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/axi_fmcadc1_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt1*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt2*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells -hierarchical -filter {NAME =~ *axi_fmcadc1_xcvr*gt3*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[0]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[1]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# rx_data[2]    A06/A07   FMC_HPC_DP2_M2C   AG8/AG7   rx_data[2]  GTXE2_CHANNEL_X0Y2
# rx_data[3]    A10/A11   FMC_HPC_DP3_M2C   AE8/AE7   rx_data[3]  GTXE2_CHANNEL_X0Y3
# -----------------------------------------------------------------------------------

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]



# ad9250

set_property  -dict {PACKAGE_PIN  V12   IOSTANDARD LVCMOS18} [get_ports rx_sync]                      ; ## G36  FMC_HPC0_LA33_P
set_property  -dict {PACKAGE_PIN  V11   IOSTANDARD LVCMOS18} [get_ports rx_sysref]                    ; ## G37  FMC_HPC0_LA33_N

set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn_0]   ; ## G34  FMC_HPC0_LA31_N
set_property  -dict {PACKAGE_PIN  V8    IOSTANDARD LVCMOS18} [get_ports spi_clk]                      ; ## G33  FMC_HPC0_LA31_P
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS18} [get_ports spi_sdio]                     ; ## H37  FMC_HPC0_LA32_P

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]

# gt pin assignments below are for reference only and are ignored by the tool!
#
# set_property  -dict {PACKAGE_PIN  G7 }  [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC0_GBTCLK0_M2C_C_P
# set_property  -dict {PACKAGE_PIN  G8 }  [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC0_GBTCLK0_M2C_C_N
#
# set_property  -dict {PACKAGE_PIN  H2 }  [get_ports rx_data_p[0]]                                      ; ## C06  FMC_HPC0_DP0_M2C_P
# set_property  -dict {PACKAGE_PIN  H1 }  [get_ports rx_data_n[0]]                                      ; ## C07  FMC_HPC0_DP0_M2C_N
# set_property  -dict {PACKAGE_PIN  J4 }  [get_ports rx_data_p[1]]                                      ; ## A02  FMC_HPC0_DP1_M2C_P
# set_property  -dict {PACKAGE_PIN  J3 }  [get_ports rx_data_n[1]]                                      ; ## A03  FMC_HPC0_DP1_M2C_N
# set_property  -dict {PACKAGE_PIN  F2 }  [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC0_DP2_M2C_P
# set_property  -dict {PACKAGE_PIN  F1 }  [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC0_DP2_M2C_N
# set_property  -dict {PACKAGE_PIN  K2 }  [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC0_DP3_M2C_P
# set_property  -dict {PACKAGE_PIN  K1 }  [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC0_DP3_M2C_N

set_property LOC GTHE4_COMMON_X1Y1   [get_cells -hierarchical -filter {NAME =~ *i_ibufds_rx_ref_clk}]

set_property LOC GTHE4_CHANNEL_X1Y10 [get_cells -hierarchical -filter {NAME =~ *util_fmcjesdadc1_xcvr/inst/i_xch_0/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y9  [get_cells -hierarchical -filter {NAME =~ *util_fmcjesdadc1_xcvr/inst/i_xch_1/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y11 [get_cells -hierarchical -filter {NAME =~ *util_fmcjesdadc1_xcvr/inst/i_xch_2/i_gthe4_channel}]
set_property LOC GTHE4_CHANNEL_X1Y8  [get_cells -hierarchical -filter {NAME =~ *util_fmcjesdadc1_xcvr/inst/i_xch_3/i_gthe4_channel}]

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  6.40 [get_pins i_system_wrapper/system_i/util_fmcjesdadc1_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]


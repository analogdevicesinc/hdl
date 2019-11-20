
# ad9250

set_property  -dict {PACKAGE_PIN  C8 } [get_ports rx_ref_clk_p]                                      ; ## D04  FMC_HPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  C7 } [get_ports rx_ref_clk_n]                                      ; ## D05  FMC_HPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  E4}   [get_ports rx_data_p[0]]                                      ; ## C06  FMC_HPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E3}   [get_ports rx_data_n[0]]                                      ; ## C07  FMC_HPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  D6 }  [get_ports rx_data_p[1]]                                      ; ## A02  FMC_HPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D5 }  [get_ports rx_data_n[1]]                                      ; ## A03  FMC_HPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  B6 }  [get_ports rx_data_p[2]]                                      ; ## A06  FMC_HPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  B5 }  [get_ports rx_data_n[2]]                                      ; ## A07  FMC_HPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  A8 }  [get_ports rx_data_p[3]]                                      ; ## A10  FMC_HPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  A7 }  [get_ports rx_data_n[3]]                                      ; ## A11  FMC_HPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  H21   IOSTANDARD LVCMOS25} [get_ports rx_sync]                      ; ## G36  FMC_HPC_LA33_P
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS25} [get_ports rx_sysref]                    ; ## G37  FMC_HPC_LA33_N

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS25} [get_ports spi_csn_0]                      ; ## G34  FMC_HPC_LA31_N
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## G33  FMC_HPC_LA31_P
set_property  -dict {PACKAGE_PIN  D21   IOSTANDARD LVCMOS25} [get_ports spi_sdio]                     ; ## H37  FMC_HPC_LA32_P

# clocks

create_clock -name rx_ref_clk   -period  4.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  8.00 [get_pins i_system_wrapper/system_i/util_fmcjesdadc1_xcvr/inst/i_xch_0/i_gtxe2_channel/RXOUTCLK]

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]


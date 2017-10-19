
# ad6676

set_property  -dict {PACKAGE_PIN  AG21  IOSTANDARD LVDS_25} [get_ports rx_sync_p]                     ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AH21  IOSTANDARD LVDS_25} [get_ports rx_sync_n]                     ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AF20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_p]    ; ## G06  FMC_HPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AG20  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rx_sysref_n]    ; ## G07  FMC_HPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  AH24  IOSTANDARD LVCMOS25} [get_ports spi_csn]                      ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AK20  IOSTANDARD LVCMOS25} [get_ports spi_clk]                      ; ## H11  FMC_HPC_LA04_N
set_property  -dict {PACKAGE_PIN  AJ20  IOSTANDARD LVCMOS25} [get_ports spi_mosi]                     ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AH23  IOSTANDARD LVCMOS25} [get_ports spi_miso]                     ; ## D11  FMC_HPC_LA05_P

set_property  -dict {PACKAGE_PIN  AH22  IOSTANDARD LVCMOS25} [get_ports adc_oen]                      ; ## C11  FMC_HPC_LA06_N
set_property  -dict {PACKAGE_PIN  AF19  IOSTANDARD LVCMOS25} [get_ports adc_sela]                     ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  AG19  IOSTANDARD LVCMOS25} [get_ports adc_selb]                     ; ## G13  FMC_HPC_LA08_N
set_property  -dict {PACKAGE_PIN  AJ23  IOSTANDARD LVCMOS25} [get_ports adc_s0]                       ; ## H13  FMC_HPC_LA07_P
set_property  -dict {PACKAGE_PIN  AJ24  IOSTANDARD LVCMOS25} [get_ports adc_s1]                       ; ## H14  FMC_HPC_LA07_N
set_property  -dict {PACKAGE_PIN  AG22  IOSTANDARD LVCMOS25} [get_ports adc_resetb]                   ; ## C10  FMC_HPC_LA06_P
set_property  -dict {PACKAGE_PIN  AK17  IOSTANDARD LVCMOS25} [get_ports adc_agc1]                     ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK18  IOSTANDARD LVCMOS25} [get_ports adc_agc2]                     ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AH19  IOSTANDARD LVCMOS25} [get_ports adc_agc3]                     ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  AJ19  IOSTANDARD LVCMOS25} [get_ports adc_agc4]                     ; ## G10  FMC_HPC_LA03_N

# clocks

create_clock -name rx_ref_clk   -period   5.00 [get_ports rx_ref_clk_p]
create_clock -name rx_div_clk   -period  10.00 [get_pins i_system_wrapper/system_i/axi_ad6676_xcvr_rx_bufg/U0/BUFG_O]

# reference clocks

set_property  -dict {PACKAGE_PIN  AD10} [get_ports rx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P (IBUFDS_GTE2_X0Y0)
set_property  -dict {PACKAGE_PIN  AD9 } [get_ports rx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N (IBUFDS_GTE2_X0Y0)

# xcvr channels

set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells -hierarchical -filter {NAME =~ *axi_ad6676_xcvr*gt0*gtxe2_i}]
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells -hierarchical -filter {NAME =~ *axi_ad6676_xcvr*gt1*gtxe2_i}]

# lanes
# device        fmc                         xcvr                  location
# -----------------------------------------------------------------------------------
# rx_data[0]    C06/C07   FMC_HPC_DP0_M2C   AH10/AH9  rx_data[0]  GTXE2_CHANNEL_X0Y0
# rx_data[1]    A02/A03   FMC_HPC_DP1_M2C   AJ8/AJ7   rx_data[1]  GTXE2_CHANNEL_X0Y1
# -----------------------------------------------------------------------------------

set_property ASYNC_REG TRUE [get_cells -hier -filter {name =~ *sysref_en_m*}]
set_false_path -to [get_cells -hier -filter {name =~ *sysref_en_m1*  && IS_SEQUENTIAL}]


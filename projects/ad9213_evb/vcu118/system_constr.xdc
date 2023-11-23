###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# ad9213_evb

set_property -dict {PACKAGE_PIN AK38} [get_ports rx_ref_clk_p]                                              ; ## D4   FMC_GBT0_0_P         MGTREFCLK0P_121
set_property -dict {PACKAGE_PIN AK39} [get_ports rx_ref_clk_n]                                              ; ## D5   FMC_GBT0_0_N         MGTREFCLK0N_121
set_property -dict {PACKAGE_PIN V38} [get_ports rx_ref_clk_replica_p]                                       ; ## D4   FMC_GBT0_1_P         MGTREFCLK0N_126
set_property -dict {PACKAGE_PIN V39} [get_ports rx_ref_clk_replica_n]                                       ; ## D5   FMC_GBT0_1_P         MGTREFCLK0N_126

set_property -dict {PACKAGE_PIN AF38} [get_ports glbl_clk_0_p]                                              ; ## L12  FMC_GBTCLK2_M2C_C_P  MGTREFCLK0P_122
set_property -dict {PACKAGE_PIN AF39} [get_ports glbl_clk_0_n]                                              ; ## L13  FMC_GBTCLK2_M2C_C_P  MGTREFCLK0N_122

set_property -dict {PACKAGE_PIN AJ32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]        ; ## H7   FMC_LA02_P           IO_L14P_T2L_N2_GC_43
set_property -dict {PACKAGE_PIN AK32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]        ; ## H8   FMC_LA02_N           IO_L14N_T2L_N3_GC_43
set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVDS} [get_ports rx_sync_p]                                 ; ## H10  FMC_LA04_P           IO_L6P_T0U_N10_AD6P_43
set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVDS} [get_ports rx_sync_n]                                 ; ## H11  FMC_LA04_N           IO_L6N_T0U_N11_AD6N_43

set_property -dict {PACKAGE_PIN W45}  [get_ports rx_data_p[0]]                                              ; ## A14  FMC_DP4_M2C_P        MGTYRXP0_126
set_property -dict {PACKAGE_PIN W46}  [get_ports rx_data_n[0]]                                              ; ## A15  FMC_DP4_M2C_N        MGTYRXN0_126
set_property -dict {PACKAGE_PIN AR45} [get_ports rx_data_p[1]]                                              ; ## C6   FMC_DP0_M2C_P        MGTYRXP0_121
set_property -dict {PACKAGE_PIN AR46} [get_ports rx_data_n[1]]                                              ; ## C7   FMC_DP0_M2C_N        MGTYRXN0_121
set_property -dict {PACKAGE_PIN AL45} [get_ports rx_data_p[2]]                                              ; ## A6   FMC_DP2_M2C_P        MGTYRXP2_121
set_property -dict {PACKAGE_PIN AL46} [get_ports rx_data_n[2]]                                              ; ## A7   FMC_DP2_M2C_N        MGTYRXN2_121
set_property -dict {PACKAGE_PIN AN45} [get_ports rx_data_p[3]]                                              ; ## A2   FMC_DP1_M2C_P        MGTYRXP1_121
set_property -dict {PACKAGE_PIN AN46} [get_ports rx_data_n[3]]                                              ; ## A3   FMC_DP1_M2C_N        MGTYRXN1_121
set_property -dict {PACKAGE_PIN AJ45} [get_ports rx_data_p[4]]                                              ; ## A10  FMC_DP3_M2C_P        MGTYRXP3_121
set_property -dict {PACKAGE_PIN AJ46} [get_ports rx_data_n[4]]                                              ; ## A11  FMC_DP3_M2C_N        MGTYRXN3_121
set_property -dict {PACKAGE_PIN AC45} [get_ports rx_data_p[5]]                                              ; ## Y14  FMC_DP12_M2C_P       MGTYRXP0_125
set_property -dict {PACKAGE_PIN AC46} [get_ports rx_data_n[5]]                                              ; ## Y15  FMC_DP12_M2C_N       MGTYRXN0_125
set_property -dict {PACKAGE_PIN AB43} [get_ports rx_data_p[6]]                                              ; ## Z16  FMC_DP13_M2C_P       MGTYRXP1_125
set_property -dict {PACKAGE_PIN AB44} [get_ports rx_data_n[6]]                                              ; ## Z17  FMC_DP13_M2C_N       MGTYRXN1_125
set_property -dict {PACKAGE_PIN N45}  [get_ports rx_data_p[7]]                                              ; ## B12  FMC_DP7_M2C_P        MGTYRXP3_126
set_property -dict {PACKAGE_PIN N46}  [get_ports rx_data_n[7]]                                              ; ## B13  FMC_DP7_M2C_N        MGTYRXN3_126
set_property -dict {PACKAGE_PIN R45}  [get_ports rx_data_p[8]]                                              ; ## B16  FMC_DP6_M2C_P        MGTYRXP2_126
set_property -dict {PACKAGE_PIN R46}  [get_ports rx_data_n[8]]                                              ; ## B17  FMC_DP6_M2C_N        MGTYRXN2_126
set_property -dict {PACKAGE_PIN Y43}  [get_ports rx_data_p[9]]                                              ; ## Y22  FMC_DP15_M2C_P       MGTYRXP3_125
set_property -dict {PACKAGE_PIN Y44}  [get_ports rx_data_n[9]]                                              ; ## Y23  FMC_DP15_M2C_N       MGTYRXN3_125
set_property -dict {PACKAGE_PIN AA45} [get_ports rx_data_p[10]]                                             ; ## Y18  FMC_DP14_M2C_P       MGTYRXP2_125
set_property -dict {PACKAGE_PIN AA46} [get_ports rx_data_n[10]]                                             ; ## Y19  FMC_DP14_M2C_N       MGTYRXN2_125
set_property -dict {PACKAGE_PIN E45}  [get_ports rx_data_p[11]]                                             ; ## Y38  FMC_DP19_M2C_P       MGTYRXP3_127
set_property -dict {PACKAGE_PIN E46}  [get_ports rx_data_n[11]]                                             ; ## Y39  FMC_DP19_M2C_N       MGTYRXN3_127
set_property -dict {PACKAGE_PIN L45}  [get_ports rx_data_p[12]]                                             ; ## Z32  FMC_DP16_M2C_P       MGTYRXP0_127
set_property -dict {PACKAGE_PIN L46}  [get_ports rx_data_n[12]]                                             ; ## Z33  FMC_DP16_M2C_N       MGTYRXN0_127
set_property -dict {PACKAGE_PIN G45}  [get_ports rx_data_p[13]]                                             ; ## Z36  FMC_DP18_M2C_P       MGTYRXP2_127
set_property -dict {PACKAGE_PIN G46}  [get_ports rx_data_n[13]]                                             ; ## Z37  FMC_DP18_M2C_N       MGTYRXN2_127
set_property -dict {PACKAGE_PIN J45}  [get_ports rx_data_p[14]]                                             ; ## Y34  FMC_DP17_M2C_P       MGTYRXP1_127
set_property -dict {PACKAGE_PIN J46}  [get_ports rx_data_n[14]]                                             ; ## Y35  FMC_DP17_M2C_N       MGTYRXN1_127
set_property -dict {PACKAGE_PIN U45}  [get_ports rx_data_p[15]]                                             ; ## A18  FMC_DP5_M2C_P        MGTYRXP1_126
set_property -dict {PACKAGE_PIN U46}  [get_ports rx_data_n[15]]                                             ; ## A19  FMC_DP5_M2C_N        MGTYRXN1_126

set_property -dict {PACKAGE_PIN AJ35 IOSTANDARD LVCMOS18} [get_ports rstb]                                  ; ## D17  FMC_LA13_P           IO_L20P_T3L_N2_AD1P_43

set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18} [get_ports gpio[0]]                               ; ## G12  FMC_LA08_P           IO_L18P_T2U_N10_AD2P_43
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18} [get_ports gpio[1]]                               ; ## G13  FMC_LA08_N           IO_L18N_T2U_N11_AD2N_43
set_property -dict {PACKAGE_PIN AJ33 IOSTANDARD LVCMOS18} [get_ports gpio[2]]                               ; ## D14  FMC_LA09_P           IO_L19P_T3L_N0_DBC_AD9P_43
set_property -dict {PACKAGE_PIN AK33 IOSTANDARD LVCMOS18} [get_ports gpio[3]]                               ; ## D15  FMC_LA09_N           IO_L19N_T3L_N1_DBC_AD9N_43
set_property -dict {PACKAGE_PIN AP35 IOSTANDARD LVCMOS18} [get_ports gpio[4]]                               ; ## C14  FMC_LA10_P           IO_L3P_T0L_N4_AD15P_43

set_property -dict {PACKAGE_PIN AP36 IOSTANDARD LVCMOS18} [get_ports fpga_csb]                              ; ## H13  FMC_LA07_P           IO_L5P_T0U_N8_AD14P_43
set_property -dict {PACKAGE_PIN AT36 IOSTANDARD LVCMOS18} [get_ports fpga_sclk]                             ; ## C11  FMC_LA06_N           IO_L2N_T0L_N3_43
set_property -dict {PACKAGE_PIN AT35 IOSTANDARD LVCMOS18} [get_ports fpga_sdio]                             ; ## C10  FMC_LA06_P           IO_L2P_T0L_N2_43

set_property -dict {PACKAGE_PIN AG31 IOSTANDARD LVCMOS18} [get_ports hmc7044_csb]                           ; ## C18  FMC_LA14_P           IO_L23P_T3U_N8_43
set_property -dict {PACKAGE_PIN AH31 IOSTANDARD LVCMOS18} [get_ports hmc7044_sclk]                          ; ## C19  FMC_LA14_N           IO_L23N_T3U_N9_43
set_property -dict {PACKAGE_PIN AG32 IOSTANDARD LVCMOS18} [get_ports hmc7044_sdio]                          ; ## H19  FMC_LA15_P           IO_L24P_T3U_N10_43
set_property -dict {PACKAGE_PIN AJ36 IOSTANDARD LVCMOS18} [get_ports hmc_sync_req]                          ; ## D18  FMC_LA13_N           IO_L20N_T3L_N3_AD1N_43

set_property -dict {PACKAGE_PIN N33  IOSTANDARD LVCMOS18} [get_ports adf4371_csb]                           ; ## H22  FMC_LA19_P           IO_L22P_T3U_N6_DBC_AD0P_45

# Primary clock definitions

# These two reference clocks are connect to the same source on the PCB
create_clock -name rx_ref_clk           -period  1.6 [get_ports rx_ref_clk_p]
create_clock -name rx_ref_clk_replica   -period  1.6 [get_ports rx_ref_clk_replica_p]

# The Global clock is routed from the REFCLK1 of the dual_ad9208 board
# since GLBLCLK0 and GLBLCLK1 are not connected to global clock capable pins.
create_clock -name global_clk_0   -period  3.2 [get_ports glbl_clk_0_p]

# Constraint SYSREFs
# Assumption is that REFCLK and SYSREF have similar propagation delay,
# and the SYSREF is a source synchronous Center-Aligned signal to REFCLK
set_input_delay -clock [get_clocks global_clk_0] \
  [expr [get_property PERIOD [get_clocks global_clk_0]] / 2] \
  [get_ports {rx_sysref_*}]

#ad4630

set_property -dict {PACKAGE_PIN AL30 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad463x_spi_sclk]              ; ## D8   FMC_LA01_CC_P        IO_L16P_T2U_N6_QBC_AD3P_43
set_property -dict {PACKAGE_PIN AR38 IOSTANDARD LVCMOS18 IOB TRUE} [get_ports ad463x_spi_sdo]               ; ## D12  FMC_LA05_N           IO_L1N_T0L_N1_DBC_43
set_property -dict {PACKAGE_PIN AP38 IOSTANDARD LVCMOS18} [get_ports ad463x_spi_cs]                         ; ## D11  FMC_LA05_P           IO_L1P_T0L_N0_DBC_43

set_property -dict {PACKAGE_PIN U35  IOSTANDARD LVCMOS18} [get_ports ad463x_cnv]                            ; ## G30  FMC_LA29_P           IO_L4P_T0U_N6_DBC_AD7P_45
set_property -dict {PACKAGE_PIN W34  IOSTANDARD LVCMOS18} [get_ports ad463x_resetn]                         ; ## G28  FMC_LA25_N           IO_L3N_T0L_N5_AD15N_45
set_property -dict {PACKAGE_PIN R34  IOSTANDARD LVCMOS18} [get_ports ad463x_echo_sclk]                      ; ## D20  FMC_LA17_CC_P        IO_L13P_T2L_N0_GC_QBC_45
set_property -dict {PACKAGE_PIN T36  IOSTANDARD LVCMOS18} [get_ports ad463x_busy]                           ; ## G31  FMC_LA29_N           IO_L4N_T0U_N7_DBC_AD7N_4


# SCLK echod clock, tuned to 80 MHz //, phase shifted with 30% (aprox. 4ns)
create_clock -period 12.500 -name ECHOSCLK_clk [get_ports ad463x_echo_sclk]

# rename auto-generated clock for SPIEngine to spi_clk - 160MHz
# NOTE: clk_fpga_0 is the first PL fabric clock, also called $sys_cpu_clk
#[get_pins i_system_wrapper/system_i/axi_ddr_cntrl/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT1]
create_generated_clock -name spi_clk0 -source [get_pins -filter name=~*CLKIN1 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm*]] -master_clock [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_ddr_cntrl/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT1]] [get_pins -filter name=~*CLKOUT0 -of [get_cells -hier -filter name=~*spi_clkgen*i_mmcm*]]

# create a generated clock for SCLK - fSCLK=spi_clk/2 - 80MHz
create_generated_clock -name SCLK_clk -source [get_pins -hier -filter name=~*ad463x*sclk_reg/C] -edges {1 3 5} [get_ports ad463x_spi_sclk]

# output delay for MOSI line (SDI for the device)
#
# tHSDI and tSSDI is 1.5ns
set_output_delay -clock [get_clocks SCLK_clk] -max 1.500 [get_ports ad463x_spi_sdo]
set_output_delay -clock [get_clocks SCLK_clk] -min 1.500 [get_ports ad463x_spi_sdo]

# relax the SDO path to help closing timing at high frequencies
set_multicycle_path -setup -from [get_clocks spi_clk0] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 8
set_multicycle_path -hold  -from [get_clocks spi_clk0] -to [get_cells -hierarchical -filter {NAME=~*/data_sdo_shift_reg[*]}] 7

set_multicycle_path -setup -from [get_clocks spi_clk0] -to [get_cells -hierarchical -filter NAME=~*/spi_ad463x_execution/inst/left_aligned_reg*] 8
set_multicycle_path -hold  -from [get_clocks spi_clk0] -to [get_cells -hierarchical -filter NAME=~*/spi_ad463x_execution/inst/left_aligned_reg*] 7
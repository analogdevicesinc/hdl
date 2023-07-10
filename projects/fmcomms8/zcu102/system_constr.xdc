###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property PACKAGE_PIN G8 [get_ports ref_clk_c_p]; # D04 FMC_HPC0_GBTCLK0_M2C_C_P
set_property PACKAGE_PIN G7 [get_ports ref_clk_c_n]; # D05 FMC_HPC0_GBTCLK0_M2C_C_N

set_property PACKAGE_PIN H2 [get_ports {rx_data_c_p[0]}]; # C06 FMC_HPC0_DP0_M2C_P
set_property PACKAGE_PIN H1 [get_ports {rx_data_c_n[0]}]; # C07 FMC_HPC0_DP0_M2C_N
set_property PACKAGE_PIN J4 [get_ports {rx_data_c_p[1]}]; # A02 FMC_HPC0_DP1_M2C_P
set_property PACKAGE_PIN J3 [get_ports {rx_data_c_n[1]}]; # A03 FMC_HPC0_DP1_M2C_N
set_property PACKAGE_PIN F2 [get_ports {rx_data_c_p[2]}]; # A06 FMC_HPC0_DP2_M2C_P
set_property PACKAGE_PIN F1 [get_ports {rx_data_c_n[2]}]; # A07 FMC_HPC0_DP2_M2C_N
set_property PACKAGE_PIN K2 [get_ports {rx_data_c_p[3]}]; # A10 FMC_HPC0_DP3_M2C_P
set_property PACKAGE_PIN K1 [get_ports {rx_data_c_n[3]}]; # A11 FMC_HPC0_DP3_M2C_N
set_property PACKAGE_PIN G4 [get_ports {tx_data_c_p[0]}]; # C02 FMC_HPC0_DP0_C2M_P
set_property PACKAGE_PIN G3 [get_ports {tx_data_c_n[0]}]; # C03 FMC_HPC0_DP0_C2M_N
set_property PACKAGE_PIN H6 [get_ports {tx_data_c_p[1]}]; # A22 FMC_HPC0_DP1_C2M_P
set_property PACKAGE_PIN H5 [get_ports {tx_data_c_n[1]}]; # A23 FMC_HPC0_DP1_C2M_N
set_property PACKAGE_PIN F6 [get_ports {tx_data_c_p[2]}]; # A26 FMC_HPC0_DP2_C2M_P
set_property PACKAGE_PIN F5 [get_ports {tx_data_c_n[2]}]; # A27 FMC_HPC0_DP2_C2M_N
set_property PACKAGE_PIN K6 [get_ports {tx_data_c_p[3]}]; # A30 FMC_HPC0_DP3_C2M_P
set_property PACKAGE_PIN K5 [get_ports {tx_data_c_n[3]}]; # A31 FMC_HPC0_DP3_C2M_N

set_property PACKAGE_PIN L8 [get_ports ref_clk_d_p]; # B20 FMC_HPC0_GBTCLK1_M2C_C_P
set_property PACKAGE_PIN L7 [get_ports ref_clk_d_n]; # B21 FMC_HPC0_GBTCLK1_M2C_C_N

set_property PACKAGE_PIN L4 [get_ports {rx_data_d_p[0]}]; # A14 FMC_HPC0_DP4_M2C_P
set_property PACKAGE_PIN L3 [get_ports {rx_data_d_n[0]}]; # A15 FMC_HPC0_DP4_M2C_N
set_property PACKAGE_PIN P2 [get_ports {rx_data_d_p[1]}]; # A18 FMC_HPC0_DP5_M2C_P
set_property PACKAGE_PIN P1 [get_ports {rx_data_d_n[1]}]; # A19 FMC_HPC0_DP5_M2C_N
set_property PACKAGE_PIN T2 [get_ports {rx_data_d_p[2]}]; # B16 FMC_HPC0_DP6_M2C_P
set_property PACKAGE_PIN T1 [get_ports {rx_data_d_n[2]}]; # B17 FMC_HPC0_DP6_M2C_N
set_property PACKAGE_PIN M2 [get_ports {rx_data_d_p[3]}]; # B12 FMC_HPC0_DP7_M2C_P
set_property PACKAGE_PIN M1 [get_ports {rx_data_d_n[3]}]; # B13 FMC_HPC0_DP7_M2C_N
set_property PACKAGE_PIN M6 [get_ports {tx_data_d_p[0]}]; # A34 FMC_HPC0_DP4_C2M_P
set_property PACKAGE_PIN M5 [get_ports {tx_data_d_n[0]}]; # A35 FMC_HPC0_DP4_C2M_N
set_property PACKAGE_PIN P6 [get_ports {tx_data_d_p[1]}]; # A38 FMC_HPC0_DP5_C2M_P
set_property PACKAGE_PIN P5 [get_ports {tx_data_d_n[1]}]; # A39 FMC_HPC0_DP5_C2M_N
set_property PACKAGE_PIN R4 [get_ports {tx_data_d_p[2]}]; # B36 FMC_HPC0_DP6_C2M_P
set_property PACKAGE_PIN R3 [get_ports {tx_data_d_n[2]}]; # B37 FMC_HPC0_DP6_C2M_N
set_property PACKAGE_PIN N4 [get_ports {tx_data_d_p[3]}]; # B32 FMC_HPC0_DP7_C2M_P
set_property PACKAGE_PIN N3 [get_ports {tx_data_d_n[3]}]; # B33 FMC_HPC0_DP7_C2M_N

set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_c_p]; # H04 FMC_HPC0_CLK0_M2C_P
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_c_n]; # H05 FMC_HPC0_CLK0_M2C_N
set_property -dict {PACKAGE_PIN T8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_d_p]; # G02 FMC_HPC0_CLK1_M2C_P
set_property -dict {PACKAGE_PIN R8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports core_clk_d_n]; # G03 FMC_HPC0_CLK1_M2C_N

set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVDS} [get_ports rx_sync_c_p]; # H16 FMC_HPC0_LA11_P
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVDS} [get_ports rx_sync_c_n]; # H17 FMC_HPC0_LA11_N
set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVDS} [get_ports rx_os_sync_c_p]; # G15 FMC_HPC0_LA12_P
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVDS} [get_ports rx_os_sync_c_n]; # G16 FMC_HPC0_LA12_N
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_p]; # H22 FMC_HPC0_LA19_P
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_n]; # H23 FMC_HPC0_LA19_N
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_1_p]; # G21 FMC_HPC0_LA20_P
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_c_1_n]; # G22 FMC_HPC0_LA20_N
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_c_p]; # D08 FMC_HPC0_LA01_CC_P
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_c_n]; # D09 FMC_HPC0_LA01_CC_N

set_property -dict {PACKAGE_PIN W5  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable_c]; # C14 FMC_HPC0_LA10_P
set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable_c]; # C15 FMC_HPC0_LA10_N
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable_c]; # C10 FMC_HPC0_LA06_P
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable_c]; # C11 FMC_HPC0_LA06_N
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b_c]; # D17 FMC_HPC0_LA13_P
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint_c]; # G27 FMC_HPC2_LA25_P

set_property -dict {PACKAGE_PIN U9  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00_c]; # G30 FMC_HPC0_LA29_P
set_property -dict {PACKAGE_PIN V8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01_c]; # G33 FMC_HPC0_LA31_P
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02_c]; # G36 FMC_HPC0_LA33_P
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03_c]; # H07 FMC_HPC0_LA02_P
set_property -dict {PACKAGE_PIN AA2 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04_c]; # H10 FMC_HPC0_LA04_P
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05_c]; # H28 FMC_HPC0_LA24_P
set_property -dict {PACKAGE_PIN T7  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06_c]; # H31 FMC_HPC0_LA28_P
set_property -dict {PACKAGE_PIN V6  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07_c]; # H34 FMC_HPC0_LA30_P
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08_c]; # H37 FMC_HPC0_LA32_P

set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVDS} [get_ports rx_sync_d_p]; # H19 FMC_HPC0_LA15_P
set_property -dict {PACKAGE_PIN Y9   IOSTANDARD LVDS} [get_ports rx_sync_d_n]; # H20 FMC_HPC0_LA15_N
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVDS} [get_ports rx_os_sync_d_p]; # G18 FMC_HPC0_LA16_P
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVDS} [get_ports rx_os_sync_d_n]; # G19 FMC_HPC0_LA16_N
set_property -dict {PACKAGE_PIN P12  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_p]; # H25 FMC_HPC0_LA21_P
set_property -dict {PACKAGE_PIN N12  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_n]; # H26 FMC_HPC0_LA21_N
set_property -dict {PACKAGE_PIN M15  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_1_p]; # G24 FMC_HPC0_LA22_P
set_property -dict {PACKAGE_PIN M14  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_d_1_n]; # G25 FMC_HPC0_LA22_N
set_property -dict {PACKAGE_PIN Y4   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_d_p]; # G06 FMC_HPC0_LA00_CC_P
set_property -dict {PACKAGE_PIN Y3   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_d_n]; # G07 FMC_HPC0_LA00_CC_N

set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable_d]; # C26 FMC_HPC0_LA27_P
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable_d]; # C27 FMC_HPC0_LA27_N
set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable_d]; # C18 FMC_HPC0_LA14_P
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable_d]; # C19 FMC_HPC0_LA14_N
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b_d]; # D18 FMC_HPC0_LA13_N
set_property -dict {PACKAGE_PIN L11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint_d]; # G28 FMC_HPC0_LA25_N
set_property -dict {PACKAGE_PIN U8  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00_d]; # G31 FMC_HPC0_LA29_N
set_property -dict {PACKAGE_PIN V7  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01_d]; # G34 FMC_HPC0_LA31_N
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02_d]; # G37 FMC_HPC0_LA33_N
set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03_d]; # H08 FMC_HPC0_LA02_N
set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04_d]; # H11 FMC_HPC0_LA04_N
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05_d]; # H29 FMC_HPC0_LA24_N
set_property -dict {PACKAGE_PIN T6  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06_d]; # H32 FMC_HPC0_LA28_N
set_property -dict {PACKAGE_PIN U6  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07_d]; # H35 FMC_HPC0_LA30_N
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08_d]; # H38 FMC_HPC0_LA32_N

set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS18} [get_ports hmc7044_reset]; # G09 FMC_HPC0_LA03_P
set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS18} [get_ports hmc7044_sync]; # G10 FMC_HPC0_LA03_N
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS18} [get_ports hmc7044_gpio_1]; # G12 FMC_HPC0_LA08_P
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS18} [get_ports hmc7044_gpio_2]; # G13 FMC_HPC0_LA08_N
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS18} [get_ports hmc7044_gpio_3]; # H13 FMC_HPC0_LA07_P
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS18} [get_ports hmc7044_gpio_4]; # H14 FMC_HPC0_LA07_N

set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS18} [get_ports spi_clk]; # D23 FMC_HPC0_LA23_P
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports spi_sdio]; # D27 FMC_HPC0_LA26_N
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS18} [get_ports spi_miso]; # D26  FMC_HPC0_LA26_P

set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009_c]; # D11 FMC_HPC0_LA05_P
set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009_d]; # D14 FMC_HPC0_LA09_P
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS18} [get_ports spi_csn_hmc7044]; # D24 FMC_HPC0_LA23_N

set_property -dict {PACKAGE_PIN N9 IOSTANDARD LVCMOS18} [get_ports fan_tach]; # C22 FMC_HPC0_LA18_CC_P
set_property -dict {PACKAGE_PIN N8 IOSTANDARD LVCMOS18} [get_ports fan_pwm]; # C23 FMC_HPC0_LA18_CC_N

create_clock -name tx_fmc_dev_clk        -period  4.00 [get_ports core_clk_c_p]
create_clock -name rx_fmc_dev_clk        -period  4.00 [get_ports core_clk_d_p]
create_clock -name jesd_tx_fmc_ref_clk   -period  4.00 [get_ports ref_clk_c_p]
create_clock -name jesd_rx_fmc_ref_clk   -period  4.00 [get_ports ref_clk_d_p]

set_input_delay -clock rx_fmc_dev_clk -max 4    [get_ports sysref_c_p];
set_input_delay -clock rx_fmc_dev_clk -min 4    [get_ports sysref_c_p];

set_input_delay -clock tx_fmc_dev_clk -max 4    [get_ports sysref_d_p];
set_input_delay -clock tx_fmc_dev_clk -min 4    [get_ports sysref_d_p];

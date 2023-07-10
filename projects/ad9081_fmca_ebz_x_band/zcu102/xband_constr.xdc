###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property         -dict {PACKAGE_PIN A20   IOSTANDARD LVCMOS33                       } [get_ports pmod0_0_1_PA_ON      ]; ## J55.1
set_property         -dict {PACKAGE_PIN B20   IOSTANDARD LVCMOS33                       } [get_ports pmod0_1_3_MOSI       ]; ## J55.3
set_property         -dict {PACKAGE_PIN A22   IOSTANDARD LVCMOS33                       } [get_ports pmod0_2_5_MISO       ]; ## J55.5
set_property         -dict {PACKAGE_PIN A21   IOSTANDARD LVCMOS33                       } [get_ports pmod0_3_7_SCLK       ]; ## J55.7
set_property         -dict {PACKAGE_PIN B21   IOSTANDARD LVCMOS33                       } [get_ports pmod0_4_2_TR         ]; ## J55.2
set_property         -dict {PACKAGE_PIN C21   IOSTANDARD LVCMOS33                       } [get_ports pmod0_5_4_TX_LOAD    ]; ## J55.4
set_property         -dict {PACKAGE_PIN C22   IOSTANDARD LVCMOS33                       } [get_ports pmod0_6_6_RX_LOAD    ]; ## J55.6
set_property         -dict {PACKAGE_PIN D21   IOSTANDARD LVCMOS33                       } [get_ports pmod0_7_8_SCL        ]; ## J55.8
set_property         -dict {PACKAGE_PIN D20   IOSTANDARD LVCMOS33                       } [get_ports pmod1_0_1_CSB1       ]; ## J87.1
set_property         -dict {PACKAGE_PIN E20   IOSTANDARD LVCMOS33                       } [get_ports pmod1_1_3_CSB3       ]; ## J87.3
set_property         -dict {PACKAGE_PIN D22   IOSTANDARD LVCMOS33                       } [get_ports pmod1_2_5_CSB5       ]; ## J87.5
set_property         -dict {PACKAGE_PIN E22   IOSTANDARD LVCMOS33                       } [get_ports pmod1_3_7_SDA        ]; ## J87.7
set_property         -dict {PACKAGE_PIN F20   IOSTANDARD LVCMOS33                       } [get_ports pmod1_4_2_CSB2       ]; ## J87.2
set_property         -dict {PACKAGE_PIN G20   IOSTANDARD LVCMOS33                       } [get_ports pmod1_5_4_CSB4       ]; ## J87.4
set_property         -dict {PACKAGE_PIN J20   IOSTANDARD LVCMOS33                       } [get_ports pmod1_6_6_5V_CTRL    ]; ## J87.6
set_property         -dict {PACKAGE_PIN J19   IOSTANDARD LVCMOS33                       } [get_ports pmod1_7_8_PWR_UP_DOWN]; ## J87.8

# XUD #1 custom break out board

set_property         -dict {PACKAGE_PIN AH2   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_sclk   ]; ## FMC1.C10  IO_L19P_T3L_N0_DBC_AD9P_65
set_property         -dict {PACKAGE_PIN AJ2   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_mosi   ]; ## FMC1.C11  IO_L19N_T3L_N1_DBC_AD9N_65
set_property         -dict {PACKAGE_PIN AH4   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio0      ]; ## FMC1.C14  IO_L15P_T2L_N4_AD11P_65
set_property         -dict {PACKAGE_PIN AJ4   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio1      ]; ## FMC1.C15  IO_L15N_T2L_N5_AD11N_65
set_property         -dict {PACKAGE_PIN AH7   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_miso   ]; ## FMC1.C18  IO_L7P_T1L_N0_QBC_AD13P_65
set_property         -dict {PACKAGE_PIN AH6   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_csb    ]; ## FMC1.C19  IO_L7N_T1L_N1_QBC_AD13N_65
set_property         -dict {PACKAGE_PIN U10   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_rst    ]; ## FMC1.C26  IO_L3P_T0L_N4_AD15P_67
set_property         -dict {PACKAGE_PIN AJ6   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_mosi       ]; ## FMC1.D08  IO_L16P_T2U_N6_QBC_AD3P_65
set_property         -dict {PACKAGE_PIN AJ5   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_csb        ]; ## FMC1.D09  IO_L16N_T2U_N7_QBC_AD3N_65
set_property         -dict {PACKAGE_PIN AG3   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_gpio0  ]; ## FMC1.D11  IO_L20P_T3L_N2_AD1P_65
set_property         -dict {PACKAGE_PIN AH3   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_gpio1  ]; ## FMC1.D12  IO_L20N_T3L_N3_AD1N_65
set_property         -dict {PACKAGE_PIN AE2   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_gpio2  ]; ## FMC1.D14  IO_L24P_T3U_N10_PERSTN1_I2C_SDA_65
set_property         -dict {PACKAGE_PIN AE1   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_imu_gpio3  ]; ## FMC1.D15  IO_L24N_T3U_N11_PERSTN0_65
set_property         -dict {PACKAGE_PIN AE5   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_sclk       ]; ## FMC1.G06  IO_L13P_T2L_N0_GC_QBC_65
set_property         -dict {PACKAGE_PIN AF5   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_miso       ]; ## FMC1.G07  IO_L13N_T2L_N1_GC_QBC_65
set_property         -dict {PACKAGE_PIN AD7   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio2      ]; ## FMC1.G15  IO_L9P_T1L_N4_AD12P_65
set_property         -dict {PACKAGE_PIN AD6   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio3      ]; ## FMC1.G16  IO_L9N_T1L_N5_AD12N_65
set_property         -dict {PACKAGE_PIN AG10  IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio4      ]; ## FMC1.G18  IO_L5P_T0U_N8_AD14P_65
set_property         -dict {PACKAGE_PIN AG9   IOSTANDARD LVCMOS18                       } [get_ports fmc_bob_xud1_gpio5      ]; ## FMC1.G19  IO_L5N_T0U_N9_AD14N_65


###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Stingray 0
set_property -dict {PACKAGE_PIN AP24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_PA_ON      ]; ## LA00_P
set_property -dict {PACKAGE_PIN AR24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_MOSI       ]; ## LA00_N
set_property -dict {PACKAGE_PIN AP25 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_MISO       ]; ## LA01_P
set_property -dict {PACKAGE_PIN AP26 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_SCLK       ]; ## LA01_N
set_property -dict {PACKAGE_PIN AW26 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_TR         ]; ## LA02_P
set_property -dict {PACKAGE_PIN AW27 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_TX_LOAD    ]; ## LA02_N
set_property -dict {PACKAGE_PIN AK24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_RX_LOAD    ]; ## LA03_P
set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_SCL        ]; ## LA03_N

set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB1       ]; ## LA10_P
set_property -dict {PACKAGE_PIN AG23 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB3       ]; ## LA10_N
set_property -dict {PACKAGE_PIN H36  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB5       ]; ## LA11_P
set_property -dict {PACKAGE_PIN H37  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_SDA        ]; ## LA11_N
set_property -dict {PACKAGE_PIN G38  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB2       ]; ## LA14_P
set_property -dict {PACKAGE_PIN AJ24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB4       ]; ## LA12_N
set_property -dict {PACKAGE_PIN H31  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_5V_CTRL    ]; ## LA13_P
set_property -dict {PACKAGE_PIN H32  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_PWR_UP_DOWN]; ## LA13_N

# Stingray 1
set_property -dict {PACKAGE_PIN AR25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_PA_ON      ]; ## LA04_P
set_property -dict {PACKAGE_PIN AT25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_MOSI       ]; ## LA04_N
set_property -dict {PACKAGE_PIN AJ25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_MISO       ]; ## LA05_P
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_SCLK       ]; ## LA05_N
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_TR         ]; ## LA06_P
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_TX_LOAD    ]; ## LA06_N
set_property -dict {PACKAGE_PIN AW24 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_RX_LOAD    ]; ## LA07_P
set_property -dict {PACKAGE_PIN AW25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_SCL        ]; ## LA07_N

set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB1       ]; ## LA12_P
set_property -dict {PACKAGE_PIN G39  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB3       ]; ## LA14_N
set_property -dict {PACKAGE_PIN F37  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB5       ]; ## LA15_P
set_property -dict {PACKAGE_PIN E37  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_SDA        ]; ## LA15_N
set_property -dict {PACKAGE_PIN AM23 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB2       ]; ## LA16_P
set_property -dict {PACKAGE_PIN AM24 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB4       ]; ## LA16_N
set_property -dict {PACKAGE_PIN G35  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_5V_CTRL    ]; ## LA17_P
set_property -dict {PACKAGE_PIN G36  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_PWR_UP_DOWN]; ## LA17_N


# XUD #1 custom break out board
# FMC

set_property -dict {PACKAGE_PIN F38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_csb  ]; ## LA23_P
set_property -dict {PACKAGE_PIN H39 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_mosi ]; ## LA22_N
set_property -dict {PACKAGE_PIN H38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_miso ]; ## LA22_P
set_property -dict {PACKAGE_PIN B34 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_sclk ]; ## LA21_N
set_property -dict {PACKAGE_PIN B33 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio0]; ## LA21_P

set_property -dict {PACKAGE_PIN E39 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio1]; ## LA27_P
set_property -dict {PACKAGE_PIN A38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio2]; ## LA26_N
set_property -dict {PACKAGE_PIN A37 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio3]; ## LA26_P
set_property -dict {PACKAGE_PIN B38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio4]; ## LA25_N
set_property -dict {PACKAGE_PIN C37 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio5]; ## LA25_P

# set_property         -dict {PACKAGE_PIN J32  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_csb    ]; ## LA20_P
# set_property         -dict {PACKAGE_PIN H33  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_mosi   ]; ## LA20_N
# set_property         -dict {PACKAGE_PIN B33  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_miso   ]; ## LA21_P
# set_property         -dict {PACKAGE_PIN B34  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_sclk   ]; ## LA21_N
# set_property         -dict {PACKAGE_PIN H38  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_gpio0  ]; ## LA22_P

# set_property         -dict {PACKAGE_PIN AR22 IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_gpio1  ]; ## LA24_P
# set_property         -dict {PACKAGE_PIN AT22 IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_gpio2  ]; ## LA24_N
# set_property         -dict {PACKAGE_PIN C37  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_gpio3  ]; ## LA25_P
# set_property         -dict {PACKAGE_PIN B38  IOSTANDARD LVCMOS18                                    } [get_ports fmc_bob_xud1_imu_rst    ]; ## LA25_N

# set_property         -dict {PACKAGE_PIN E35  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_sync                 ]; ## LA28_P
# set_property         -dict {PACKAGE_PIN D35  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_enabled              ]; ## LA28_N
# set_property         -dict {PACKAGE_PIN E32  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_rx_en                ]; ## LA29_P
# set_property         -dict {PACKAGE_PIN E33  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_tx_en                ]; ## LA29_N
# set_property         -dict {PACKAGE_PIN AK22 IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_tx_stingray_en       ]; ## LA30_P
# set_property         -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_channel_0            ]; ## LA30_N
# set_property         -dict {PACKAGE_PIN A32  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_channel_1            ]; ## LA31_P
# set_property         -dict {PACKAGE_PIN A33  IOSTANDARD LVCMOS18                                    } [get_ports debug_tdd_sync_out             ]; ## LA31_N

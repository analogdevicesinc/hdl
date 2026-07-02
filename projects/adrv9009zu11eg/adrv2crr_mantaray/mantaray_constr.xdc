###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# Stingray 0
set_property -dict {PACKAGE_PIN AP24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_PA_ON      ]; ## LA00_P
set_property -dict {PACKAGE_PIN AR24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_MOSI       ]; ## LA00_N
set_property -dict {PACKAGE_PIN AP25 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_MISO       ]; ## LA01_P
set_property -dict {PACKAGE_PIN AP26 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_SCLK       ]; ## LA01_N
set_property -dict {PACKAGE_PIN AW27 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_TX_LOAD    ]; ## LA02_N
set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod0_SCL        ]; ## LA03_N

set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB1       ]; ## LA10_P
set_property -dict {PACKAGE_PIN AG23 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB3       ]; ## LA10_N
set_property -dict {PACKAGE_PIN H37  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_SDA        ]; ## LA11_N
set_property -dict {PACKAGE_PIN G38  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB2       ]; ## LA14_P
set_property -dict {PACKAGE_PIN AJ24 IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_CSB4       ]; ## LA12_N
set_property -dict {PACKAGE_PIN H31  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_5V_CTRL    ]; ## LA13_P
set_property -dict {PACKAGE_PIN H32  IOSTANDARD LVCMOS18                                    } [get_ports stingray0_pmod1_PWR_UP_DOWN]; ## LA13_N

set_property DRIVE 12 [get_ports stingray0_pmod1_CSB1]
set_property DRIVE 12 [get_ports stingray0_pmod1_CSB2]
set_property DRIVE 12 [get_ports stingray0_pmod1_CSB3]
set_property DRIVE 12 [get_ports stingray0_pmod1_CSB4]
set_property DRIVE 12 [get_ports stingray0_pmod0_MOSI]
set_property DRIVE 12 [get_ports stingray0_pmod0_MISO]
set_property DRIVE 12 [get_ports stingray0_pmod0_SCLK]

# Stingray 1
set_property -dict {PACKAGE_PIN AT25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_MOSI       ]; ## LA04_N
set_property -dict {PACKAGE_PIN AJ25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_MISO       ]; ## LA05_P
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_SCLK       ]; ## LA05_N
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_TR         ]; ## LA06_P
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_TX_LOAD    ]; ## LA06_N
set_property -dict {PACKAGE_PIN AW25 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod0_SCL        ]; ## LA07_N

set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB1       ]; ## LA12_P
set_property -dict {PACKAGE_PIN G39  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB3       ]; ## LA14_N
set_property -dict {PACKAGE_PIN E37  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_SDA        ]; ## LA15_N
set_property -dict {PACKAGE_PIN AM23 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB2       ]; ## LA16_P
set_property -dict {PACKAGE_PIN AM24 IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_CSB4       ]; ## LA16_N
set_property -dict {PACKAGE_PIN G35  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_5V_CTRL    ]; ## LA17_P
set_property -dict {PACKAGE_PIN G36  IOSTANDARD LVCMOS18                                    } [get_ports stingray1_pmod1_PWR_UP_DOWN]; ## LA17_N

set_property DRIVE 12 [get_ports stingray1_pmod1_CSB1]
set_property DRIVE 12 [get_ports stingray1_pmod1_CSB2]
set_property DRIVE 12 [get_ports stingray1_pmod1_CSB3]
set_property DRIVE 12 [get_ports stingray1_pmod1_CSB4]
set_property DRIVE 12 [get_ports stingray1_pmod0_MOSI]
set_property DRIVE 12 [get_ports stingray1_pmod0_MISO]
set_property DRIVE 12 [get_ports stingray1_pmod0_SCLK]

set_property -dict {PACKAGE_PIN AK24 IOSTANDARD LVCMOS18} [get_ports FPGA_TRIG]
set_property -dict {PACKAGE_PIN AW24 IOSTANDARD LVCMOS18} [get_ports UDC_PG]
set_property -dict {PACKAGE_PIN AW26 IOSTANDARD LVCMOS18} [get_ports TR_PULSE]
set_property -dict {PACKAGE_PIN AR25 IOSTANDARD LVCMOS18} [get_ports TX_LOAD]
set_property -dict {PACKAGE_PIN H36  IOSTANDARD LVCMOS18} [get_ports RX_LOAD]
set_property -dict {PACKAGE_PIN E35  IOSTANDARD LVCMOS18} [get_ports FPGA_BOOT_GOOD]

set_property -dict {PACKAGE_PIN AR22 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_SCLK]
set_property -dict {PACKAGE_PIN B33  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_CSB]
set_property -dict {PACKAGE_PIN F37  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports CMD_SPI_MOSI]
set_property -dict {PACKAGE_PIN C38  IOSTANDARD LVCMOS18          } [get_ports CMD_SPI_MISO]

set_property -dict {PACKAGE_PIN V10} [get_ports aurora_refclk_p]; # MGTREFCLK1P_228
set_property -dict {PACKAGE_PIN V11} [get_ports aurora_refclk_n]; # MGTREFCLK1N_228

set_property -dict {PACKAGE_PIN T6} [get_ports aurora_txp[0]]; # MGTHTXP3_228
set_property -dict {PACKAGE_PIN T5} [get_ports aurora_txn[0]]; # MGTHTXN3_228
set_property -dict {PACKAGE_PIN R8} [get_ports aurora_txp[1]]; # MGTHTXP1_228
set_property -dict {PACKAGE_PIN R7} [get_ports aurora_txn[1]]; # MGTHTXN1_228
set_property -dict {PACKAGE_PIN T2} [get_ports aurora_rxp[0]]; # MGTHRXP3_228
set_property -dict {PACKAGE_PIN T1} [get_ports aurora_rxn[0]]; # MGTHRXN3_228
set_property -dict {PACKAGE_PIN R4} [get_ports aurora_rxp[1]]; # MGTHRXP1_228
set_property -dict {PACKAGE_PIN R3} [get_ports aurora_rxn[1]]; # MGTHRXN1_228

# XUD #1 custom break out board
# FMC

set_property -dict {PACKAGE_PIN F38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_csb  ]; ## LA23_P
set_property -dict {PACKAGE_PIN H39 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_mosi ]; ## LA22_N
set_property -dict {PACKAGE_PIN H38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_miso ]; ## LA22_P
set_property -dict {PACKAGE_PIN B34 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_sclk ]; ## LA21_N

set_property -dict {PACKAGE_PIN E39 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio1]; ## LA27_P
set_property -dict {PACKAGE_PIN A38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio2]; ## LA26_N
set_property -dict {PACKAGE_PIN A37 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio3]; ## LA26_P
set_property -dict {PACKAGE_PIN B38 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio4]; ## LA25_N
set_property -dict {PACKAGE_PIN C37 IOSTANDARD LVCMOS18                                     } [get_ports fmc_bob_xud1_gpio5]; ## LA25_P

create_clock -name aurora_ref_clk -period 8.13802 [get_ports aurora_refclk_p]

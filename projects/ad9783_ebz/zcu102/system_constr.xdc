###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
# ad9783

# dac_clk_in_p
set_property  -dict {PACKAGE_PIN  AA7   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports dco1_p]            ; ## H04  FMC_HPC0_CLK0_M2C_P
# dac_clk_in_n
set_property  -dict {PACKAGE_PIN  AA6   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports dco1_n]            ; ## H05  FMC_HPC0_CLK0_M2C_N
# dac_clk_out_p
set_property  -dict {PACKAGE_PIN  Y4    IOSTANDARD LVDS} [get_ports dci_p]                                    ; ## G6   FMC_HPC0_LA00_CC_P
# dac_clk_out_n
set_property  -dict {PACKAGE_PIN  Y3    IOSTANDARD LVDS} [get_ports dci_n]                                    ; ## G7   FMC_HPC0_LA00_CC_N

set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVDS} [get_ports data_p[0]]                                ; ## H19  FMC_HPC0_LA15_P
set_property  -dict {PACKAGE_PIN  Y9    IOSTANDARD LVDS} [get_ports data_n[0]]                                ; ## H20  FMC_HPC0_LA15_N
set_property  -dict {PACKAGE_PIN  AC7   IOSTANDARD LVDS} [get_ports data_p[1]]                                ; ## C18  FMC_HPC0_LA14_P
set_property  -dict {PACKAGE_PIN  AC6   IOSTANDARD LVDS} [get_ports data_n[1]]                                ; ## C19  FMC_HPC0_LA14_N
set_property  -dict {PACKAGE_PIN  Y12   IOSTANDARD LVDS} [get_ports data_p[2]]                                ; ## G18  FMC_HPC0_LA16_P
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVDS} [get_ports data_n[2]]                                ; ## G19  FMC_HPC0_LA16_N
set_property  -dict {PACKAGE_PIN  W2    IOSTANDARD LVDS} [get_ports data_p[3]]                                ; ## D14  FMC_HPC0_LA09_P
set_property  -dict {PACKAGE_PIN  W1    IOSTANDARD LVDS} [get_ports data_n[3]]                                ; ## D15  FMC_HPC0_LA09_N
set_property  -dict {PACKAGE_PIN  AB8   IOSTANDARD LVDS} [get_ports data_p[4]]                                ; ## D17  FMC_HPC0_LA13_P
set_property  -dict {PACKAGE_PIN  AC8   IOSTANDARD LVDS} [get_ports data_n[4]]                                ; ## D18  FMC_HPC0_LA13_N
set_property  -dict {PACKAGE_PIN  AB6   IOSTANDARD LVDS} [get_ports data_p[5]]                                ; ## H16  FMC_HPC0_LA11_P
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVDS} [get_ports data_n[5]]                                ; ## H17  FMC_HPC0_LA11_N
set_property  -dict {PACKAGE_PIN  W7    IOSTANDARD LVDS} [get_ports data_p[6]]                                ; ## G15  FMC_HPC0_LA12_P
set_property  -dict {PACKAGE_PIN  W6    IOSTANDARD LVDS} [get_ports data_n[6]]                                ; ## G16  FMC_HPC0_LA12_N
set_property  -dict {PACKAGE_PIN  AB3   IOSTANDARD LVDS} [get_ports data_p[7]]                                ; ## D11  FMC_HPC0_LA05_P
set_property  -dict {PACKAGE_PIN  AC3   IOSTANDARD LVDS} [get_ports data_n[7]]                                ; ## D12  FMC_HPC0_LA05_N
set_property  -dict {PACKAGE_PIN  W5    IOSTANDARD LVDS} [get_ports data_p[8]]                                ; ## C14  FMC_HPC0_LA10_P
set_property  -dict {PACKAGE_PIN  W4    IOSTANDARD LVDS} [get_ports data_n[8]]                                ; ## C15  FMC_HPC0_LA10_N
set_property  -dict {PACKAGE_PIN  U5    IOSTANDARD LVDS} [get_ports data_p[9]]                                ; ## H13  FMC_HPC0_LA07_P
set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD LVDS} [get_ports data_n[9]]                                ; ## H14  FMC_HPC0_LA07_N
set_property  -dict {PACKAGE_PIN  V4    IOSTANDARD LVDS} [get_ports data_p[10]]                               ; ## G12  FMC_HPC0_LA08_P
set_property  -dict {PACKAGE_PIN  V3    IOSTANDARD LVDS} [get_ports data_n[10]]                               ; ## G13  FMC_HPC0_LA08_N
set_property  -dict {PACKAGE_PIN  AC2   IOSTANDARD LVDS} [get_ports data_p[11]]                               ; ## C10  FMC_HPC0_LA06_P
set_property  -dict {PACKAGE_PIN  AC1   IOSTANDARD LVDS} [get_ports data_n[11]]                               ; ## C11  FMC_HPC0_LA06_N
set_property  -dict {PACKAGE_PIN  Y2    IOSTANDARD LVDS} [get_ports data_p[12]]                               ; ## G9   FMC_HPC0_LA03_P
set_property  -dict {PACKAGE_PIN  Y1    IOSTANDARD LVDS} [get_ports data_n[12]]                               ; ## G10  FMC_HPC0_LA03_N
set_property  -dict {PACKAGE_PIN  V2    IOSTANDARD LVDS} [get_ports data_p[13]]                               ; ## H7   FMC_HPC0_LA02_P
set_property  -dict {PACKAGE_PIN  V1    IOSTANDARD LVDS} [get_ports data_n[13]]                               ; ## H8   FMC_HPC0_LA02_N
set_property  -dict {PACKAGE_PIN  AA2   IOSTANDARD LVDS} [get_ports data_p[14]]                               ; ## H10  FMC_HPC0_LA04_P
set_property  -dict {PACKAGE_PIN  AA1   IOSTANDARD LVDS} [get_ports data_n[14]]                               ; ## H11  FMC_HPC0_LA04_N
set_property  -dict {PACKAGE_PIN  T8    IOSTANDARD LVDS} [get_ports data_p[15]]                               ; ## G2   FMC_HPC0_CLK1_M2C_P
set_property  -dict {PACKAGE_PIN  R8    IOSTANDARD LVDS} [get_ports data_n[15]]                               ; ## G3   FMC_HPC0_CLK1_M2C_N

set_property  -dict {PACKAGE_PIN  B21   IOSTANDARD LVCMOS33} [get_ports spi_clk]                              ; ## IO_L10N_AD2N_47
set_property  -dict {PACKAGE_PIN  C21   IOSTANDARD LVCMOS33} [get_ports spi_dio]                              ; ## IO_L10P_AD2P_47
set_property  -dict {PACKAGE_PIN  C22   IOSTANDARD LVCMOS33} [get_ports spi_do]                               ; ## IO_L9N_AD3N_47
set_property  -dict {PACKAGE_PIN  D21   IOSTANDARD LVCMOS33} [get_ports spi_en]                               ; ## IO_L9P_AD3P_47

# clocks

create_clock -name dco_p  -period  2.00 [get_ports dco1_p]

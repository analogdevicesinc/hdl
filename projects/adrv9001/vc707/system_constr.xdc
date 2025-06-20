###############################################################################
## Copyright (C) 2021-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
#                     !!! WARNING !!!
#
#  This project must run on a board where VADJ is programmed to 1.8 V
#
#                     !!! WARNING !!!
#

set_property  -dict {PACKAGE_PIN AF39	 IOSTANDARD LVCMOS18}  [get_ports dev_clk_out]          ; ## H04  FMC2_HPC_CLK0_M2C_P

set_property  -dict {PACKAGE_PIN AJ40	 IOSTANDARD LVCMOS18}  [get_ports dgpio_0]              ; ## G18  FMC2_HPC_LA16_P
set_property  -dict {PACKAGE_PIN AJ41	 IOSTANDARD LVCMOS18}  [get_ports dgpio_1]              ; ## G19  FMC2_HPC_LA16_N
set_property  -dict {PACKAGE_PIN AC39	 IOSTANDARD LVCMOS18}  [get_ports dgpio_2]              ; ## H20  FMC2_HPC_LA15_N
set_property  -dict {PACKAGE_PIN AA42	 IOSTANDARD LVCMOS18}  [get_ports dgpio_3]              ; ## H17  FMC2_HPC_LA11_N
set_property  -dict {PACKAGE_PIN AK38	 IOSTANDARD LVCMOS18}  [get_ports dgpio_4]              ; ## D15  FMC2_HPC_LA09_N
set_property  -dict {PACKAGE_PIN AB42	 IOSTANDARD LVCMOS18}  [get_ports dgpio_5]              ; ## C15  FMC2_HPC_LA10_N
set_property  -dict {PACKAGE_PIN P32	 IOSTANDARD LVCMOS18}  [get_ports dgpio_6]              ; ## C26  FMC2_HPC_LA27_P
set_property  -dict {PACKAGE_PIN N33	 IOSTANDARD LVCMOS18}  [get_ports dgpio_7]              ; ## D26  FMC2_HPC_LA26_P
set_property  -dict {PACKAGE_PIN V35	 IOSTANDARD LVCMOS18}  [get_ports dgpio_8]              ; ## H31  FMC2_HPC_LA28_P
set_property  -dict {PACKAGE_PIN V36	 IOSTANDARD LVCMOS18}  [get_ports dgpio_9]              ; ## H32  FMC2_HPC_LA28_N
set_property  -dict {PACKAGE_PIN Y42	 IOSTANDARD LVCMOS18}  [get_ports dgpio_10]             ; ## H16  FMC2_HPC_LA11_P
set_property  -dict {PACKAGE_PIN P33	 IOSTANDARD LVCMOS18}  [get_ports dgpio_11]             ; ## C27  FMC2_HPC_LA27_N

set_property  -dict {PACKAGE_PIN T32	 IOSTANDARD LVCMOS18}  [get_ports gp_int]               ; ## H34  FMC2_HPC_LA30_P
set_property  -dict {PACKAGE_PIN W40	 IOSTANDARD LVCMOS18}  [get_ports mode]                 ; ## D17  FMC2_HPC_LA13_P
set_property  -dict {PACKAGE_PIN Y40	 IOSTANDARD LVCMOS18}  [get_ports reset_trx]            ; ## D18  FMC2_HPC_LA13_N

set_property  -dict {PACKAGE_PIN AB41	 IOSTANDARD LVCMOS18}  [get_ports rx1_enable]           ; ## C14  FMC2_HPC_LA10_P
set_property  -dict {PACKAGE_PIN N34	 IOSTANDARD LVCMOS18}  [get_ports rx2_enable]           ; ## D27  FMC2_HPC_LA26_N

set_property  -dict {PACKAGE_PIN AF40	 IOSTANDARD LVCMOS18}  [get_ports sm_fan_tach]          ; ## H05  FMC2_HPC_CLK0_M2C_N

set_property  -dict {PACKAGE_PIN Y39	 IOSTANDARD LVCMOS18}  [get_ports spi_clk]              ; ## G15  FMC2_HPC_LA12_P
set_property  -dict {PACKAGE_PIN W37	 IOSTANDARD LVCMOS18}  [get_ports spi_dio]              ; ## G31  FMC2_HPC_LA29_N
set_property  -dict {PACKAGE_PIN AA39	 IOSTANDARD LVCMOS18}  [get_ports spi_do]               ; ## G16  FMC2_HPC_LA12_N
set_property  -dict {PACKAGE_PIN AC38	 IOSTANDARD LVCMOS18}  [get_ports spi_en]               ; ## H19  FMC2_HPC_LA15_P

set_property  -dict {PACKAGE_PIN AJ38	 IOSTANDARD LVCMOS18}  [get_ports tx1_enable]           ; ## D14  FMC2_HPC_LA09_P
set_property  -dict {PACKAGE_PIN W36	 IOSTANDARD LVCMOS18}  [get_ports tx2_enable]           ; ## G30  FMC2_HPC_LA29_P

set_property  -dict {PACKAGE_PIN V39	 IOSTANDARD LVCMOS18}  [get_ports vadj_err]             ; ## G33  FMC2_HPC_LA31_P
set_property  -dict {PACKAGE_PIN V40	 IOSTANDARD LVCMOS18}  [get_ports platform_status]      ; ## G34  FMC2_HPC_LA31_N


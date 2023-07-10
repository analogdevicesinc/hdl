###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# constraints
# adrv9001

set_property  -dict {PACKAGE_PIN L18  IOSTANDARD LVCMOS18}  [get_ports dev_clk_out]       ; # H04 FMC_HPC0_CLK0_M2C_P  IO_L12P_T1_MRCC_34

set_property  -dict {PACKAGE_PIN J20  IOSTANDARD LVCMOS18}  [get_ports dgpio_0]           ; # G18 FMC_HPC0_LA16_P      IO_L9P_T1_DQS_34
set_property  -dict {PACKAGE_PIN K21  IOSTANDARD LVCMOS18}  [get_ports dgpio_1]           ; # G19 FMC_HPC0_LA16_N      IO_L9N_T1_DQS_34
set_property  -dict {PACKAGE_PIN J17  IOSTANDARD LVCMOS18}  [get_ports dgpio_2]           ; # H20 FMC_HPC0_LA15_N      IO_L2N_T0_34
set_property  -dict {PACKAGE_PIN N18  IOSTANDARD LVCMOS18}  [get_ports dgpio_3]           ; # H17 FMC_HPC0_LA11_N      IO_L5N_T0_34
set_property  -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS18}  [get_ports dgpio_4]           ; # D15 FMC_HPC0_LA09_N      IO_L17N_T2_34
set_property  -dict {PACKAGE_PIN T19  IOSTANDARD LVCMOS18}  [get_ports dgpio_5]           ; # C15 FMC_HPC0_LA10_N      IO_L22N_T3_34
set_property  -dict {PACKAGE_PIN E21  IOSTANDARD LVCMOS18}  [get_ports dgpio_6]           ; # C26 FMC_HPC0_LA27_P      IO_L17P_T2_AD5P_35
set_property  -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS18}  [get_ports dgpio_7]           ; # D26 FMC_HPC0_LA26_P      IO_L5P_T0_AD9P_35
set_property  -dict {PACKAGE_PIN A16  IOSTANDARD LVCMOS18}  [get_ports dgpio_8]           ; # H31 FMC_HPC0_LA28_P      IO_L9P_T1_DQS_AD3P_35
set_property  -dict {PACKAGE_PIN A17  IOSTANDARD LVCMOS18}  [get_ports dgpio_9]           ; # H32 FMC_HPC0_LA28_N      IO_L9N_T1_DQS_AD3N_35
set_property  -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS18}  [get_ports dgpio_10]          ; # H16 FMC_HPC0_LA11_P      IO_L5P_T0_34
set_property  -dict {PACKAGE_PIN D21  IOSTANDARD LVCMOS18}  [get_ports dgpio_11]          ; # C27 FMC_HPC0_LA27_N      IO_L17N_T2_AD5N_35

set_property  -dict {PACKAGE_PIN C15  IOSTANDARD LVCMOS18}  [get_ports gp_int]            ; # H34 FMC_HPC0_LA30_P      IO_L7P_T1_AD2P_35
set_property  -dict {PACKAGE_PIN L17  IOSTANDARD LVCMOS18}  [get_ports mode]              ; # D17 FMC_HPC0_LA13_P      IO_L4P_T0_34
set_property  -dict {PACKAGE_PIN M17  IOSTANDARD LVCMOS18}  [get_ports reset_trx]         ; # D18 FMC_HPC0_LA13_N      IO_L4N_T0_34

set_property  -dict {PACKAGE_PIN R19  IOSTANDARD LVCMOS18}  [get_ports rx1_enable]        ; # C14 FMC_HPC0_LA10_P      IO_L22P_T3_34
set_property  -dict {PACKAGE_PIN E18  IOSTANDARD LVCMOS18}  [get_ports rx2_enable]        ; # D27 FMC_HPC0_LA26_N      IO_L5N_T0_AD9N_35

set_property  -dict {PACKAGE_PIN L19  IOSTANDARD LVCMOS18}  [get_ports sm_fan_tach]       ; # H05 FMC_HPC0_CLK0_M2C_N  IO_L12N_T1_MRCC_34

set_property  -dict {PACKAGE_PIN P20  IOSTANDARD LVCMOS18}  [get_ports spi_clk]           ; # G15 FMC_HPC0_LA12_P      IO_L18P_T2_34
set_property  -dict {PACKAGE_PIN C18  IOSTANDARD LVCMOS18}  [get_ports spi_dio]           ; # G31 FMC_HPC0_LA29_N      IO_L11N_T1_SRCC_35
set_property  -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS18}  [get_ports spi_do]            ; # G16 FMC_HPC0_LA12_N      IO_L18N_T2_34
set_property  -dict {PACKAGE_PIN J16  IOSTANDARD LVCMOS18}  [get_ports spi_en]            ; # H19 FMC_HPC0_LA15_P      IO_L2P_T0_34

set_property  -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS18}  [get_ports tx1_enable]        ; # D14 FMC_HPC0_LA09_P      IO_L17P_T2_34
set_property  -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS18}  [get_ports tx2_enable]        ; # G30 FMC_HPC0_LA29_P      IO_L11P_T1_SRCC_35

set_property  -dict {PACKAGE_PIN B16  IOSTANDARD LVCMOS18}  [get_ports vadj_err]          ; # G33 FMC_HPC0_LA31_P      IO_L8P_T1_AD10P_35
set_property  -dict {PACKAGE_PIN B17  IOSTANDARD LVCMOS18}  [get_ports platform_status]   ; # G34 FMC_HPC0_LA31_N      IO_L8N_T1_AD10N_35

# redefine contraints from common file for VADJ 1.8V
set_property  -dict {PACKAGE_PIN  L16   IOSTANDARD LVCMOS18} [get_ports otg_vbusoc]
set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]       ; ## BTNC
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS18} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS18} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS18} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS18} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[18]]      ; ## SW7
set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS18} [get_ports gpio_bd[30]]      ; ## XADC-GIO3
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS18} [get_ports gpio_bd[31]]      ; ## OTG-RESETN

set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS33} [get_ports  tdd_sync]        ; ## JA1.JA1 



###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

# AD485x
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25}                          [get_ports lvds_cmos_n]  ; ##  C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25}                          [get_ports pd]           ; ##  H08  FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25}                          [get_ports cnv]          ; ##  H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25}                          [get_ports busy]         ; ##  C11  FMC_LPC_LA06_N

# SPI
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25}                          [get_ports csck]         ; ##  D14  FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25}                          [get_ports csdio]        ; ##  D17  FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25}                          [get_ports cs_n]         ; ##  D18  FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25}                          [get_ports csdo]         ; ##  D27  FMC_LPC_LA26_N

# LVDS
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25}                           [get_ports scki_p]       ; ##  D08  FMC_LPC_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25}                           [get_ports scki_n]       ; ##  D09  FMC_LPC_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports sdo_p]        ; ##  C26  FMC_LPC_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports sdo_n]        ; ##  C27  FMC_LPC_LA27_N        # SD0-
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports scko_p]       ; ##  D20  FMC_LPC_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports scko_n]       ; ##  D21  FMC_LPC_LA17_CC_N     # scko-

# spi pmod JA1

set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33}                         [get_ports pmod_sdi]     ; ## JA1
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33}                         [get_ports pmod_cs_n]    ; ## JA2
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33}                         [get_ports pmod_sck]     ; ## JA3
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33}                         [get_ports pmod_sdo]     ; ## JA4

create_clock -period 2.5 -name scko [get_ports scko_p]
set_false_path -from [get_clocks scko] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]]

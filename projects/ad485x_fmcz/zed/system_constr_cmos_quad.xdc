###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################
# AD4851, AD4852, AD4853, AD4854
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25}                          [get_ports lvds_cmos_n]  ; ##  C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25}                          [get_ports pd]           ; ##  H08  FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25}                          [get_ports cnv]          ; ##  H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25}                          [get_ports busy]         ; ##  C11  FMC_LPC_LA06_N

# SPI
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25}                          [get_ports csck]         ; ##  D14  FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25}                          [get_ports csdio]        ; ##  D17  FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25}                          [get_ports cs_n]         ; ##  D18  FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25}                          [get_ports csd0]         ; ##  D27  FMC_LPC_LA26_N

# CMOS
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports scki]         ; ##  D20  FMC_LPC_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports scko]         ; ##  D21  FMC_LPC_LA17_CC_N     # scko-
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports sdo[0]]       ; ##  D08  FMC_LPC_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports sdo[1]]       ; ##  D09  FMC_LPC_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25} [get_ports sdo[2]]       ; ##  C26  FMC_LPC_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS25} [get_ports sdo[3]]       ; ##  C27  FMC_LPC_LA27_N

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {scko_IBUF}]

create_clock -name scko_cmos       -period  10 [get_ports scko]
set_max_delay -from [get_clocks scko_cmos] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]] 10.0
set_min_delay -from [get_clocks scko_cmos] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]] 1.0

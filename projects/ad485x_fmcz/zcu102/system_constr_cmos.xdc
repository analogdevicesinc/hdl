
set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18} [get_ports lvds_cmos_n]  ; ##  C10  FMC_HPC0_LA06_P
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18} [get_ports busy]         ; ##  C11  FMC_HPC0_LA06_N
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS18} [get_ports sdo[0]]       ; ##  D08  FMC_HPC0_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN W4  IOSTANDARD LVCMOS18} [get_ports sdo[1]]       ; ##  C15  FMC_HPC0_LA10_N
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports sdo[2]]       ; ##  D09  FMC_HPC0_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVCMOS18} [get_ports sdo[3]]       ; ##  C18  FMC_HPC0_LA14_P
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18} [get_ports sdo[4]]       ; ##  D11  FMC_HPC0_LA05_P
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS18} [get_ports sdo[5]]       ; ##  C26  FMC_HPC0_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS18} [get_ports sdo[6]]       ; ##  D12  FMC_HPC0_LA05_N        # SD0-
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS18} [get_ports sdo[7]]       ; ##  C27  FMC_HPC0_LA27_N

set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS18} [get_ports csck]         ; ##  D14  FMC_HPC0_LA09_P
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18} [get_ports csdio]        ; ##  D17  FMC_HPC0_LA13_P
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18} [get_ports cs_n]         ; ##  D18  FMC_HPC0_LA13_N
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVCMOS18} [get_ports scki]         ; ##  D20  FMC_HPC0_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS18} [get_ports scko]         ; ##  D21  FMC_HPC0_LA17_CC_N     # scko-
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports csdo]         ; ##  D27  FMC_HPC0_LA26_N

set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18} [get_ports cnv]          ; ##  H07  FMC_HPC0_LA02_P
set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS18} [get_ports pd]           ; ##  H08  FMC_HPC0_LA02_N

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {scko_IBUF}]

create_clock -name scko_cmos       -period  10 [get_ports scko]

set_max_delay -from [get_clocks scko_cmos] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]] 10.0
set_min_delay -from [get_clocks scko_cmos] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]] 1.0


set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS18}                          [get_ports adc_0_lvds_cmos_n]  ; ##  C10  FMC_HPC0_LA06_P
set_property -dict {PACKAGE_PIN AC1 IOSTANDARD LVCMOS18}                          [get_ports adc_0_busy]         ; ##  C11  FMC_HPC0_LA06_N
set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVDS}                              [get_ports adc_0_scki_p]       ; ##  D08  FMC_HPC0_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVDS}                              [get_ports adc_0_scki_n]       ; ##  D09  FMC_HPC0_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_0_sdo_p]        ; ##  C26  FMC_HPC0_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_0_sdo_n]        ; ##  C27  FMC_HPC0_LA27_N        # SD0-
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_0_scko_p]       ; ##  D20  FMC_HPC0_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_0_scko_n]       ; ##  D21  FMC_HPC0_LA17_CC_N     # scko-

set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS18}                          [get_ports adc_0_csck]         ; ##  D14  FMC_HPC0_LA09_P
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18}                          [get_ports adc_0_csdio]        ; ##  D17  FMC_HPC0_LA13_P
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18}                          [get_ports adc_0_cs_n]         ; ##  D18  FMC_HPC0_LA13_N
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18}                          [get_ports adc_0_csdo]         ; ##  D27  FMC_HPC0_LA26_N
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS18}                          [get_ports adc_0_cnv]          ; ##  H07  FMC_HPC0_LA02_P
set_property -dict {PACKAGE_PIN V1  IOSTANDARD LVCMOS18}                          [get_ports adc_0_pd]           ; ##  H08  FMC_HPC0_LA02_N

set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVCMOS18}                          [get_ports adc_1_lvds_cmos_n]  ; ##  C10  FMC_HPC1_LA06_P
set_property -dict {PACKAGE_PIN AJ2 IOSTANDARD LVCMOS18}                          [get_ports adc_1_busy]         ; ##  C11  FMC_HPC1_LA06_N
set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD LVDS}                              [get_ports adc_1_scki_p]       ; ##  D08  FMC_HPC1_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN AJ5 IOSTANDARD LVDS}                              [get_ports adc_1_scki_n]       ; ##  D09  FMC_HPC1_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_1_sdo_p]        ; ##  C26  FMC_HPC1_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_1_sdo_n]        ; ##  C27  FMC_HPC1_LA27_N        # SD0-
set_property -dict {PACKAGE_PIN Y5  IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_1_scko_p]       ; ##  D20  FMC_HPC1_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVDS DIFF_TERM TRUE}               [get_ports adc_1_scko_n]       ; ##  D21  FMC_HPC1_LA17_CC_N     # scko-

set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS18}                          [get_ports adc_1_csck]         ; ##  D14  FMC_HPC1_LA09_P
set_property -dict {PACKAGE_PIN AG8  IOSTANDARD LVCMOS18}                          [get_ports adc_1_csdio]        ; ##  D17  FMC_HPC1_LA13_P
set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVCMOS18}                          [get_ports adc_1_cs_n]         ; ##  D18  FMC_HPC1_LA13_N
set_property -dict {PACKAGE_PIN R12  IOSTANDARD LVCMOS18}                          [get_ports adc_1_csdo]         ; ##  D27  FMC_HPC1_LA26_N
set_property -dict {PACKAGE_PIN AD2  IOSTANDARD LVCMOS18}                          [get_ports adc_1_cnv]          ; ##  H07  FMC_HPC1_LA02_P
set_property -dict {PACKAGE_PIN AD1  IOSTANDARD LVCMOS18}                          [get_ports adc_1_pd]           ; ##  H08  FMC_HPC1_LA02_N

create_clock -name scko_0 -period  2 [get_ports adc_0_scko_p]
create_clock -name scko_1 -period  2 [get_ports adc_1_scko_p]

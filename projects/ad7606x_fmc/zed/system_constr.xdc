
# ad7606x

set_property -dict {PACKAGE_PIN N19     IOSTANDARD LVCMOS25} [get_ports adc_db[0] ]         ; ## D08 FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20     IOSTANDARD LVCMOS25} [get_ports adc_db[1] ]         ; ## D09 FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN P18     IOSTANDARD LVCMOS25} [get_ports adc_db[2] ]         ; ## H08 FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN P22     IOSTANDARD LVCMOS25} [get_ports adc_db[3] ]         ; ## G10 FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M22     IOSTANDARD LVCMOS25} [get_ports adc_db[4] ]         ; ## H11 FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN T17     IOSTANDARD LVCMOS25} [get_ports adc_db[5] ]         ; ## H14 FMC_LPC_LA07_N
set_property -dict {PACKAGE_PIN J22     IOSTANDARD LVCMOS25} [get_ports adc_db[6] ]         ; ## G13 FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN M20     IOSTANDARD LVCMOS25} [get_ports adc_db[7] ]         ; ## G07 FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN L22     IOSTANDARD LVCMOS25} [get_ports adc_db[8] ]         ; ## C11 FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN J18     IOSTANDARD LVCMOS25} [get_ports adc_db[9] ]         ; ## D11 FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN R20     IOSTANDARD LVCMOS25} [get_ports adc_db[10]]         ; ## D14 FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN N22     IOSTANDARD LVCMOS25} [get_ports adc_db[11]]         ; ## G09 FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN N18     IOSTANDARD LVCMOS25} [get_ports adc_db[12]]         ; ## H17 FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P21     IOSTANDARD LVCMOS25} [get_ports adc_db[13]]         ; ## G16 FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17     IOSTANDARD LVCMOS25} [get_ports adc_db[14]]         ; ## D17 FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17     IOSTANDARD LVCMOS25} [get_ports adc_db[15]]         ; ## D18 FMC_LPC_LA13_N

set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVCMOS25} [get_ports adc_rd_n]           ; ## G06 FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN R19     IOSTANDARD LVCMOS25} [get_ports adc_wr_n]           ; ## C14 FMC_LPC_LA10_P

# control lines
set_property -dict {PACKAGE_PIN T16     IOSTANDARD LVCMOS25} [get_ports adc_busy]           ; ## H13 FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN K18     IOSTANDARD LVCMOS25} [get_ports adc_cnvst_n]        ; ## D12 FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN M21     IOSTANDARD LVCMOS25} [get_ports adc_cs_n]           ; ## H10 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN J21     IOSTANDARD LVCMOS25} [get_ports adc_first_data]     ; ## G12 FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN L21     IOSTANDARD LVCMOS25} [get_ports adc_reset]          ; ## C10 FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN P20     IOSTANDARD LVCMOS25} [get_ports adc_os[0]]          ; ## G15 FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P17     IOSTANDARD LVCMOS25} [get_ports adc_os[1]]          ; ## H07 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN N17     IOSTANDARD LVCMOS25} [get_ports adc_os[2]]          ; ## H16 FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN T19     IOSTANDARD LVCMOS25} [get_ports adc_stby]           ; ## C15 FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN R21     IOSTANDARD LVCMOS25} [get_ports adc_range]          ; ## D15 FMC_LPC_LA09_N

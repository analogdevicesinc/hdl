
# ad7616

set_property -dict {PACKAGE_PIN AC14     IOSTANDARD LVCMOS25} [get_ports adc_db[0] ]         ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN AJ15     IOSTANDARD LVCMOS25} [get_ports adc_db[1] ]         ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN AH14     IOSTANDARD LVCMOS25} [get_ports adc_db[2] ]         ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN AG12     IOSTANDARD LVCMOS25} [get_ports adc_db[3] ]         ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN AE15     IOSTANDARD LVCMOS25} [get_ports adc_db[4] ]         ; ## FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN AF12     IOSTANDARD LVCMOS25} [get_ports adc_db[5] ]         ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN AC12     IOSTANDARD LVCMOS25} [get_ports adc_db[6] ]         ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN AF13     IOSTANDARD LVCMOS25} [get_ports adc_db[7] ]         ; ## FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN AE16     IOSTANDARD LVCMOS25} [get_ports adc_db[8] ]         ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN AE12     IOSTANDARD LVCMOS25} [get_ports adc_db[9] ]         ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN AA15     IOSTANDARD LVCMOS25} [get_ports adc_db[10]]         ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN AE13     IOSTANDARD LVCMOS25} [get_ports adc_db[11]]         ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN AG15     IOSTANDARD LVCMOS25} [get_ports adc_db[12]]         ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN AG16     IOSTANDARD LVCMOS25} [get_ports adc_db[13]]         ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN AG17     IOSTANDARD LVCMOS25} [get_ports adc_db[14]]         ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN AF15     IOSTANDARD LVCMOS25} [get_ports adc_db[15]]         ; ## FMC_LPC_LA01_CC_P

set_property -dict {PACKAGE_PIN AH12     IOSTANDARD LVCMOS25} [get_ports adc_rd_n]           ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN AH13     IOSTANDARD LVCMOS25} [get_ports adc_wr_n]           ; ## FMC_LPC_LA09_N

# control lines

set_property -dict {PACKAGE_PIN AF30     IOSTANDARD LVCMOS25} [get_ports adc_convst]         ; ## FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN AH29     IOSTANDARD LVCMOS25} [get_ports adc_chsel[0]]       ; ## FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN AK30     IOSTANDARD LVCMOS25} [get_ports adc_chsel[1]]       ; ## FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN AF29     IOSTANDARD LVCMOS25} [get_ports adc_chsel[2]]       ; ## FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN AH28     IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[0]]   ; ## FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN AJ30     IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[1]]   ; ## FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN AC13     IOSTANDARD LVCMOS25} [get_ports adc_busy]           ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN AJ28     IOSTANDARD LVCMOS25} [get_ports adc_seq_en]         ; ## FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN AK28     IOSTANDARD LVCMOS25} [get_ports adc_reset_n]        ; ## FMC_LPC_LA22_N
set_property -dict {PACKAGE_PIN AK15     IOSTANDARD LVCMOS25} [get_ports adc_cs_n]           ; ## FMC_LPC_LA04_N


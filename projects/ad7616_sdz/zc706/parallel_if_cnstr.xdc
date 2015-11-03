
# ad7616

set_property -dict {PACKAGE_PIN AC14     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[0] ]        ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN AJ15     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[1] ]        ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN AH14     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[2] ]        ; ## FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN AG12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[3] ]        ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN AE15     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[4] ]        ; ## FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN AF12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[5] ]        ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN AC12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[6] ]        ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN AF13     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[7] ]        ; ## FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN AE16     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[8] ]        ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN AE12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[9] ]        ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN AE17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[10]]        ; ## FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN AE13     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[11]]        ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN AG15     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[12]]        ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN AG16     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[13]]        ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN AG17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[14]]        ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN AF15     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db[15]]        ; ## FMC_LPC_LA01_CC_P

set_property -dict {PACKAGE_PIN AH12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports rd_n]          ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN AH13     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports wr_n]          ; ## FMC_LPC_LA09_N

# control lines

set_property -dict {PACKAGE_PIN AF30    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports convst]         ; ## FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN AH29    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports chsel[0]]       ; ## FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN AK30    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports chsel[1]]       ; ## FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN AF29    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports chsel[2]]       ; ## FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN AH28    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports hw_rngsel[0]]   ; ## FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN AJ30    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports hw_rngsel[1]]   ; ## FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN AC13    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports busy]           ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN AJ28    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports seq_en]         ; ## FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN AK28    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports reset_n]        ; ## FMC_LPC_LA22_N
set_property -dict {PACKAGE_PIN AK15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports cs_n]           ; ## FMC_LPC_LA04_N


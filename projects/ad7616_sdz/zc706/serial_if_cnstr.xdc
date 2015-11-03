
# ad7616

# data interface

set_property -dict {PACKAGE_PIN AH12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sclk]          ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN AB12     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sdo]           ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN AE13     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sdi_0]         ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN AG15     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports sdi_1]         ; ## FMC_LPC_LA01_CC_N

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


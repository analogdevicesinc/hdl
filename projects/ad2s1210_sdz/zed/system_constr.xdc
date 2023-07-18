# ad2s1210_sdz

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports sdo]   ; # D08 FMC_LPC_LA01_CC_P    CON_PAR_DATA[15] - j2 110 SDO
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports sdi]   ; # H04 FMC_LPC_CLK0_M2C_P   CON_PAR_DATA[14] - j2  12 SDI
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS25} [get_ports sclk]  ; # H05 FMC_LPC_CLK0_M2C_N   CON_PAR_DATA[13] - j2  13 SCLK
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports cs_n]  ; # H11 FMC_LPC_LA04_N       CON_PAR_CS       - j2  22 PAR_CS_n
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports wr_n]  ; # D15 FMC_LPC_LA09_N       CON_PAR_WR       - j2 100 PAR_WR_n
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports a0]    ; # D18 FMC_LPC_LA13_N       CON_PAR_ADDR[1]  - j2  96 PAR_A0
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports a1]    ; # H13 FMC_LPC_LA07_P       CON_PAR_ADDR[0]  - j2  25 PAR_A1
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS25} [get_ports res_1] ; # D26 FMC_LPC_LA26_P       CON_GPIO[1]      - j2  78 SDP_RES_1
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports res_0] ; # H25 FMC_LPC_LA21_P       CON_GPIO[0]      - j2  43 SDP_RES_0
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS25} [get_ports sample]; # C26 FMC_LPC_LA27_P       CON_GPIO[3]      - j2  77 TMR_A

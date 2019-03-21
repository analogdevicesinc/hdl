
# ad7616

# data interface

set_property -dict {PACKAGE_PIN P22      IOSTANDARD LVCMOS25} [get_ports spi_sclk]            ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN L21      IOSTANDARD LVCMOS25} [get_ports spi_sdo]             ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN M19      IOSTANDARD LVCMOS25} [get_ports spi_sdi_0]           ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N20      IOSTANDARD LVCMOS25} [get_ports spi_sdi_1]           ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN M22      IOSTANDARD LVCMOS25} [get_ports spi_cs_n]            ; ## FMC_LPC_LA04_N

# control lines

set_property -dict {PACKAGE_PIN A18      IOSTANDARD LVCMOS25} [get_ports adc_convst]          ; ## FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN E20      IOSTANDARD LVCMOS25} [get_ports adc_chsel[0]]        ; ## FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN E18      IOSTANDARD LVCMOS25} [get_ports adc_chsel[1]]        ; ## FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN D22      IOSTANDARD LVCMOS25} [get_ports adc_chsel[2]]        ; ## FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN E19      IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[0]]    ; ## FMC_LPC_LA21_P
set_property -dict {PACKAGE_PIN F18      IOSTANDARD LVCMOS25} [get_ports adc_hw_rngsel[1]]    ; ## FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN T19      IOSTANDARD LVCMOS25} [get_ports adc_busy]            ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN E21      IOSTANDARD LVCMOS25} [get_ports adc_seq_en]          ; ## FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN F19      IOSTANDARD LVCMOS25} [get_ports adc_reset_n]         ; ## FMC_LPC_LA22_N

set_property -dict {PACKAGE_PIN L19      IOSTANDARD LVCMOS25} [get_ports adc_os[0]]           ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN L18      IOSTANDARD LVCMOS25} [get_ports adc_os[1]]           ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN N19      IOSTANDARD LVCMOS25} [get_ports adc_os[2]]           ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN R21      IOSTANDARD LVCMOS25} [get_ports adc_burst]           ; ## FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN P18      IOSTANDARD LVCMOS25} [get_ports adc_crcen]           ; ## FMC_LPC_LA02_N


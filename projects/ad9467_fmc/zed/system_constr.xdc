
# ad9467

set_property -dict {PACKAGE_PIN L18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]         ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN L19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]         ; ## FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN J21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]        ; ## FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]        ; ## FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN M20     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]     ; ## FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]     ; ## FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]     ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]     ; ## FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN P17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]     ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]     ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN N22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]     ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]     ; ## FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]     ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]     ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN J18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]     ; ## FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]     ; ## FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN L21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]     ; ## FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN L22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]     ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN T16     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]     ; ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN T17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]     ; ## FMC_LPC_LA07_N

## spi

set_property -dict {PACKAGE_PIN B22     IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                        ; ## FMC_LPC_LA33_N
set_property -dict {PACKAGE_PIN B21     IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                        ; ## FMC_LPC_LA33_P
set_property -dict {PACKAGE_PIN A22     IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ; ## FMC_LPC_LA32_N
set_property -dict {PACKAGE_PIN A21     IOSTANDARD LVCMOS25} [get_ports spi_sdio]                           ; ## FMC_LPC_LA32_P

# clocks
create_clock -name adc_clk      -period 4.00 [get_ports adc_clk_in_p]

set_clock_groups -asynchronous  -group {adc_clk}



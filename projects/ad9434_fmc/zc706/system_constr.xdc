# ad9434

set_property  -dict {PACKAGE_PIN  AE13   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_p]       ; ## G6   FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  AF13   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_n]       ; ## G7   FMC_LPC_LA00_CC_N

set_property  -dict {PACKAGE_PIN  AF15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[0]]    ; ## D08  FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AG15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[0]]    ; ## D09  FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AE16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[1]]    ; ## D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  AE15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[1]]    ; ## D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  AE12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[2]]    ; ## H07  FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  AF12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[2]]    ; ## H08  FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  AG12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[3]]    ; ## G09  FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  AH12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[3]]    ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  AJ15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[4]]    ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  AK15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[4]]    ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  AD14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[5]]    ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  AD13  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[5]]    ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  AA15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[6]]    ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[6]]    ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  AD16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[7]]    ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  AD15  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[7]]    ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  AJ16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[8]]    ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  AK16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[8]]    ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  AH14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[9]]    ; ## D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  AH13  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[9]]    ; ## D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  AC14  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[10]]   ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  AC13  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[10]]   ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  AH17  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_p[11]]   ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  AH16  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_n[11]]   ; ## D18  FMC_LPC_LA13_N

set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_p]         ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  AC12  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_or_n]         ; ## C11  FMC_LPC_LA06_N

# spi

set_property  -dict {PACKAGE_PIN  Y30   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports spi_csn_clk]      ; ## G36  FMC_LPC_LA33_P
set_property  -dict {PACKAGE_PIN  AA30  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports spi_csn_adc]      ; ## G37  FMC_LPC_LA33_N
set_property  -dict {PACKAGE_PIN  Y27   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports spi_sclk]         ; ## H38  FMC_LPC_LA32_N
set_property  -dict {PACKAGE_PIN  Y26   IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports spi_dio[]         ; ## H37  FMC_LPC_LA32_P

# clocks

create_clock -name adc_clk          -period 1.66667 [get_ports adc_clk_in_p]
create_clock -name adc_core_clk     -period 8.00    [get_pins i_system_wrapper/system_i/axi_ad9434/adc_clk]
create_clock -name dma_clk          -period 5.00    [get_pins i_system_wrapper/system_i/sys_ps7/FCLK_CLK2]

set_clock_groups -asynchronous -group {adc_clk}
set_clock_groups -asynchronous -group {adc_core_clk}
set_clock_groups -asynchronous -group {dma_clk}



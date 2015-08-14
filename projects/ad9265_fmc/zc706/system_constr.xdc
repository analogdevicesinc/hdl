
# ad9265

set_property -dict {PACKAGE_PIN AG17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]         ;
set_property -dict {PACKAGE_PIN AG16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]         ;
set_property -dict {PACKAGE_PIN AF15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]        ;
set_property -dict {PACKAGE_PIN AG15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]        ;
set_property -dict {PACKAGE_PIN AH14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]     ;
set_property -dict {PACKAGE_PIN AH13    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]     ;
set_property -dict {PACKAGE_PIN AB12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]     ;
set_property -dict {PACKAGE_PIN AC12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]     ;
set_property -dict {PACKAGE_PIN AA15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]     ;
set_property -dict {PACKAGE_PIN AA14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]     ;
set_property -dict {PACKAGE_PIN AD14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]     ;
set_property -dict {PACKAGE_PIN AD13    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]     ;
set_property -dict {PACKAGE_PIN AJ15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]     ;
set_property -dict {PACKAGE_PIN AK15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]     ;
set_property -dict {PACKAGE_PIN AE16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]     ;
set_property -dict {PACKAGE_PIN AE15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]     ;
set_property -dict {PACKAGE_PIN AE12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]     ;
set_property -dict {PACKAGE_PIN AF12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]     ;
set_property -dict {PACKAGE_PIN AG12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]     ;
set_property -dict {PACKAGE_PIN AH12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]     ;

## spi

set_property -dict {PACKAGE_PIN AA30    IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                        ;
set_property -dict {PACKAGE_PIN Y30     IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                        ;
set_property -dict {PACKAGE_PIN Y27     IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ;
set_property -dict {PACKAGE_PIN Y26     IOSTANDARD LVCMOS25} [get_ports spi_sdio]                           ;

# clocks

create_clock -name adc_clk      -period 3.33 [get_ports adc_clk_in_p]

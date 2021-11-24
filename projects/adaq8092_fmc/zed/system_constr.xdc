
# adaq8092

set_property -dict {PACKAGE_PIN M19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]         ;
set_property -dict {PACKAGE_PIN M20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]         ;
set_property -dict {PACKAGE_PIN P17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]     ;
set_property -dict {PACKAGE_PIN P18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]     ;
set_property -dict {PACKAGE_PIN N22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]     ;
set_property -dict {PACKAGE_PIN P22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]     ;
set_property -dict {PACKAGE_PIN M21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]     ;
set_property -dict {PACKAGE_PIN M22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]     ;
set_property -dict {PACKAGE_PIN J18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]     ;
set_property -dict {PACKAGE_PIN K18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]     ;
set_property -dict {PACKAGE_PIN L21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]     ;
set_property -dict {PACKAGE_PIN L22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]     ;
set_property -dict {PACKAGE_PIN T16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]     ;
set_property -dict {PACKAGE_PIN T17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]     ;
set_property -dict {PACKAGE_PIN J21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]     ;
set_property -dict {PACKAGE_PIN J22    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]     ;
set_property -dict {PACKAGE_PIN R20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]     ;
set_property -dict {PACKAGE_PIN R21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]     ;
set_property -dict {PACKAGE_PIN R19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[8]]     ;
set_property -dict {PACKAGE_PIN T19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[8]]     ;
set_property -dict {PACKAGE_PIN N17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[9]]     ;
set_property -dict {PACKAGE_PIN N18    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[9]]     ;
set_property -dict {PACKAGE_PIN P20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[10]]    ;
set_property -dict {PACKAGE_PIN P21    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[10]]    ;
set_property -dict {PACKAGE_PIN L17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[11]]    ;
set_property -dict {PACKAGE_PIN M17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[11]]    ;
set_property -dict {PACKAGE_PIN K19    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[12]]    ;
set_property -dict {PACKAGE_PIN K20    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[12]]    ;
set_property -dict {PACKAGE_PIN J16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[13]]    ;
set_property -dict {PACKAGE_PIN J17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[13]]    ;

## spi

set_property -dict {PACKAGE_PIN B20    IOSTANDARD LVCMOS25} [get_ports spi_csn]                            ;
set_property -dict {PACKAGE_PIN D20    IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ;
set_property -dict {PACKAGE_PIN B19    IOSTANDARD LVCMOS25} [get_ports spi_sdi]                            ;
set_property -dict {PACKAGE_PIN C20    IOSTANDARD LVCMOS25} [get_ports spi_sdo]                            ;

# other

set_property -dict {PACKAGE_PIN G20    IOSTANDARD LVCMOS25} [get_ports adc_par_nser]                       ;
set_property -dict {PACKAGE_PIN G15    IOSTANDARD LVCMOS25} [get_ports adc_npd[0]]                         ;
set_property -dict {PACKAGE_PIN G16    IOSTANDARD LVCMOS25} [get_ports adc_npd[1]]                         ;

# clocks

create_clock -name adc_clk      -period 3.33 [get_ports adc_clk_in_p]

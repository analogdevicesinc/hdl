
# spi pmod J58

set_property  -dict {PACKAGE_PIN  AJ21    IOSTANDARD LVCMOS25}     [get_ports spi_udc_csn_tx]       ; ## PMOD1_0_LS
set_property  -dict {PACKAGE_PIN  AK21    IOSTANDARD LVCMOS25}     [get_ports spi_udc_csn_rx]       ; ## PMOD1_1_LS
set_property  -dict {PACKAGE_PIN  AB16    IOSTANDARD LVCMOS25}     [get_ports spi_udc_sclk]         ; ## PMOD1_3_LS
set_property  -dict {PACKAGE_PIN  AB21    IOSTANDARD LVCMOS25}     [get_ports spi_udc_data]         ; ## PMOD1_2_LS


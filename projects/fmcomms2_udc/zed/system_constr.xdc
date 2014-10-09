
# spi pmod JA1

set_property  -dict {PACKAGE_PIN  Y11    IOSTANDARD LVCMOS33}     [get_ports spi_udc_csn_tx]       ; ## JA1
set_property  -dict {PACKAGE_PIN  AA11   IOSTANDARD LVCMOS33}     [get_ports spi_udc_csn_rx]       ; ## JA2
set_property  -dict {PACKAGE_PIN  AA9    IOSTANDARD LVCMOS33}     [get_ports spi_udc_sclk]         ; ## JA4
set_property  -dict {PACKAGE_PIN  Y10    IOSTANDARD LVCMOS33}     [get_ports spi_udc_data]         ; ## JA3


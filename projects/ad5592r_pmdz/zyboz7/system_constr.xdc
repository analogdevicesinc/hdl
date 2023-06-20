set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports  adc_spi_cs] 
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports  adc_spi_mosi ]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports  adc_spi_miso ] 
set_property -dict {PACKAGE_PIN T10  IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk] 

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports adc_spi_cs_scopy ]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports adc_spi_mosi_scopy]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports adc_spi_miso_scopy]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk_scopy]


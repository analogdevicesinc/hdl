
# PL PMOD

set_property PACKAGE_PIN G17 [get_ports gain0_o]
set_property IOSTANDARD LVCMOS33 [get_ports gain0_o]
set_property PACKAGE_PIN G18 [get_ports gain1_o]
set_property IOSTANDARD LVCMOS33 [get_ports gain1_o]
set_property PACKAGE_PIN F19 [get_ports {spi_cs[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_cs[1]}]
set_property PACKAGE_PIN F20 [get_ports led_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports led_clk_o]

set_property PACKAGE_PIN N15 [get_ports {spi_cs[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_cs[0]}]
set_property PACKAGE_PIN N16 [get_ports spi_sdo]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdo]
set_property PULLUP true [get_ports spi_sdo]
set_property PACKAGE_PIN L14 [get_ports spi_sdi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdi]
set_property PULLUP true [get_ports spi_sdi]
set_property PACKAGE_PIN L15 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]


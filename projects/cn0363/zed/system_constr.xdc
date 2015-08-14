
# PMOD JA

set_property PACKAGE_PIN Y11 [get_ports gain0_o]
set_property IOSTANDARD LVCMOS33 [get_ports gain0_o]
set_property PACKAGE_PIN AA11 [get_ports gain1_o]
set_property IOSTANDARD LVCMOS33 [get_ports gain1_o]
set_property PACKAGE_PIN AA9 [get_ports led_clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports led_clk_o]
set_property PACKAGE_PIN Y10 [get_ports {spi_cs[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_cs[1]}]

set_property PACKAGE_PIN AB11 [get_ports {spi_cs[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_cs[0]}]
set_property PACKAGE_PIN AB10 [get_ports spi_sdo]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdo]
set_property PULLUP true [get_ports spi_sdo]
set_property PACKAGE_PIN AB9 [get_ports spi_sdi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sdi]
set_property PULLUP true [get_ports spi_sdi]
set_property PACKAGE_PIN AA8 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]


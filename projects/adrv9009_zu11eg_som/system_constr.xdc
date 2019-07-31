
set_property -dict {PACKAGE_PIN AN21 IOSTANDARD LVCMOS18}  [get_ports spi_clk]
set_property -dict {PACKAGE_PIN AP21 IOSTANDARD LVCMOS18}  [get_ports spi_sdio]
set_property -dict {PACKAGE_PIN AR9  IOSTANDARD LVCMOS18}  [get_ports spi_miso]

create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]

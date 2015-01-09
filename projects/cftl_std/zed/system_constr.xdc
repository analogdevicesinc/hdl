#  CFTL

set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS33} [get_ports spi_cftl_ss_io];  # "JA1"
set_property  -dict {PACKAGE_PIN  AA11  IOSTANDARD LVCMOS33} [get_ports spi_cftl_mosi_io];  # "JA2"
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVCMOS33} [get_ports spi_cftl_miso_io];  # "JA3"
set_property  -dict {PACKAGE_PIN  AA9   IOSTANDARD LVCMOS33} [get_ports spi_cftl_sck_io];  # "JA4"
set_property  -dict {PACKAGE_PIN  AB9   IOSTANDARD LVCMOS33} [get_ports gpio_cftl_tri_io[0]];  # "JA9"
set_property  -dict {PACKAGE_PIN  AA8   IOSTANDARD LVCMOS33} [get_ports gpio_cftl_tri_io[1]];  # "JA10"

set_property  -dict {PACKAGE_PIN  W12   IOSTANDARD LVCMOS33} [get_ports iic_cftl_scl_io];  # "JB1"
set_property  -dict {PACKAGE_PIN  W11   IOSTANDARD LVCMOS33} [get_ports iic_cftl_sda_io];  # "JB2"

set_property  -dict {PACKAGE_PIN  AB7   IOSTANDARD LVCMOS33} [get_ports spi1_cftl_ss_io];  # "JC1_P"
set_property  -dict {PACKAGE_PIN  AB6   IOSTANDARD LVCMOS33} [get_ports spi1_cftl_mosi_io];  # "JC1_N"
set_property  -dict {PACKAGE_PIN  Y4    IOSTANDARD LVCMOS33} [get_ports spi1_cftl_miso_io];  # "JC2_P"
set_property  -dict {PACKAGE_PIN  AA4   IOSTANDARD LVCMOS33} [get_ports spi1_cftl_sck_io];  # "JC2_N"
set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD LVCMOS33} [get_ports spi1_cftl_ss1_o];  # "JC4_N"

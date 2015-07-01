#  CFTL

#port JA compatible with: CN0179, CN0216, CN10326, CN0354, CN0355
set_property  -dict {PACKAGE_PIN  Y11   IOSTANDARD LVCMOS33} [get_ports spi0_csn];  # "JA1"
set_property  -dict {PACKAGE_PIN  AA11  IOSTANDARD LVCMOS33} [get_ports spi0_mosi];  # "JA2"
set_property  -dict {PACKAGE_PIN  Y10   IOSTANDARD LVCMOS33} [get_ports spi0_miso];  # "JA3"
set_property  -dict {PACKAGE_PIN  AA9   IOSTANDARD LVCMOS33} [get_ports spi0_clk];  # "JA4"
set_property  -dict {PACKAGE_PIN  AB9   IOSTANDARD LVCMOS33} [get_ports gpio_cftl[0]];  # "JA9"
set_property  -dict {PACKAGE_PIN  AA8   IOSTANDARD LVCMOS33} [get_ports gpio_cftl[1]];  # "JA10"

#port JB compatible with: CN0346, CN0349
set_property  -dict {PACKAGE_PIN  V10   IOSTANDARD LVCMOS33} [get_ports iic_cftl_scl_io];  # "JB3"
set_property  -dict {PACKAGE_PIN  W8    IOSTANDARD LVCMOS33} [get_ports iic_cftl_sda_io];  # "JB4"

#port JC compatible with: CN0179, CN0357
set_property  -dict {PACKAGE_PIN  AB7   IOSTANDARD LVCMOS33} [get_ports spi1_csn0];  # "JC1_P"
set_property  -dict {PACKAGE_PIN  AB6   IOSTANDARD LVCMOS33} [get_ports spi1_mosi];  # "JC1_N"
set_property  -dict {PACKAGE_PIN  Y4    IOSTANDARD LVCMOS33} [get_ports spi1_miso];  # "JC2_P"
set_property  -dict {PACKAGE_PIN  AA4   IOSTANDARD LVCMOS33} [get_ports spi1_clk];  # "JC2_N"
set_property  -dict {PACKAGE_PIN  U4    IOSTANDARD LVCMOS33} [get_ports spi1_csn1];  # "JC4_N"

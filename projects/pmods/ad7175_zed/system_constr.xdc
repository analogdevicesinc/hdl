
# PMOD JA

set_property  -dict {PACKAGE_PIN Y11   IOSTANDARD LVCMOS33} [get_ports adc_cs_o];
set_property  -dict {PACKAGE_PIN AA11  IOSTANDARD LVCMOS33} [get_ports adc_sdi_o];
set_property  -dict {PACKAGE_PIN Y10   IOSTANDARD LVCMOS33} [get_ports adc_sdo_i];
set_property  -dict {PACKAGE_PIN AA9   IOSTANDARD LVCMOS33} [get_ports adc_sclk_o];
#set_property  -dict {PACKAGE_PIN AB11  IOSTANDARD LVCMOS33} [get_ports gain_o];
#set_property  -dict {PACKAGE_PIN AB10  IOSTANDARD LVCMOS33} [get_ports led_clk_o];
#set_property  -dict {PACKAGE_PIN AB9   IOSTANDARD LVCMOS33} [get_ports ad_sync_nc];
#set_property  -dict {PACKAGE_PIN AA8   IOSTANDARD LVCMOS33} [get_ports ad_clkio_nc];
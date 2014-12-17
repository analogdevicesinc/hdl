
# clocks

set_property -dict  {PACKAGE_PIN  H9    IOSTANDARD  LVDS} [get_ports sys_clk_p]
set_property -dict  {PACKAGE_PIN  G9    IOSTANDARD  LVDS} [get_ports sys_clk_n]

create_clock -name sys_clk      -period  5.00 [get_ports sys_clk_p]

set_property  -dict {PACKAGE_PIN  A8    IOSTANDARD LVCMOS15} [get_ports sys_rst]


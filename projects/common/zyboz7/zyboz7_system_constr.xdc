
# constraints

# gpio 

set_property  -dict {PACKAGE_PIN  K18   IOSTANDARD LVCMOS33} [get_ports btn[0]]       ; ## BTN0
set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS33} [get_ports btn[1]]       ; ## BTN1
set_property  -dict {PACKAGE_PIN  K19   IOSTANDARD LVCMOS33} [get_ports btn[2]]       ; ## BTN2
set_property  -dict {PACKAGE_PIN  Y16   IOSTANDARD LVCMOS33} [get_ports btn[3]]       ; ## BTN3
set_property  -dict {PACKAGE_PIN  M14   IOSTANDARD LVCMOS33} [get_ports led[0]]       ; ## LED0
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports led[1]]       ; ## LED1
set_property  -dict {PACKAGE_PIN  G14   IOSTANDARD LVCMOS33} [get_ports led[2]]       ; ## LED2
set_property  -dict {PACKAGE_PIN  D18   IOSTANDARD LVCMOS33} [get_ports led[3]]       ; ## LED3



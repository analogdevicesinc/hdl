
set_property  -dict {PACKAGE_PIN  D21 IOSTANDARD LVCMOS33}  [get_ports sdi]                      ; ##  PMOD0_7
set_property  -dict {PACKAGE_PIN  C22 IOSTANDARD LVCMOS33}  [get_ports sclk]                     ; ##  PMOD0_6
set_property  -dict {PACKAGE_PIN  C21 IOSTANDARD LVCMOS33}  [get_ports ext_csb_tile1]            ; ##  PMOD0_5
set_property  -dict {PACKAGE_PIN  B21 IOSTANDARD LVCMOS33}  [get_ports ext_csb_tile2]            ; ##  PMOD0_4
set_property  -dict {PACKAGE_PIN  A21 IOSTANDARD LVCMOS33}  [get_ports sdo]                      ; ##  PMOD0_3
set_property  -dict {PACKAGE_PIN  B20 IOSTANDARD LVCMOS33}  [get_ports ext_csb_tile3]            ; ##  PMOD0_1
set_property  -dict {PACKAGE_PIN  A20 IOSTANDARD LVCMOS33}  [get_ports ext_csb_tile4]            ; ##  PMOD0_0

set_property  -dict {PACKAGE_PIN  J19 IOSTANDARD LVCMOS33}  [get_ports ext_reset]                ; ##  PMOD1_7
set_property  -dict {PACKAGE_PIN  J20 IOSTANDARD LVCMOS33}  [get_ports ext_mute]                 ; ##  PMOD1_6
set_property  -dict {PACKAGE_PIN  F20 IOSTANDARD LVCMOS33}  [get_ports iic_sda]                  ; ##  PMOD1_4
set_property  -dict {PACKAGE_PIN  E22 IOSTANDARD LVCMOS33}  [get_ports ext_update]               ; ##  PMOD1_3
set_property  -dict {PACKAGE_PIN  D22 IOSTANDARD LVCMOS33}  [get_ports ext_rstb]                 ; ##  PMOD1_2
set_property  -dict {PACKAGE_PIN  D20 IOSTANDARD LVCMOS33}  [get_ports iic_scl]                  ; ##  PMOD1_0

set_property PULLUP true [get_ports iic_scl]
set_property PULLUP true [get_ports iic_sda]

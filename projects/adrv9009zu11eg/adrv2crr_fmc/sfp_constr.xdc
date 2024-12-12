
set_property -dict {PACKAGE_PIN  AJ16 IOSTANDARD LVCMOS18} [get_ports led_qsfp[0]]
set_property -dict {PACKAGE_PIN  AH16 IOSTANDARD LVCMOS18} [get_ports led_qsfp[1]]
set_property -dict {PACKAGE_PIN  AJ12 IOSTANDARD LVCMOS18} [get_ports led_qsfp[2]]
set_property -dict {PACKAGE_PIN  AK12 IOSTANDARD LVCMOS18} [get_ports led_qsfp[3]]

set_property -dict {PACKAGE_PIN  AU11 IOSTANDARD LVCMOS18 } [get_ports qsfp_resetl  ] ;
set_property -dict {PACKAGE_PIN  AL12 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_modprsl ] ;
set_property -dict {PACKAGE_PIN  AW14 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_intl    ] ;
set_property -dict {PACKAGE_PIN  AV11 IOSTANDARD LVCMOS18 } [get_ports qsfp_lpmode  ] ;


set_property PACKAGE_PIN AD2   [get_ports qsfp_rx1_p ] ;
set_property PACKAGE_PIN AD1   [get_ports qsfp_rx1_n ] ;

set_property PACKAGE_PIN AC4   [get_ports qsfp_rx2_p ] ;
set_property PACKAGE_PIN AC3   [get_ports qsfp_rx2_n ] ;

set_property PACKAGE_PIN AB2   [get_ports qsfp_rx3_p ] ;
set_property PACKAGE_PIN AB1   [get_ports qsfp_rx3_n ] ;

set_property PACKAGE_PIN AA4   [get_ports qsfp_rx4_p ] ;
set_property PACKAGE_PIN AA3   [get_ports qsfp_rx4_n ] ;

set_property PACKAGE_PIN AD6   [get_ports qsfp_tx1_p ] ;
set_property PACKAGE_PIN AD5   [get_ports qsfp_tx1_n ] ;

set_property PACKAGE_PIN AC8   [get_ports qsfp_tx2_p ] ;
set_property PACKAGE_PIN AC7   [get_ports qsfp_tx2_n ] ;

set_property PACKAGE_PIN AB6   [get_ports qsfp_tx3_p ] ;
set_property PACKAGE_PIN AB5   [get_ports qsfp_tx3_n ] ;

set_property PACKAGE_PIN AA8   [get_ports qsfp_tx4_p ] ;
set_property PACKAGE_PIN AA7   [get_ports qsfp_tx4_n ] ;

set_property PACKAGE_PIN AD10  [get_ports qsfp_mgt_refclk_0_p ] ;
set_property PACKAGE_PIN AD9   [get_ports qsfp_mgt_refclk_0_n ] ;


# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name gt_ref_clk [get_ports qsfp_mgt_refclk_0_p]

set_property -dict {PACKAGE_PIN AR19 IOSTANDARD LVCMOS18} [get_ports resetb_ad9545]

set_property -dict {PACKAGE_PIN  AT13 IOSTANDARD LVCMOS18} [get_ports fan_tach]
set_property -dict {PACKAGE_PIN  AR13 IOSTANDARD LVCMOS18} [get_ports fan_pwm]

set_property -dict {PACKAGE_PIN AT21 IOSTANDARD LVCMOS18} [get_ports i2c0_scl]
set_property -dict {PACKAGE_PIN AU21 IOSTANDARD LVCMOS18} [get_ports i2c0_sda]

set_property -dict {PACKAGE_PIN AN19 IOSTANDARD LVCMOS18} [get_ports i2c1_scl]
set_property -dict {PACKAGE_PIN AN18 IOSTANDARD LVCMOS18} [get_ports i2c1_sda]

set_property -dict {PACKAGE_PIN AN17 IOSTANDARD LVDS} [get_ports oscout_p]
set_property -dict {PACKAGE_PIN AP17 IOSTANDARD LVDS} [get_ports oscout_n]

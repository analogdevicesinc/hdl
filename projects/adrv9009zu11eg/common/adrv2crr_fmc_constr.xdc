###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set_property -dict {PACKAGE_PIN  AT13 IOSTANDARD LVCMOS18} [get_ports fan_tach]
set_property -dict {PACKAGE_PIN  AR13 IOSTANDARD LVCMOS18} [get_ports fan_pwm]
set_property -dict {PACKAGE_PIN  AR12 IOSTANDARD LVCMOS18} [get_ports i2s_sdata_in]
set_property -dict {PACKAGE_PIN  AP12 IOSTANDARD LVCMOS18} [get_ports i2s_sdata_out]
set_property -dict {PACKAGE_PIN  AP15 IOSTANDARD LVCMOS18} [get_ports i2s_mclk]
set_property -dict {PACKAGE_PIN  AR15 IOSTANDARD LVCMOS18} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN  AT10 IOSTANDARD LVCMOS18} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN  AW12 IOSTANDARD LVCMOS18} [get_ports pmod0_d0]
set_property -dict {PACKAGE_PIN  AV12 IOSTANDARD LVCMOS18} [get_ports pmod0_d1]
set_property -dict {PACKAGE_PIN  AU13 IOSTANDARD LVCMOS18} [get_ports pmod0_d2]
set_property -dict {PACKAGE_PIN  AU14 IOSTANDARD LVCMOS18} [get_ports pmod0_d3]
set_property -dict {PACKAGE_PIN  AM13 IOSTANDARD LVCMOS18} [get_ports pmod0_d4]
set_property -dict {PACKAGE_PIN  AL13 IOSTANDARD LVCMOS18} [get_ports pmod0_d5]
set_property -dict {PACKAGE_PIN  AK15 IOSTANDARD LVCMOS18} [get_ports pmod0_d6]
set_property -dict {PACKAGE_PIN  AJ15 IOSTANDARD LVCMOS18} [get_ports pmod0_d7]




set_property -dict {PACKAGE_PIN  AW11 IOSTANDARD LVCMOS18} [get_ports dip_gpio_0]
set_property -dict {PACKAGE_PIN  AW10 IOSTANDARD LVCMOS18} [get_ports dip_gpio_1]
set_property -dict {PACKAGE_PIN  AN13 IOSTANDARD LVCMOS18} [get_ports dip_gpio_2]
set_property -dict {PACKAGE_PIN  AN12 IOSTANDARD LVCMOS18} [get_ports dip_gpio_3]
set_property -dict {PACKAGE_PIN  AV13 IOSTANDARD LVCMOS18} [get_ports pb_gpio_0]
set_property -dict {PACKAGE_PIN  AV14 IOSTANDARD LVCMOS18} [get_ports pb_gpio_1]
set_property -dict {PACKAGE_PIN  AT11 IOSTANDARD LVCMOS18} [get_ports pb_gpio_2]
set_property -dict {PACKAGE_PIN  AT12 IOSTANDARD LVCMOS18} [get_ports pb_gpio_3]

set_property -dict {PACKAGE_PIN  AM16 IOSTANDARD LVCMOS18} [get_ports gpio_0_exp_n]
set_property -dict {PACKAGE_PIN  AL16 IOSTANDARD LVCMOS18} [get_ports gpio_0_exp_p]
set_property -dict {PACKAGE_PIN  AK17 IOSTANDARD LVCMOS18} [get_ports gpio_1_exp_n]
set_property -dict {PACKAGE_PIN  AJ17 IOSTANDARD LVCMOS18} [get_ports gpio_1_exp_p]
set_property -dict {PACKAGE_PIN  AK13 IOSTANDARD LVCMOS18} [get_ports gpio_2_exp_n]
set_property -dict {PACKAGE_PIN  AM15 IOSTANDARD LVCMOS18} [get_ports gpio_3_exp_p]
set_property -dict {PACKAGE_PIN  AN14 IOSTANDARD LVCMOS18} [get_ports gpio_3_exp_n]
set_property -dict {PACKAGE_PIN  AJ14 IOSTANDARD LVCMOS18} [get_ports gpio_4_exp_n]

set_property -dict {PACKAGE_PIN AR19 IOSTANDARD LVCMOS18} [get_ports resetb_ad9545]
set_property -dict {PACKAGE_PIN AP19 IOSTANDARD LVCMOS18} [get_ports hmc7044_car_reset]
set_property -dict {PACKAGE_PIN AP20 IOSTANDARD LVCMOS18} [get_ports hmc7044_car_gpio_1]
set_property -dict {PACKAGE_PIN AR20 IOSTANDARD LVCMOS18} [get_ports hmc7044_car_gpio_2]
set_property -dict {PACKAGE_PIN AP9  IOSTANDARD LVCMOS18} [get_ports hmc7044_car_gpio_3]
set_property -dict {PACKAGE_PIN AP8  IOSTANDARD LVCMOS18} [get_ports hmc7044_car_gpio_4]
set_property -dict {PACKAGE_PIN AR10 IOSTANDARD LVCMOS18} [get_ports spi_csn_hmc7044_car]

set_property -dict {PACKAGE_PIN AT21 IOSTANDARD LVCMOS18} [get_ports i2c0_scl]
set_property -dict {PACKAGE_PIN AU21 IOSTANDARD LVCMOS18} [get_ports i2c0_sda]

set_property -dict {PACKAGE_PIN AN19 IOSTANDARD LVCMOS18} [get_ports i2c1_scl]
set_property -dict {PACKAGE_PIN AN18 IOSTANDARD LVCMOS18} [get_ports i2c1_sda]

set_property -dict {PACKAGE_PIN AN17 IOSTANDARD LVDS} [get_ports oscout_p]
set_property -dict {PACKAGE_PIN AP17 IOSTANDARD LVDS} [get_ports oscout_n]

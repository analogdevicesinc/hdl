###############################################################################
## Copyright (C) 2019-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
set_property -dict {PACKAGE_PIN  AJ16 IOSTANDARD LVCMOS18} [get_ports led_gpio_0]
set_property -dict {PACKAGE_PIN  AH16 IOSTANDARD LVCMOS18} [get_ports led_gpio_1]
set_property -dict {PACKAGE_PIN  AJ12 IOSTANDARD LVCMOS18} [get_ports led_gpio_2]
set_property -dict {PACKAGE_PIN  AK12 IOSTANDARD LVCMOS18} [get_ports led_gpio_3]
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

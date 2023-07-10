###############################################################################
## Copyright (C) 2021-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

#
#                     !!! WARNING !!!
#
#  This project must run on a board where VADJ is programmed to 1.8 V
#
#                     !!! WARNING !!!
#

set_property  -dict {PACKAGE_PIN AG17	 IOSTANDARD LVCMOS18}  [get_ports dev_clk_out]

set_property  -dict {PACKAGE_PIN AE18	 IOSTANDARD LVCMOS18}  [get_ports dgpio_0]
set_property  -dict {PACKAGE_PIN AE17	 IOSTANDARD LVCMOS18}  [get_ports dgpio_1]
set_property  -dict {PACKAGE_PIN AB14	 IOSTANDARD LVCMOS18}  [get_ports dgpio_2]
set_property  -dict {PACKAGE_PIN AK16	 IOSTANDARD LVCMOS18}  [get_ports dgpio_3]
set_property  -dict {PACKAGE_PIN AH13	 IOSTANDARD LVCMOS18}  [get_ports dgpio_4]
set_property  -dict {PACKAGE_PIN AC13	 IOSTANDARD LVCMOS18}  [get_ports dgpio_5]
set_property  -dict {PACKAGE_PIN AJ28	 IOSTANDARD LVCMOS18}  [get_ports dgpio_6]
set_property  -dict {PACKAGE_PIN AJ30	 IOSTANDARD LVCMOS18}  [get_ports dgpio_7]
set_property  -dict {PACKAGE_PIN AD25	 IOSTANDARD LVCMOS18}  [get_ports dgpio_8]
set_property  -dict {PACKAGE_PIN AE26	 IOSTANDARD LVCMOS18}  [get_ports dgpio_9]
set_property  -dict {PACKAGE_PIN AJ16	 IOSTANDARD LVCMOS18}  [get_ports dgpio_10]
set_property  -dict {PACKAGE_PIN AJ29	 IOSTANDARD LVCMOS18}  [get_ports dgpio_11]

set_property  -dict {PACKAGE_PIN AB29	 IOSTANDARD LVCMOS18}  [get_ports gp_int]
set_property  -dict {PACKAGE_PIN AH17	 IOSTANDARD LVCMOS18}  [get_ports mode]
set_property  -dict {PACKAGE_PIN AH16	 IOSTANDARD LVCMOS18}  [get_ports reset_trx]

set_property  -dict {PACKAGE_PIN AC14	 IOSTANDARD LVCMOS18}  [get_ports rx1_enable]
set_property  -dict {PACKAGE_PIN AK30	 IOSTANDARD LVCMOS18}  [get_ports rx2_enable]

set_property  -dict {PACKAGE_PIN AG16	 IOSTANDARD LVCMOS18}  [get_ports sm_fan_tach]

set_property  -dict {PACKAGE_PIN AD16	 IOSTANDARD LVCMOS18}  [get_ports spi_clk]
set_property  -dict {PACKAGE_PIN AF25	 IOSTANDARD LVCMOS18}  [get_ports spi_dio]
set_property  -dict {PACKAGE_PIN AD15	 IOSTANDARD LVCMOS18}  [get_ports spi_do]
set_property  -dict {PACKAGE_PIN AB15	 IOSTANDARD LVCMOS18}  [get_ports spi_en]

set_property  -dict {PACKAGE_PIN AH14	 IOSTANDARD LVCMOS18}  [get_ports tx1_enable]
set_property  -dict {PACKAGE_PIN AE25	 IOSTANDARD LVCMOS18}  [get_ports tx2_enable]

set_property  -dict {PACKAGE_PIN AC29	 IOSTANDARD LVCMOS18}  [get_ports vadj_err]
set_property  -dict {PACKAGE_PIN AD29	 IOSTANDARD LVCMOS18}  [get_ports platform_status]

set_property  -dict {PACKAGE_PIN AJ21  IOSTANDARD LVCMOS18}  [get_ports  tdd_sync]      ;#PMOD1_0 J58.1

# set IOSTANDARD according to VADJ 1.8V

# hdmi

set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_out_clk]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_vsync]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_hsync]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data_e]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[0]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[1]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[2]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[3]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[4]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[5]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[6]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[7]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[8]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[9]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[10]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[11]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[12]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[13]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[14]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[15]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[16]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[17]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[18]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[19]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[20]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[21]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[22]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports hdmi_data[23]]

# spdif

set_property  -dict {IOSTANDARD LVCMOS18} [get_ports spdif]

# iic

set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_scl]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports iic_sda]

# gpio (switches, leds and such)

set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[0]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[1]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[2]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[3]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[4]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[6]]

set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[7]]
set_property  -dict {IOSTANDARD LVCMOS18} [get_ports gpio_bd[9]]

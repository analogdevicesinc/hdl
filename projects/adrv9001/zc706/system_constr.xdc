###############################################################################
## Copyright (C) 2021-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
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

set_property  -dict {PACKAGE_PIN AF18 IOSTANDARD DIFF_SSTL18_II} [get_ports dev_mcs_fpga_out_p]
set_property  -dict {PACKAGE_PIN AF17 IOSTANDARD DIFF_SSTL18_II} [get_ports dev_mcs_fpga_out_n]

set_property  -dict {PACKAGE_PIN Y26  IOSTANDARD DIFF_HSTL_II_18} [get_ports fpga_mcs_in_p]
set_property  -dict {PACKAGE_PIN Y27  IOSTANDARD DIFF_HSTL_II_18} [get_ports fpga_mcs_in_n]
set_property  -dict {PACKAGE_PIN AC28 IOSTANDARD DIFF_HSTL_II_18} [get_ports fpga_ref_clk_p]
set_property  -dict {PACKAGE_PIN AD28 IOSTANDARD DIFF_HSTL_II_18} [get_ports fpga_ref_clk_n]

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

create_clock -name ref_clk        -period  8.00 [get_ports fpga_ref_clk_p]

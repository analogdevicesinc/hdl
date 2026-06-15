###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# constraints

# hdmi

set_property  -dict {PACKAGE_PIN  P28   IOSTANDARD LVCMOS25}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  R22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  V24   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  U24   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  R23   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  AA25  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AE28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  T23   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AB25  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  T27   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AD26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  AB26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  AA28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  AC26  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  AE30  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  Y25   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  AA29  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  AD30  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[15]]
set_property  -dict {PACKAGE_PIN  Y28   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[16]]
set_property  -dict {PACKAGE_PIN  AF28  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[17]]
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[18]]
set_property  -dict {PACKAGE_PIN  AA27  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[19]]
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[20]]
set_property  -dict {PACKAGE_PIN  N28   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[21]]
set_property  -dict {PACKAGE_PIN  V21   IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[22]]
set_property  -dict {PACKAGE_PIN  AC22  IOSTANDARD LVCMOS25  IOB TRUE} [get_ports hdmi_data[23]]

# spdif

set_property  -dict {PACKAGE_PIN  AC21  IOSTANDARD LVCMOS25} [get_ports spdif]

# iic

set_property  -dict {PACKAGE_PIN  AJ14  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_scl]
set_property  -dict {PACKAGE_PIN  AJ18  IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports iic_sda]

# gpio (switches, leds and such)

set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]           ; ## GPIO_DIP_SW0
set_property  -dict {PACKAGE_PIN  AC16  IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]           ; ## GPIO_DIP_SW1
set_property  -dict {PACKAGE_PIN  AC17  IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]           ; ## GPIO_DIP_SW2
set_property  -dict {PACKAGE_PIN  AJ13  IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]           ; ## GPIO_DIP_SW3
set_property  -dict {PACKAGE_PIN  AK25  IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]           ; ## GPIO_SW_LEFT
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS15} [get_ports gpio_bd[5]]           ; ## GPIO_SW_CENTER
set_property  -dict {PACKAGE_PIN  R27   IOSTANDARD LVCMOS25} [get_ports gpio_bd[6]]           ; ## GPIO_SW_RIGHT

set_property  -dict {PACKAGE_PIN  Y21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[7]]           ; ## GPIO_LED_LEFT
set_property  -dict {PACKAGE_PIN  G2    IOSTANDARD LVCMOS15} [get_ports gpio_bd[8]]           ; ## GPIO_LED_CENTER
set_property  -dict {PACKAGE_PIN  W21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]           ; ## GPIO_LED_RIGHT
set_property  -dict {PACKAGE_PIN  A17   IOSTANDARD LVCMOS15} [get_ports gpio_bd[10]]          ; ## GPIO_LED_0

set_property  -dict {PACKAGE_PIN  H14   IOSTANDARD LVCMOS15} [get_ports gpio_bd[11]]          ; ## XADC_GPIO_0
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS15} [get_ports gpio_bd[12]]          ; ## XADC_GPIO_1
set_property  -dict {PACKAGE_PIN  J16   IOSTANDARD LVCMOS15} [get_ports gpio_bd[13]]          ; ## XADC_GPIO_2
set_property  -dict {PACKAGE_PIN  J14   IOSTANDARD LVCMOS15} [get_ports gpio_bd[14]]          ; ## XADC_GPIO_3

# Define SPI clock
create_clock -name spi0_clk      -period 40   [get_pins -hier */EMIOSPI0SCLKO]
create_clock -name spi1_clk      -period 40   [get_pins -hier */EMIOSPI1SCLKO]

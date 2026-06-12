###############################################################################
## Copyright (C) 2019-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# gpio 

set_property  -dict {PACKAGE_PIN  D20   IOSTANDARD LVCMOS33} [get_ports btn[0]]       ; ## BTN0
set_property  -dict {PACKAGE_PIN  D19   IOSTANDARD LVCMOS33} [get_ports btn[1]]       ; ## BTN1
set_property  -dict {PACKAGE_PIN  L15   IOSTANDARD LVCMOS33} [get_ports led[0]]       ; ## LED0_B
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS33} [get_ports led[1]]       ; ## LED0_R
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS33} [get_ports led[2]]       ; ## LED0_G
set_property  -dict {PACKAGE_PIN  G14   IOSTANDARD LVCMOS33} [get_ports led[3]]       ; ## LED1_B
set_property  -dict {PACKAGE_PIN  L14   IOSTANDARD LVCMOS33} [get_ports led[4]]       ; ## LED1_R
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS33} [get_ports led[5]]       ; ## LED1_G

# iic

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports iic_ard_scl] ; ## Arduino_SCL
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports iic_ard_sda] ; ## Arduino_SDA

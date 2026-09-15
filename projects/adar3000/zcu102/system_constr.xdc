###############################################################################
## Copyright (C) 2021, 2026 Analog Devices, Inc. All rights reserved.
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

# adar3000 - hpc1

set_property  -dict {PACKAGE_PIN  Y5   IOSTANDARD LVCMOS18}  [get_ports spi_sel_a]               ; ## D20  FMC_HPC1_LA17_CC_P
set_property  -dict {PACKAGE_PIN  AA5  IOSTANDARD LVCMOS18}  [get_ports spi_mosi]                ; ## D21  FMC_HPC1_LA17_CC_N
set_property  -dict {PACKAGE_PIN  Y8   IOSTANDARD LVCMOS18}  [get_ports spi_miso]                ; ## C22  FMC_HPC1_LA18_CC_P
set_property  -dict {PACKAGE_PIN  AE12 IOSTANDARD LVCMOS18}  [get_ports spi_clk]                 ; ## D23  FMC_HPC1_LA23_P

set_property  -dict {PACKAGE_PIN  AC12 IOSTANDARD LVCMOS18}  [get_ports gpio0]                   ; ## H25  FMC_HPC1_LA21_P
set_property  -dict {PACKAGE_PIN  T12  IOSTANDARD LVCMOS18}  [get_ports gpio1]                   ; ## D26  FMC_HPC1_LA26_P
set_property  -dict {PACKAGE_PIN  AG11 IOSTANDARD LVCMOS18}  [get_ports gpio2]                   ; ## G25  FMC_HPC1_LA22_N
set_property  -dict {PACKAGE_PIN  U10  IOSTANDARD LVCMOS18}  [get_ports gpio3]                   ; ## C26  FMC_HPC1_LA27_P
set_property  -dict {PACKAGE_PIN  AC11 IOSTANDARD LVCMOS18}  [get_ports gpio4]                   ; ## H26  FMC_HPC1_LA21_N
set_property  -dict {PACKAGE_PIN  R12  IOSTANDARD LVCMOS18}  [get_ports gpio5]                   ; ## D27  FMC_HPC1_LA26_N
set_property  -dict {PACKAGE_PIN  AE10 IOSTANDARD LVCMOS18}  [get_ports gpio6]                   ; ## G27  FMC_HPC1_LA25_P
set_property  -dict {PACKAGE_PIN  T10  IOSTANDARD LVCMOS18}  [get_ports gpio7]                   ; ## C27  FMC_HPC1_LA27_N

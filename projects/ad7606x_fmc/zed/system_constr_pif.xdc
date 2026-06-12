###############################################################################
## Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
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

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports adc_db[0] ]; ## D08 FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports adc_db[1] ]; ## D09 FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports adc_db[2] ]; ## H08 FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports adc_db[3] ]; ## G10 FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports adc_db[4] ]; ## H11 FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports adc_db[5] ]; ## H14 FMC_LPC_LA07_N
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports adc_db[6] ]; ## G13 FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports adc_db[7] ]; ## G07 FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports adc_db[8] ]; ## C11 FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports adc_db[9] ]; ## D11 FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25} [get_ports adc_db[10]]; ## D14 FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports adc_db[11]]; ## G09 FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS25} [get_ports adc_db[12]]; ## H17 FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports adc_db[13]]; ## G16 FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports adc_db[14]]; ## D17 FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports adc_db[15]]; ## D18 FMC_LPC_LA13_N

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports adc_rd_n];   ## G06 FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports adc_wr_n];   ## C14 FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports adc_cs_n];   ## H10 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS25} [get_ports adc_refsel]; ## C19 FMC_LPC_LA14_N

set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS25} [get_ports adc_serpar];     ## C18 FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports adc_busy];       ## H13 FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports adc_first_data]; ## G12 FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports adc_reset];      ## C10 FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports adc_os[0]];      ## G15 FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports adc_os[1]];      ## H07 FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports adc_os[2]];      ## H16 FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports adc_stby];       ## C15 FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS25} [get_ports adc_range];      ## D15 FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS25} [get_ports adc_cnvst_n];    ## D12 FMC_LPC_LA05_N

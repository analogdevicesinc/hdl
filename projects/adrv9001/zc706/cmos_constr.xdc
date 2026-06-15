###############################################################################
## Copyright (C) 2021-2023, 2026 Analog Devices, Inc. All rights reserved.
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

set_property  -dict {PACKAGE_PIN AF13  IOSTANDARD LVCMOS18}  [get_ports rx1_dclk_in_n]    ;## G07 FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN AE13  IOSTANDARD LVCMOS18}  [get_ports rx1_dclk_in_p]    ;## G06 FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN AH12  IOSTANDARD LVCMOS18}  [get_ports rx1_idata_in_n]   ;## G10 FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN AG12  IOSTANDARD LVCMOS18}  [get_ports rx1_idata_in_p]   ;## G09 FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN AK15  IOSTANDARD LVCMOS18}  [get_ports rx1_qdata_in_n]   ;## H11 FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN AJ15  IOSTANDARD LVCMOS18}  [get_ports rx1_qdata_in_p]   ;## H10 FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN AF12  IOSTANDARD LVCMOS18}  [get_ports rx1_strobe_in_n]  ;## H08 FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN AE12  IOSTANDARD LVCMOS18}  [get_ports rx1_strobe_in_p]  ;## H07 FMC_LPC_LA02_P

set_property  -dict {PACKAGE_PIN AC27  IOSTANDARD LVCMOS18}  [get_ports rx2_dclk_in_n]    ;## D21 FMC_LPC_LA17_CC_N
set_property  -dict {PACKAGE_PIN AB27  IOSTANDARD LVCMOS18}  [get_ports rx2_dclk_in_p]    ;## D20 FMC_LPC_LA17_CC_P
set_property  -dict {PACKAGE_PIN AG27  IOSTANDARD LVCMOS18}  [get_ports rx2_idata_in_n]   ;## G22 FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN AG26  IOSTANDARD LVCMOS18}  [get_ports rx2_idata_in_p]   ;## G21 FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN AH27  IOSTANDARD LVCMOS18}  [get_ports rx2_qdata_in_n]   ;## H23 FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN AH26  IOSTANDARD LVCMOS18}  [get_ports rx2_qdata_in_p]   ;## H22 FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN AH29  IOSTANDARD LVCMOS18}  [get_ports rx2_strobe_in_n]  ;## H26 FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN AH28  IOSTANDARD LVCMOS18}  [get_ports rx2_strobe_in_p]  ;## H25 FMC_LPC_LA21_P

set_property  -dict {PACKAGE_PIN AA14  IOSTANDARD LVCMOS18}  [get_ports tx1_dclk_out_n]   ;## H14 FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN AA15  IOSTANDARD LVCMOS18}  [get_ports tx1_dclk_out_p]   ;## H13 FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN AG15  IOSTANDARD LVCMOS18}  [get_ports tx1_dclk_in_n]    ;## D09 FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN AF15  IOSTANDARD LVCMOS18}  [get_ports tx1_dclk_in_p]    ;## D08 FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN AD13  IOSTANDARD LVCMOS18}  [get_ports tx1_idata_out_n]  ;## G13 FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN AD14  IOSTANDARD LVCMOS18}  [get_ports tx1_idata_out_p]  ;## G12 FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN AE15  IOSTANDARD LVCMOS18}  [get_ports tx1_qdata_out_n]  ;## D12 FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN AE16  IOSTANDARD LVCMOS18}  [get_ports tx1_qdata_out_p]  ;## D11 FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN AC12  IOSTANDARD LVCMOS18}  [get_ports tx1_strobe_out_n] ;## C11 FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN AB12  IOSTANDARD LVCMOS18}  [get_ports tx1_strobe_out_p] ;## C10 FMC_LPC_LA06_P

set_property  -dict {PACKAGE_PIN AK28  IOSTANDARD LVCMOS18}  [get_ports tx2_dclk_out_n]   ;## G25 FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN AK27  IOSTANDARD LVCMOS18}  [get_ports tx2_dclk_out_p]   ;## G24 FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN AF27  IOSTANDARD LVCMOS18}  [get_ports tx2_dclk_in_n]    ;## C23 FMC_LPC_LA18_CC_N
set_property  -dict {PACKAGE_PIN AE27  IOSTANDARD LVCMOS18}  [get_ports tx2_dclk_in_p]    ;## C22 FMC_LPC_LA18_CC_P
set_property  -dict {PACKAGE_PIN AK26  IOSTANDARD LVCMOS18}  [get_ports tx2_idata_out_n]  ;## D24 FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN AJ26  IOSTANDARD LVCMOS18}  [get_ports tx2_idata_out_p]  ;## D23 FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN AG29  IOSTANDARD LVCMOS18}  [get_ports tx2_qdata_out_n]  ;## G28 FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN AF29  IOSTANDARD LVCMOS18}  [get_ports tx2_qdata_out_p]  ;## G27 FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN AG30  IOSTANDARD LVCMOS18}  [get_ports tx2_strobe_out_n] ;## H29 FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN AF30  IOSTANDARD LVCMOS18}  [get_ports tx2_strobe_out_p] ;## H28 FMC_LPC_LA24_P

# clocks

create_clock -name rx1_dclk_out   -period  12.5 [get_ports rx1_dclk_in_p]
create_clock -name rx2_dclk_out   -period  12.5 [get_ports rx2_dclk_in_p]
create_clock -name tx1_dclk_out   -period  12.5 [get_ports tx1_dclk_in_p]
create_clock -name tx2_dclk_out   -period  12.5 [get_ports tx2_dclk_in_p]


###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
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
# ad9361

set_property  -dict {PACKAGE_PIN  W23    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_p]           ; ## G6   FMC_LPC_LA00_CC_P
set_property  -dict {PACKAGE_PIN  W24    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_clk_in_n]           ; ## G7   FMC_LPC_LA00_CC_N
set_property  -dict {PACKAGE_PIN  W25    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_p]         ; ## D8   FMC_LPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  Y25    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_frame_in_n]         ; ## D9   FMC_LPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AA22   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[0]]       ; ## H7   FMC_LPC_LA02_P
set_property  -dict {PACKAGE_PIN  AB22   IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[0]]       ; ## H8   FMC_LPC_LA02_N
set_property  -dict {PACKAGE_PIN  W28    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[1]]       ; ## G9   FMC_LPC_LA03_P
set_property  -dict {PACKAGE_PIN  Y28    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[1]]       ; ## G10  FMC_LPC_LA03_N
set_property  -dict {PACKAGE_PIN  U26    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[2]]       ; ## H10  FMC_LPC_LA04_P
set_property  -dict {PACKAGE_PIN  U27    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[2]]       ; ## H11  FMC_LPC_LA04_N
set_property  -dict {PACKAGE_PIN  V27    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[3]]       ; ## D11  FMC_LPC_LA05_P
set_property  -dict {PACKAGE_PIN  V28    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[3]]       ; ## D12  FMC_LPC_LA05_N
set_property  -dict {PACKAGE_PIN  V29    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[4]]       ; ## C10  FMC_LPC_LA06_P
set_property  -dict {PACKAGE_PIN  W29    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[4]]       ; ## C11  FMC_LPC_LA06_N
set_property  -dict {PACKAGE_PIN  V22    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_p[5]]       ; ## H13  FMC_LPC_LA07_P
set_property  -dict {PACKAGE_PIN  V23    IOSTANDARD LVDS DIFF_TERM TRUE} [get_ports rx_data_in_n[5]]       ; ## H14  FMC_LPC_LA07_N
set_property  -dict {PACKAGE_PIN  U24    IOSTANDARD LVDS} [get_ports tx_clk_out_p]                         ; ## G12  FMC_LPC_LA08_P
set_property  -dict {PACKAGE_PIN  U25    IOSTANDARD LVDS} [get_ports tx_clk_out_n]                         ; ## G13  FMC_LPC_LA08_N
set_property  -dict {PACKAGE_PIN  V26    IOSTANDARD LVDS} [get_ports tx_frame_out_p]                       ; ## D14  FMC_LPC_LA09_P
set_property  -dict {PACKAGE_PIN  W26    IOSTANDARD LVDS} [get_ports tx_frame_out_n]                       ; ## D15  FMC_LPC_LA09_N
set_property  -dict {PACKAGE_PIN  V21    IOSTANDARD LVDS} [get_ports tx_data_out_p[0]]                     ; ## H16  FMC_LPC_LA11_P
set_property  -dict {PACKAGE_PIN  W21    IOSTANDARD LVDS} [get_ports tx_data_out_n[0]]                     ; ## H17  FMC_LPC_LA11_N
set_property  -dict {PACKAGE_PIN  AC22   IOSTANDARD LVDS} [get_ports tx_data_out_p[1]]                     ; ## G15  FMC_LPC_LA12_P
set_property  -dict {PACKAGE_PIN  AC23   IOSTANDARD LVDS} [get_ports tx_data_out_n[1]]                     ; ## G16  FMC_LPC_LA12_N
set_property  -dict {PACKAGE_PIN  AA20   IOSTANDARD LVDS} [get_ports tx_data_out_p[2]]                     ; ## D17  FMC_LPC_LA13_P
set_property  -dict {PACKAGE_PIN  AB20   IOSTANDARD LVDS} [get_ports tx_data_out_n[2]]                     ; ## D18  FMC_LPC_LA13_N
set_property  -dict {PACKAGE_PIN  T22    IOSTANDARD LVDS} [get_ports tx_data_out_p[3]]                     ; ## C14  FMC_LPC_LA10_P
set_property  -dict {PACKAGE_PIN  T23    IOSTANDARD LVDS} [get_ports tx_data_out_n[3]]                     ; ## C15  FMC_LPC_LA10_N
set_property  -dict {PACKAGE_PIN  U21    IOSTANDARD LVDS} [get_ports tx_data_out_p[4]]                     ; ## C18  FMC_LPC_LA14_P
set_property  -dict {PACKAGE_PIN  U22    IOSTANDARD LVDS} [get_ports tx_data_out_n[4]]                     ; ## C19  FMC_LPC_LA14_N
set_property  -dict {PACKAGE_PIN  AB25   IOSTANDARD LVDS} [get_ports tx_data_out_p[5]]                     ; ## H19  FMC_LPC_LA15_P
set_property  -dict {PACKAGE_PIN  AB26   IOSTANDARD LVDS} [get_ports tx_data_out_n[5]]                     ; ## H20  FMC_LPC_LA15_N


set_property  -dict {PACKAGE_PIN  AA34   IOSTANDARD LVCMOS18} [get_ports gpio_status[0]]                   ; ## G21  FMC_LPC_LA20_P
set_property  -dict {PACKAGE_PIN  AB34   IOSTANDARD LVCMOS18} [get_ports gpio_status[1]]                   ; ## G22  FMC_LPC_LA20_N
set_property  -dict {PACKAGE_PIN  AC33   IOSTANDARD LVCMOS18} [get_ports gpio_status[2]]                   ; ## H25  FMC_LPC_LA21_P
set_property  -dict {PACKAGE_PIN  AD33   IOSTANDARD LVCMOS18} [get_ports gpio_status[3]]                   ; ## H26  FMC_LPC_LA21_N
set_property  -dict {PACKAGE_PIN  AC34   IOSTANDARD LVCMOS18} [get_ports gpio_status[4]]                   ; ## G24  FMC_LPC_LA22_P
set_property  -dict {PACKAGE_PIN  AD34   IOSTANDARD LVCMOS18} [get_ports gpio_status[5]]                   ; ## G25  FMC_LPC_LA22_N
set_property  -dict {PACKAGE_PIN  AD30   IOSTANDARD LVCMOS18} [get_ports gpio_status[6]]                   ; ## D23  FMC_LPC_LA23_P
set_property  -dict {PACKAGE_PIN  AD31   IOSTANDARD LVCMOS18} [get_ports gpio_status[7]]                   ; ## D24  FMC_LPC_LA23_N
set_property  -dict {PACKAGE_PIN  AE32   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[0]]                      ; ## H28  FMC_LPC_LA24_P
set_property  -dict {PACKAGE_PIN  AF32   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[1]]                      ; ## H29  FMC_LPC_LA24_N
set_property  -dict {PACKAGE_PIN  AE33   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[2]]                      ; ## G27  FMC_LPC_LA25_P
set_property  -dict {PACKAGE_PIN  AF34   IOSTANDARD LVCMOS18} [get_ports gpio_ctl[3]]                      ; ## G28  FMC_LPC_LA25_N
set_property  -dict {PACKAGE_PIN  AA29   IOSTANDARD LVCMOS18} [get_ports gpio_en_agc]                      ; ## H22  FMC_LPC_LA19_P
set_property  -dict {PACKAGE_PIN  AB29   IOSTANDARD LVCMOS18} [get_ports gpio_sync]                        ; ## H23  FMC_LPC_LA19_N
set_property  -dict {PACKAGE_PIN  V31    IOSTANDARD LVCMOS18} [get_ports gpio_resetb]                      ; ## H31  FMC_LPC_LA28_P

set_property  -dict {PACKAGE_PIN  AB21   IOSTANDARD LVCMOS18} [get_ports enable]                           ; ## G18  FMC_LPC_LA16_P
set_property  -dict {PACKAGE_PIN  AC21   IOSTANDARD LVCMOS18} [get_ports txnrx]                            ; ## G19  FMC_LPC_LA16_N

set_property  -dict {PACKAGE_PIN  AF33   IOSTANDARD LVCMOS18  PULLTYPE PULLUP} [get_ports spi_csn_0]         ; ## D26  FMC_LPC_LA26_P
set_property  -dict {PACKAGE_PIN  AG34   IOSTANDARD LVCMOS18} [get_ports spi_clk]                          ; ## D27  FMC_LPC_LA26_N
set_property  -dict {PACKAGE_PIN  AG31   IOSTANDARD LVCMOS18} [get_ports spi_mosi]                         ; ## C26  FMC_LPC_LA27_P
set_property  -dict {PACKAGE_PIN  AG32   IOSTANDARD LVCMOS18} [get_ports spi_miso]                         ; ## C27  FMC_LPC_LA27_N

# clocks

create_clock -name rx_clk       -period  4.00 [get_ports rx_clk_in_p]
#set_property CFGBVS 1.8V fmcomms2_kcu105

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

# daq3

set_property  -dict {PACKAGE_PIN  AK38} [get_ports tx_ref_clk_p]                                        ; ## D04  FMCP_HSPC_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  AK39} [get_ports tx_ref_clk_n]                                        ; ## D05  FMCP_HSPC_GBTCLK0_M2C_N
set_property  -dict {PACKAGE_PIN  AM38} [get_ports rx_ref_clk_p]                                        ; ## B20  FMCP_HSPC_GBTCLK1_M2C_P
set_property  -dict {PACKAGE_PIN  AM39} [get_ports rx_ref_clk_n]                                        ; ## B21  FMCP_HSPC_GBTCLK1_M2C_N

set_property  -dict {PACKAGE_PIN  AL30 IOSTANDARD LVDS} [get_ports rx_sync_p]                           ; ## D08  FMCP_HSPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AL31 IOSTANDARD LVDS} [get_ports rx_sync_n]                           ; ## D09  FMCP_HSPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  AT39 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]  ; ## G09  FMCP_HSPC_LA03_P
set_property  -dict {PACKAGE_PIN  AT40 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]  ; ## G10  FMCP_HSPC_LA03_N
set_property  -dict {PACKAGE_PIN  AJ32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]    ; ## H07  FMCP_HSPC_LA02_P
set_property  -dict {PACKAGE_PIN  AK32 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]    ; ## H08  FMCP_HSPC_LA02_N
set_property  -dict {PACKAGE_PIN  AR37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]  ; ## H10  FMCP_HSPC_LA04_P
set_property  -dict {PACKAGE_PIN  AT37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]  ; ## H11  FMCP_HSPC_LA04_N

set_property  -dict {PACKAGE_PIN  AP38 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                     ; ## D11  FMCP_HSPC_LA05_P
set_property  -dict {PACKAGE_PIN  AP35 IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                     ; ## C14  FMCP_HSPC_LA10_P
set_property  -dict {PACKAGE_PIN  AK33 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                     ; ## D15  FMCP_HSPC_LA09_N
set_property  -dict {PACKAGE_PIN  AR38 IOSTANDARD LVCMOS18} [get_ports spi_clk]                         ; ## D12  FMCP_HSPC_LA05_N
set_property  -dict {PACKAGE_PIN  AJ33 IOSTANDARD LVCMOS18} [get_ports spi_sdio]                        ; ## D14  FMCP_HSPC_LA09_P
set_property  -dict {PACKAGE_PIN  AT36 IOSTANDARD LVCMOS18} [get_ports spi_dir]                         ; ## C11  FMCP_HSPC_LA06_N

set_property  -dict {PACKAGE_PIN  AJ35 IOSTANDARD LVDS} [get_ports sysref_p]                            ; ## D17  FMCP_HSPC_LA13_P
set_property  -dict {PACKAGE_PIN  AJ36 IOSTANDARD LVDS} [get_ports sysref_n]                            ; ## D18  FMCP_HSPC_LA13_N
set_property  -dict {PACKAGE_PIN  AH34 IOSTANDARD LVCMOS18} [get_ports dac_txen]                        ; ## G16  FMCP_HSPC_LA12_N
set_property  -dict {PACKAGE_PIN  AT35 IOSTANDARD LVCMOS18} [get_ports adc_pd]                          ; ## C10  FMCP_HSPC_LA06_P

set_property  -dict {PACKAGE_PIN  AK29 IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                  ; ## G12  FMCP_HSPC_LA08_P
set_property  -dict {PACKAGE_PIN  AK30 IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                  ; ## G13  FMCP_HSPC_LA08_N
set_property  -dict {PACKAGE_PIN  AH33 IOSTANDARD LVCMOS18} [get_ports dac_irq]                         ; ## G15  FMCP_HSPC_LA12_P
set_property  -dict {PACKAGE_PIN  AJ30 IOSTANDARD LVCMOS18} [get_ports adc_fda]                         ; ## H16  FMCP_HSPC_LA11_P
set_property  -dict {PACKAGE_PIN  AJ31 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                         ; ## H17  FMCP_HSPC_LA11_N

set_property  -dict {PACKAGE_PIN  AP36 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]       ; ## H13  FMCP_HSPC_LA07_P
set_property  -dict {PACKAGE_PIN  AP37 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]       ; ## H14  FMCP_HSPC_LA07_N

set_property  -dict {PACKAGE_PIN  AJ45} [get_ports rx_data_p[0]]                                        ; ## A10  FMCP_HSPC_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  AJ46} [get_ports rx_data_n[0]]                                        ; ## A11  FMCP_HSPC_DP3_M2C_N
set_property  -dict {PACKAGE_PIN  AR45} [get_ports rx_data_p[1]]                                        ; ## C06  FMCP_HSPC_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  AR46} [get_ports rx_data_n[1]]                                        ; ## C07  FMCP_HSPC_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  AL45} [get_ports rx_data_p[2]]                                        ; ## A06  FMCP_HSPC_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  AL46} [get_ports rx_data_n[2]]                                        ; ## A07  FMCP_HSPC_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  AN45} [get_ports rx_data_p[3]]                                        ; ## A02  FMCP_HSPC_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  AN46} [get_ports rx_data_n[3]]                                        ; ## A03  FMCP_HSPC_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  AL40} [get_ports tx_data_p[0]]                                        ; ## A30  FMCP_HSPC_DP3_C2M_P (tx_data_p[0])
set_property  -dict {PACKAGE_PIN  AL41} [get_ports tx_data_n[0]]                                        ; ## A31  FMCP_HSPC_DP3_C2M_N (tx_data_n[0])
set_property  -dict {PACKAGE_PIN  AT42} [get_ports tx_data_p[1]]                                        ; ## C02  FMCP_HSPC_DP0_C2M_P (tx_data_p[3])
set_property  -dict {PACKAGE_PIN  AT43} [get_ports tx_data_n[1]]                                        ; ## C03  FMCP_HSPC_DP0_C2M_N (tx_data_n[3])
set_property  -dict {PACKAGE_PIN  AM42} [get_ports tx_data_p[2]]                                        ; ## A26  FMCP_HSPC_DP2_C2M_P (tx_data_p[1])
set_property  -dict {PACKAGE_PIN  AM43} [get_ports tx_data_n[2]]                                        ; ## A27  FMCP_HSPC_DP2_C2M_N (tx_data_n[1])
set_property  -dict {PACKAGE_PIN  AP42} [get_ports tx_data_p[3]]                                        ; ## A22  FMCP_HSPC_DP1_C2M_P (tx_data_p[2])
set_property  -dict {PACKAGE_PIN  AP43} [get_ports tx_data_n[3]]                                        ; ## A23  FMCP_HSPC_DP1_C2M_N (tx_data_n[2])

## clocks
create_clock -name tx_ref_clk   -period  1.60 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  1.60 [get_ports rx_ref_clk_p]

# For transceiver output clocks use reference clock divided by two
# This will help autoderive the clocks correcly
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/TXOUTCLKSEL[2]]

set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXSYSCLKSEL[1]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[0]]
set_case_analysis -quiet 0 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[1]]
set_case_analysis -quiet 1 [get_pins -quiet -hier *_channel/RXOUTCLKSEL[2]]

create_generated_clock -name tx_div_clk   [get_pins i_system_wrapper/system_i/util_daq3_xcvr/inst/i_xch_0/i_gtye4_channel/TXOUTCLK]
create_generated_clock -name rx_div_clk   [get_pins i_system_wrapper/system_i/util_daq3_xcvr/inst/i_xch_0/i_gtye4_channel/RXOUTCLK]


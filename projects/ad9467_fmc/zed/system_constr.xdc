###############################################################################
## Copyright (C) 2014-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
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

# ad9467

set_property -dict {PACKAGE_PIN L18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]         ; ## H4   FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN L19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]         ; ## H5   FMC_LPC_CLK0_M2C_N
set_property -dict {PACKAGE_PIN J21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]        ; ## G12  FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]        ; ## G13  FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN M20     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]     ; ## G7   FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]     ; ## G6   FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N19     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]     ; ## D8   FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN N20     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]     ; ## D9   FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN P17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]     ; ## H7   FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]     ; ## H8   FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN N22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]     ; ## G9   FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]     ; ## G10  FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]     ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]     ; ## H11  FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN J18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]     ; ## D11  FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]     ; ## D12  FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN L21     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]     ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN L22     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]     ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN T16     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]     ; ## H13  FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN T17     IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]     ; ## H14  FMC_LPC_LA07_N

## spi

set_property -dict {PACKAGE_PIN B22     IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                        ; ## G37  FMC_LPC_LA33_N
set_property -dict {PACKAGE_PIN B21     IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                        ; ## G36  FMC_LPC_LA33_P
set_property -dict {PACKAGE_PIN A22     IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ; ## H38  FMC_LPC_LA32_N
set_property -dict {PACKAGE_PIN A21     IOSTANDARD LVCMOS25} [get_ports spi_sdio]                           ; ## H37  FMC_LPC_LA32_P

# clocks
create_clock -name adc_clk      -period 4.00 [get_ports adc_clk_in_p]


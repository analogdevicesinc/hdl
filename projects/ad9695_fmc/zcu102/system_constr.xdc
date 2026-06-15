###############################################################################
## Copyright (C) 2022-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# ad9695

set_property  -dict {PACKAGE_PIN  G27}                        [get_ports ref_clk0_p]      ; ## FMC_HPC1_GBTCLK0_M2C_P
set_property  -dict {PACKAGE_PIN  G28}                        [get_ports ref_clk0_n]      ; ## FMC_HPC1_GBTCLK0_M2C_P

set_property  -dict {PACKAGE_PIN  D33}                        [get_ports rx_data_p[3]]    ; ## FMC_HPC1_DP1_M2C_P
set_property  -dict {PACKAGE_PIN  D34}                        [get_ports rx_data_n[3]]    ; ## FMC_HPC1_DP1_M2C_N
set_property  -dict {PACKAGE_PIN  C31}                        [get_ports rx_data_p[1]]    ; ## FMC_HPC1_DP2_M2C_P
set_property  -dict {PACKAGE_PIN  C32}                        [get_ports rx_data_n[1]]    ; ## FMC_HPC1_DP2_M2C_N
set_property  -dict {PACKAGE_PIN  E31}                        [get_ports rx_data_p[2]]    ; ## FMC_HPC1_DP0_M2C_P
set_property  -dict {PACKAGE_PIN  E32}                        [get_ports rx_data_n[2]]    ; ## FMC_HPC1_DP0_M2C_N
set_property  -dict {PACKAGE_PIN  B33}                        [get_ports rx_data_p[0]]    ; ## FMC_HPC1_DP3_M2C_P
set_property  -dict {PACKAGE_PIN  B34}                        [get_ports rx_data_n[0]]    ; ## FMC_HPC1_DP3_M2C_N

set_property  -dict {PACKAGE_PIN  AH2 IOSTANDARD LVCMOS18}    [get_ports spi_csn]         ; ## FMC_HPC1_LA06_P
set_property  -dict {PACKAGE_PIN  AD2 IOSTANDARD LVCMOS18}    [get_ports spi_miso]        ; ## FMC_HPC1_LA02_P
set_property  -dict {PACKAGE_PIN  AJ6 IOSTANDARD LVCMOS18}    [get_ports spi_clk]         ; ## FMC_HPC1_LA01_CC_P
set_property  -dict {PACKAGE_PIN  AJ5 IOSTANDARD LVCMOS18}    [get_ports spi_mosi]        ; ## FMC_HPC1_LA01_CC_N

set_property  -dict {PACKAGE_PIN  A20 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_csn]    ; ## PMOD0_0
set_property  -dict {PACKAGE_PIN  B20 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_mosi]   ; ## PMOD0_1
set_property  -dict {PACKAGE_PIN  A22 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_miso]   ; ## PMOD0_2
set_property  -dict {PACKAGE_PIN  A21 IOSTANDARD LVCMOS33}    [get_ports pmod_spi_clk]    ; ## PMOD0_3

set_property  -dict {PACKAGE_PIN  AD1  IOSTANDARD LVCMOS18}   [get_ports pwdn]            ; ## FMC_HPC1_LA02_N
set_property  -dict {PACKAGE_PIN  AH1  IOSTANDARD LVCMOS18}   [get_ports fda]             ; ## FMC_HPC1_LA03_P
set_property  -dict {PACKAGE_PIN  AJ1  IOSTANDARD LVCMOS18}   [get_ports fdb]             ; ## FMC_HPC1_LA03_N

set_property  -dict {PACKAGE_PIN  AF2  IOSTANDARD LVDS}       [get_ports rx_sync_p]       ; ## FMC_HPC1_LA04_P
set_property  -dict {PACKAGE_PIN  AF1  IOSTANDARD LVDS}       [get_ports rx_sync_n]       ; ## FMC_HPC1_LA04_N

set_property  -dict {PACKAGE_PIN  J27}                        [get_ports sysref_p]        ; ## USER_SMA_MGT_CLOCK_P
set_property  -dict {PACKAGE_PIN  J28}                        [get_ports sysref_n]        ; ## USER_SMA_MGT_CLOCK_N

## clocks
create_clock -period 3.07 -name rx_ref_clk [get_ports ref_clk0_p]

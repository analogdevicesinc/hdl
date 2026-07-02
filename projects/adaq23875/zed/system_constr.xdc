###############################################################################
## Copyright (C) 2022-2023, 2025-2026 Analog Devices, Inc. All rights reserved.
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

# adaq23875/adaq23876/adaq23878
# clocks

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_p]      ; ## G2   FMC_CLK1_M2C_P  IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports ref_clk_n]      ; ## G3   FMC_CLK1_M2C_N  IO_L12N_T1_MRCC_35
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVDS_25} [get_ports clk_p]                         ; ## G6   FMC_LA00_CC_P   IO_L13P_T2_MRCC_34
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVDS_25} [get_ports clk_n]                         ; ## G7   FMC_LA00_CC_N   IO_L13N_T2_MRCC_34

# fpga_cnv

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25} [get_ports cnv_p]                         ; ## D8   FMC_LA01_CC_P   IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25} [get_ports cnv_n]                         ; ## D9   FMC_LA01_CC_N   IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS25} [get_ports cnv_en]                       ; ## G10  FMC_LA03_N      IO_L16N_T2_34

# dco, da, db

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_p]          ; ## H4   FMC_CLK0_M2C_P  IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports dco_n]          ; ## H5   FMC_CLK0_M2C_N  IO_L12N_T1_MRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports da_p]           ; ## H7   FMC_LA02_P      IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports da_n]           ; ## H8   FMC_LA02_N      IO_L20N_T3_34
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db_p]           ; ## H10  FMC_LA04_P      IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports db_n]           ; ## H11  FMC_LA04_N      IO_L15N_T2_DQS_34

# 100MHz clock
set clk_period  10
# differential propagation delay for ref_clk
set tref_early  0.3
set tref_late   1.5

# clocks

create_clock -period $clk_period -name ref_clk  [get_ports ref_clk_p]

# clock latencies

# minimum source latency values
set_clock_latency -source -early $tref_early  [get_clocks ref_clk]
# maximum source latency values
set_clock_latency -source -late  $tref_late   [get_clocks ref_clk]

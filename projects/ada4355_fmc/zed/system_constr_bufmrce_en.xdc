###############################################################################
## Copyright (C) 2025-2026 Analog Devices, Inc. All rights reserved.
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

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_p]; ## H4 FMC_CLK0_M2C_P IO_L12P_T1_MRCC_34
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports dco_n]; ## H5 FMC_CLK0_M2C_N IO_L12N_T1_MRCC_34

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_p];  ## G9 FMC_LA03_P IO_L16P_T2_34
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d0a_n];  ## G10 FMC_LA03_N IO_L16N_T2_34

set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_p];  ## H10 FMC_LA04_P IO_L15P_T2_DQS_34
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports d1a_n];  ## H11 FMC_LA04_N IO_L15N_T2_DQS_34

set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_p]; ## G2  FMC_CLK1_M2C_P IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports frame_n]; ## G3 FMC_CLK1_M2C_N IO_L12N_T1_MRCC_35

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports fsel];          ## H25 FMC_LA21_P IO_L21P_T3_DQS_AD14P_35
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports gain_sel0];     ## G21 FMC_LA20_P IO_L22P_T3_AD7P_35
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports gain_sel1];     ## G22 FMC_LA20_N IO_L22N_T3_AD7N_35
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS25} [get_ports gain_sel2];     ## H29 FMC_LA24_N IO_L10N_T1_AD11N_35
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports gpio_1p8vd_en]; ## G16 FMC_LA12_N IO_L18N_T2_34
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS25} [get_ports gpio_1p8va_en]; ## D23 FMC_LA23_P IO_L3P_T0_DQS_AD1P_35

set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports csb_apd_pot];   ## G12 FMC_LA08_P IO_L8P_T1_34
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports csb_ld_pot];    ## G15 FMC_LA12_P IO_L18P_T2_34
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports sclk_pot];      ## D9 FMC_LA01_CC_N IO_L14N_T2_SRCC_34
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25} [get_ports mosi_pot];      ## H14 FMC_LA07_N IO_L21N_T3_DQS_34
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports miso_pot];      ## H13 FMC_LA07_P IO_L21P_T3_DQS_34

set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS25} [get_ports ada4355_csn];   ## G13 FMC_LA08_N IO_L8N_T1_34
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ada4355_sclk];  ## D8  FMC_LA01_CC_P IO_L14P_T2_SRCC_34
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports ada4355_mosi];  ## H7 FMC_LA02_P IO_L20P_T3_34
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports ada4355_miso];  ## H8 FMC_LA02_N IO_L20N_T3_34

# clocks

create_clock -period 2.000 -name dco_clk [get_ports dco_p]

set_false_path -to [get_pins i_system_wrapper/system_i/axi_ada4355_adc/inst/i_ada4355_interface/bufr_alignment_reg/CLR]
set_false_path -to [get_pins i_system_wrapper/system_i/axi_ada4355_adc/inst/i_ada4355_interface/bufr_alignment_bufr_reg/PRE]

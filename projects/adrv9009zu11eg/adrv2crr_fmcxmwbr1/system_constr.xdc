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

# gpios

set_property -dict {PACKAGE_PIN AG22  IOSTANDARD LVCMOS18} [get_ports gpio0]      ; ## LA10_P     IO_L20P_T3L_N2_AD1P_67
set_property -dict {PACKAGE_PIN AG23  IOSTANDARD LVCMOS18} [get_ports gpio1]      ; ## LA10_N     IO_L20N_T3L_N3_AD1N_67
set_property -dict {PACKAGE_PIN H31   IOSTANDARD LVCMOS18} [get_ports gpio2]      ; ## LA13_P     IO_L8P_T1L_N2_AD5P_68
set_property -dict {PACKAGE_PIN H32   IOSTANDARD LVCMOS18} [get_ports gpio3]      ; ## LA13_N     IO_L8N_T1L_N3_AD5N_68
set_property -dict {PACKAGE_PIN AJ26  IOSTANDARD LVCMOS18} [get_ports gpio4]      ; ## LA05_N     IO_L21N_T3L_N5_AD8N_67
set_property -dict {PACKAGE_PIN AJ25  IOSTANDARD LVCMOS18} [get_ports gpio5]      ; ## LA05_P     IO_L21P_T3L_N4_AD8P_67
set_property -dict {PACKAGE_PIN AJ22  IOSTANDARD LVCMOS18} [get_ports gpio6]      ; ## LA06_N     IO_L22N_T3U_N7_DBC_AD0N_67
set_property -dict {PACKAGE_PIN AH22  IOSTANDARD LVCMOS18} [get_ports gpio7]      ; ## LA06_P     IO_L22P_T3U_N6_DBC_AD0P_67

# gpio directions

set_property -dict {PACKAGE_PIN AT25  IOSTANDARD LVCMOS18} [get_ports dir_gpio0]  ; ## LA04_N     IO_L9N_T1L_N5_AD12N_67
set_property -dict {PACKAGE_PIN AR25  IOSTANDARD LVCMOS18} [get_ports dir_gpio1]  ; ## LA04_P     IO_L9P_T1L_N4_AD12P_67
set_property -dict {PACKAGE_PIN AK25  IOSTANDARD LVCMOS18} [get_ports dir_gpio2]  ; ## LA03_N     IO_L19N_T3L_N1_DBC_AD9N_67
set_property -dict {PACKAGE_PIN AK24  IOSTANDARD LVCMOS18} [get_ports dir_gpio3]  ; ## LA03_P     IO_L19P_T3L_N0_DBC_AD9P_67
set_property -dict {PACKAGE_PIN AW27  IOSTANDARD LVCMOS18} [get_ports dir_gpio4]  ; ## LA02_N     IO_L1N_T0L_N1_DBC_67
set_property -dict {PACKAGE_PIN AW26  IOSTANDARD LVCMOS18} [get_ports dir_gpio5]  ; ## LA02_P     IO_L1P_T0L_N0_DBC_67
set_property -dict {PACKAGE_PIN AR24  IOSTANDARD LVCMOS18} [get_ports dir_gpio6]  ; ## LA00_N_CC  IO_L12N_T1U_N11_GC_67
set_property -dict {PACKAGE_PIN AP24  IOSTANDARD LVCMOS18} [get_ports dir_gpio7]  ; ## LA00_P_CC  IO_L12P_T1U_N10_GC_67

# iic

set_property -dict {PACKAGE_PIN A37   IOSTANDARD LVCMOS18} [get_ports sclout1]    ; ## LA26_P     IO_L24P_T3U_N10_68
set_property -dict {PACKAGE_PIN A38   IOSTANDARD LVCMOS18} [get_ports sdaout1]    ; ## LA26_N     IO_L24N_T3U_N11_68
set_property -dict {PACKAGE_PIN F38   IOSTANDARD LVCMOS18} [get_ports sclout2]    ; ## LA23_P     IO_L2P_T0L_N2_68
set_property -dict {PACKAGE_PIN E38   IOSTANDARD LVCMOS18} [get_ports sdaout2]    ; ## LA23_N     IO_L2N_T0L_N3_68

set_property PULLUP true [get_ports sclout1]
set_property PULLUP true [get_ports sdaout1]
set_property PULLUP true [get_ports sclout2]
set_property PULLUP true [get_ports sdaout2]

# spi

set_property -dict {PACKAGE_PIN AM24 IOSTANDARD LVCMOS18} [get_ports spi1_clk]    ; ## LA16_N     IO_L18N_T2U_N11_AD2N_67
set_property -dict {PACKAGE_PIN J32  IOSTANDARD LVCMOS18} [get_ports spi1_copi]   ; ## LA20_P     IO_L7P_T1L_N0_QBC_AD13P_68
set_property -dict {PACKAGE_PIN H33  IOSTANDARD LVCMOS18} [get_ports spi1_cipo]   ; ## LA20_N     IO_L7N_T1L_N1_QBC_AD13N_68
set_property -dict {PACKAGE_PIN B38  IOSTANDARD LVCMOS18} [get_ports spi1_cs0]    ; ## LA25_N     IO_L21N_T3L_N5_AD8N_68
set_property -dict {PACKAGE_PIN C37  IOSTANDARD LVCMOS18} [get_ports spi1_cs1]    ; ## LA25_P     IO_L21P_T3L_N4_AD8P_68
set_property -dict {PACKAGE_PIN B34  IOSTANDARD LVCMOS18} [get_ports spi1_cs2]    ; ## LA21_N     IO_L16N_T2U_N7_QBC_AD3N_68
set_property -dict {PACKAGE_PIN B33  IOSTANDARD LVCMOS18} [get_ports spi1_cs3]    ; ## LA21_P     IO_L16P_T2U_N6_QBC_AD3P_68
set_property -dict {PACKAGE_PIN H39  IOSTANDARD LVCMOS18} [get_ports spi1_cs4]    ; ## LA22_N     IO_L1N_T0L_N1_DBC_68
set_property -dict {PACKAGE_PIN H38  IOSTANDARD LVCMOS18} [get_ports spi1_cs5]    ; ## LA22_P     IO_L1P_T0L_N0_DBC_68
set_property -dict {PACKAGE_PIN C39  IOSTANDARD LVCMOS18} [get_ports spi1_cs6]    ; ## LA19_N     IO_L20N_T3L_N3_AD1N_68
set_property -dict {PACKAGE_PIN C38  IOSTANDARD LVCMOS18} [get_ports spi1_cs7]    ; ## LA19_P     IO_L20P_T3L_N2_AD1P_68

set_property -dict {PACKAGE_PIN AT22 IOSTANDARD LVCMOS18} [get_ports spi2_clk]    ; ## LA24_N     IO_L8N_T1L_N3_AD5N_67
set_property -dict {PACKAGE_PIN E35  IOSTANDARD LVCMOS18} [get_ports spi2_copi]   ; ## LA28_P     IO_L13P_T2L_N0_GC_QBC_68
set_property -dict {PACKAGE_PIN D35  IOSTANDARD LVCMOS18} [get_ports spi2_cipo]   ; ## LA28_N     IO_L13N_T2L_N1_GC_QBC_68
set_property -dict {PACKAGE_PIN A32  IOSTANDARD LVCMOS18} [get_ports spi2_cs0]    ; ## LA31_P     IO_L18P_T2U_N10_AD2P_68
set_property -dict {PACKAGE_PIN A33  IOSTANDARD LVCMOS18} [get_ports spi2_cs1]    ; ## LA31_N     IO_L18N_T2U_N11_AD2N_68
set_property -dict {PACKAGE_PIN AK22 IOSTANDARD LVCMOS18} [get_ports spi2_cs2]    ; ## LA30_P     IO_L24P_T3U_N10_67
set_property -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS18} [get_ports spi2_cs3]    ; ## LA30_N     IO_L24N_T3U_N11_67
set_property -dict {PACKAGE_PIN D32  IOSTANDARD LVCMOS18} [get_ports spi2_cs4]    ; ## LA33_P     IO_L17P_T2U_N8_AD10P_68
set_property -dict {PACKAGE_PIN C32  IOSTANDARD LVCMOS18} [get_ports spi2_cs5]    ; ## LA33_N     IO_L17N_T2U_N9_AD10N_68
set_property -dict {PACKAGE_PIN G33  IOSTANDARD LVCMOS18} [get_ports spi2_cs6]    ; ## LA32_P     IO_L9P_T1L_N4_AD12P_68
set_property -dict {PACKAGE_PIN G34  IOSTANDARD LVCMOS18} [get_ports spi2_cs7]    ; ## LA32_N     IO_L9N_T1L_N5_AD12N_68

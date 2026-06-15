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

# AD485x
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25}                          [get_ports lvds_cmos_n]  ; ##  C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25}                          [get_ports pd]           ; ##  H08  FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25}                          [get_ports cnv]          ; ##  H07  FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25}                          [get_ports busy]         ; ##  C11  FMC_LPC_LA06_N

# SPI
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS25}                          [get_ports csck]         ; ##  D14  FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25}                          [get_ports csdio]        ; ##  D17  FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25}                          [get_ports cs_n]         ; ##  D18  FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25}                          [get_ports csd0]         ; ##  D27  FMC_LPC_LA26_N

# LVDS
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVDS_25}                           [get_ports scki_p]       ; ##  D08  FMC_LPC_LA01_CC_P     # SCKI+
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25}                           [get_ports scki_n]       ; ##  D09  FMC_LPC_LA01_CC_N     # SCKI-
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports sdo_p]        ; ##  C26  FMC_LPC_LA27_P        # SD0+
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports sdo_n]        ; ##  C27  FMC_LPC_LA27_N        # SD0-
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports scko_p]       ; ##  D20  FMC_LPC_LA17_CC_P     # scko+
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25 DIFF_TERM TRUE}            [get_ports scko_n]       ; ##  D21  FMC_LPC_LA17_CC_N     # scko-

create_clock -period 2.5 -name scko [get_ports scko_p]
set_false_path -from [get_clocks scko] -to [get_clocks -of_objects [get_pins i_system_wrapper/system_i/adc_clkgen/inst/i_mmcm_drp/i_mmcm/CLKOUT0]]

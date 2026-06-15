###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# ad9265

set_property -dict {PACKAGE_PIN AG17    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_p]         ;
set_property -dict {PACKAGE_PIN AG16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_clk_in_n]         ;
set_property -dict {PACKAGE_PIN AF15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_p]        ;
set_property -dict {PACKAGE_PIN AG15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_or_n]        ;
set_property -dict {PACKAGE_PIN AH14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[0]]     ;
set_property -dict {PACKAGE_PIN AH13    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[0]]     ;
set_property -dict {PACKAGE_PIN AB12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[1]]     ;
set_property -dict {PACKAGE_PIN AC12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[1]]     ;
set_property -dict {PACKAGE_PIN AA15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[2]]     ;
set_property -dict {PACKAGE_PIN AA14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[2]]     ;
set_property -dict {PACKAGE_PIN AD14    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[3]]     ;
set_property -dict {PACKAGE_PIN AD13    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[3]]     ;
set_property -dict {PACKAGE_PIN AJ15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[4]]     ;
set_property -dict {PACKAGE_PIN AK15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[4]]     ;
set_property -dict {PACKAGE_PIN AE16    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[5]]     ;
set_property -dict {PACKAGE_PIN AE15    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[5]]     ;
set_property -dict {PACKAGE_PIN AE12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[6]]     ;
set_property -dict {PACKAGE_PIN AF12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[6]]     ;
set_property -dict {PACKAGE_PIN AG12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_p[7]]     ;
set_property -dict {PACKAGE_PIN AH12    IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc_data_in_n[7]]     ;

## spi

set_property -dict {PACKAGE_PIN AA30    IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]                        ;
set_property -dict {PACKAGE_PIN Y30     IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]                        ;
set_property -dict {PACKAGE_PIN Y27     IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ;
set_property -dict {PACKAGE_PIN Y26     IOSTANDARD LVCMOS25} [get_ports spi_sdio]                           ;

# clocks

create_clock -name adc_clk      -period 8.000 [get_ports adc_clk_in_p]

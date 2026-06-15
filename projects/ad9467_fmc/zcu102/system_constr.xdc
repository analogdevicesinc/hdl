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

set_property -dict {PACKAGE_PIN AA7     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_clk_in_p]         ; ## FMC_HPC0_CLK0_M2C_P
set_property -dict {PACKAGE_PIN AA6     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_clk_in_n]         ; ## FMC_HPC0_CLK0_M2C_N
set_property -dict {PACKAGE_PIN V4      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_or_p]        ; ## FMC_HPC0_LA08_P    
set_property -dict {PACKAGE_PIN V3      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_or_n]        ; ## FMC_HPC0_LA08_N    
set_property -dict {PACKAGE_PIN Y3      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[0]]     ; ## FMC_HPC0_LA00_CC_N 
set_property -dict {PACKAGE_PIN Y4      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[0]]     ; ## FMC_HPC0_LA00_CC_P 
set_property -dict {PACKAGE_PIN AB4     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[1]]     ; ## FMC_HPC0_LA01_CC_P 
set_property -dict {PACKAGE_PIN AC4     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[1]]     ; ## FMC_HPC0_LA01_CC_N 
set_property -dict {PACKAGE_PIN V2      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[2]]     ; ## FMC_HPC0_LA02_P    
set_property -dict {PACKAGE_PIN V1      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[2]]     ; ## FMC_HPC0_LA02_N    
set_property -dict {PACKAGE_PIN Y2      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[3]]     ; ## FMC_HPC0_LA03_P    
set_property -dict {PACKAGE_PIN Y1      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[3]]     ; ## FMC_HPC0_LA03_N    
set_property -dict {PACKAGE_PIN AA2     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[4]]     ; ## FMC_HPC0_LA04_P    
set_property -dict {PACKAGE_PIN AA1     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[4]]     ; ## FMC_HPC0_LA04_N    
set_property -dict {PACKAGE_PIN AB3     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[5]]     ; ## FMC_HPC0_LA05_P    
set_property -dict {PACKAGE_PIN AC3     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[5]]     ; ## FMC_HPC0_LA05_N    
set_property -dict {PACKAGE_PIN AC2     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[6]]     ; ## FMC_HPC0_LA06_P    
set_property -dict {PACKAGE_PIN AC1     IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[6]]     ; ## FMC_HPC0_LA06_N    
set_property -dict {PACKAGE_PIN U5      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_p[7]]     ; ## FMC_HPC0_LA07_P    
set_property -dict {PACKAGE_PIN U4      IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports adc_data_in_n[7]]     ; ## FMC_HPC0_LA07_N    

## spi

set_property -dict {PACKAGE_PIN V11     IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                        ; ## FMC_HPC0_LA33_N
set_property -dict {PACKAGE_PIN V12     IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                        ; ## FMC_HPC0_LA33_P
set_property -dict {PACKAGE_PIN T11     IOSTANDARD LVCMOS18} [get_ports spi_clk]                            ; ## FMC_HPC0_LA32_N
set_property -dict {PACKAGE_PIN U11     IOSTANDARD LVCMOS18} [get_ports spi_sdio]                           ; ## FMC_HPC0_LA32_P

# clocks
create_clock -name adc_clk      -period 4.00 [get_ports adc_clk_in_p]

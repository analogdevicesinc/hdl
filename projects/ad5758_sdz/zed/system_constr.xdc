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

# DAC SPI interface

set_property -dict {PACKAGE_PIN E15  IOSTANDARD LVCMOS33} [get_ports spi_sclk]           ; ## FMC-LA23_P 
set_property -dict {PACKAGE_PIN D20  IOSTANDARD LVCMOS33} [get_ports spi_sdi]            ; ## FMC-LA18_CC_P 
set_property -dict {PACKAGE_PIN B20  IOSTANDARD LVCMOS33} [get_ports spi_sdo]            ; ## FMC-LA17_CC_N
set_property -dict {PACKAGE_PIN B19  IOSTANDARD LVCMOS33} [get_ports spi_sync_n]         ; ## FMC-LA17_CC_P

# DAC GPIO interface
set_property -dict {PACKAGE_PIN F19  IOSTANDARD LVCMOS33} [get_ports dac_fault_n]        ; ## FMC-LA22_N 
set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS33} [get_ports dac_reset_n]        ; ## FMC-LA21_P
set_property -dict {PACKAGE_PIN F18  IOSTANDARD LVCMOS33} [get_ports dac_ldac_n]         ; ## FMC-LA26_P 

# Reconfigure the pins from Bank 34 and Bank 35 to use LVCMOS33 since VADJ must be set to 3.3V

# otg
set_property IOSTANDARD LVCMOS33 [get_ports otg_vbusoc]

# gpio (switches, leds and such)
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[0]]       ; ## BTNC
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[1]]       ; ## BTND
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[2]]       ; ## BTNL
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[3]]       ; ## BTNR
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[4]]       ; ## BTNU

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[11]]      ; ## SW0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[12]]      ; ## SW1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[13]]      ; ## SW2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[14]]      ; ## SW3
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[15]]      ; ## SW4
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[16]]      ; ## SW5
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[17]]      ; ## SW6
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[18]]      ; ## SW7

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[30]]      ; ## XADC-GIO3

set_property IOSTANDARD LVCMOS33 [get_ports gpio_bd[31]]      ; ## OTG-RESETN


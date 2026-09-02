###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# PMOD JA

set_property -dict {PACKAGE_PIN Y11  IOSTANDARD LVCMOS33} [get_ports gain0_o]                       ; ## PMOD JA1  
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports gain1_o]                       ; ## PMOD JA2 
set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports led_clk_o]                     ; ## PMOD JA4 
set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS33} [get_ports {spi_cs[1]}]                   ; ## PMOD JA3 
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {spi_cs[0]}]                   ; ## PMOD JA7 
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdo]           ; ## PMOD JA8 
set_property -dict {PACKAGE_PIN AB9  IOSTANDARD LVCMOS33 PULLUP true} [get_ports spi_sdi]           ; ## PMOD JA9 
set_property -dict {PACKAGE_PIN AA8  IOSTANDARD LVCMOS33} [get_ports spi_sclk]                      ; ## PMOD JA10

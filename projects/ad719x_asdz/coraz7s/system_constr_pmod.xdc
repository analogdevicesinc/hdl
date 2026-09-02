###############################################################################
## Copyright (C) 2022-2024, 2026 Analog Devices, Inc. All rights reserved.
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

# coraz7s
# ad719x spi connections

# connect through the PMOD pins

set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports adc_spi_sclk];      # IO_L7N_T1_34  Sch=ja_n[2]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports adc_spi_miso_rdyn]; # IO_L7P_T1_34  Sch=ja_p[2]; AD719X sch=DOUT/RDY_N
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports adc_spi_mosi];      # IO_L17N_T2_34 Sch=ja_n[1]; AD719X sch=DIN
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports adc_spi_csn];       # IO_L17P_T2_34 Sch=ja_p[1]

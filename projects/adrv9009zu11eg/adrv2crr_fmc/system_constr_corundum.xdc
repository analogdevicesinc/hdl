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

set_property -dict {PACKAGE_PIN  AU11 IOSTANDARD LVCMOS18 } [get_ports qsfp_resetl  ] ;
set_property -dict {PACKAGE_PIN  AL12 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_modprsl ] ;
set_property -dict {PACKAGE_PIN  AW14 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_intl    ] ;
set_property -dict {PACKAGE_PIN  AV11 IOSTANDARD LVCMOS18 } [get_ports qsfp_lpmode  ] ;

set_property PACKAGE_PIN AD2   [get_ports qsfp_rx_p[0] ] ;
set_property PACKAGE_PIN AD1   [get_ports qsfp_rx_n[0] ] ;

set_property PACKAGE_PIN AC4   [get_ports qsfp_rx_p[1] ] ;
set_property PACKAGE_PIN AC3   [get_ports qsfp_rx_n[1] ] ;

set_property PACKAGE_PIN AB2   [get_ports qsfp_rx_p[2] ] ;
set_property PACKAGE_PIN AB1   [get_ports qsfp_rx_n[2] ] ;

set_property PACKAGE_PIN AA4   [get_ports qsfp_rx_p[3] ] ;
set_property PACKAGE_PIN AA3   [get_ports qsfp_rx_n[3] ] ;

set_property PACKAGE_PIN AD6   [get_ports qsfp_tx_p[0] ] ;
set_property PACKAGE_PIN AD5   [get_ports qsfp_tx_n[0] ] ;

set_property PACKAGE_PIN AC8   [get_ports qsfp_tx_p[1] ] ;
set_property PACKAGE_PIN AC7   [get_ports qsfp_tx_n[1] ] ;

set_property PACKAGE_PIN AB6   [get_ports qsfp_tx_p[2] ] ;
set_property PACKAGE_PIN AB5   [get_ports qsfp_tx_n[2] ] ;

set_property PACKAGE_PIN AA8   [get_ports qsfp_tx_p[3] ] ;
set_property PACKAGE_PIN AA7   [get_ports qsfp_tx_n[3] ] ;

set_property PACKAGE_PIN AD10  [get_ports qsfp_mgt_refclk_p ] ;
set_property PACKAGE_PIN AD9   [get_ports qsfp_mgt_refclk_n ] ;


# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name gt_ref_clk [get_ports qsfp_mgt_refclk_p]

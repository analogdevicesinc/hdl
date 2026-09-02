###############################################################################
## Copyright (C) 2017-2023, 2026 Analog Devices, Inc. All rights reserved.
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

# gpio (pmods)

set_property  -dict {PACKAGE_PIN  P17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[8]]   ; ## PMOD2_3_LS
set_property  -dict {PACKAGE_PIN  P18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[9]]   ; ## PMOD2_2_LS
set_property  -dict {PACKAGE_PIN  W10   IOSTANDARD LVCMOS25} [get_ports gpio_bd[10]]  ; ## PMOD2_1_LS
set_property  -dict {PACKAGE_PIN  V7    IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]  ; ## PMOD2_0_LS
set_property  -dict {PACKAGE_PIN  E15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]  ; ## PMOD1_0_LS
set_property  -dict {PACKAGE_PIN  D15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]  ; ## PMOD1_1_LS
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]  ; ## PMOD1_2_LS
set_property  -dict {PACKAGE_PIN  W5    IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]  ; ## PMOD1_3_LS


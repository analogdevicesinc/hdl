###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
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

create_clock -period 6.400 -name gt_ref_clk [get_ports gt_ref_clk_p]

set_property -dict {PACKAGE_PIN AB11} [get_ports gt_ref_clk_p]
set_property -dict {PACKAGE_PIN AB10} [get_ports gt_ref_clk_n]

set_property -dict {PACKAGE_PIN AF2} [get_ports qsfp_serial_grx_p[0]]
set_property -dict {PACKAGE_PIN AF1} [get_ports qsfp_serial_grx_n[0]]
set_property -dict {PACKAGE_PIN AE4} [get_ports qsfp_serial_grx_p[1]]
set_property -dict {PACKAGE_PIN AE3} [get_ports qsfp_serial_grx_n[1]]
set_property -dict {PACKAGE_PIN AD2} [get_ports qsfp_serial_grx_p[2]]
set_property -dict {PACKAGE_PIN AD1} [get_ports qsfp_serial_grx_n[2]]
set_property -dict {PACKAGE_PIN AC4} [get_ports qsfp_serial_grx_p[3]]
set_property -dict {PACKAGE_PIN AC3} [get_ports qsfp_serial_grx_n[3]]

set_property -dict {PACKAGE_PIN AF7} [get_ports qsfp_serial_gtx_p[0]]
set_property -dict {PACKAGE_PIN AF6} [get_ports qsfp_serial_gtx_n[0]]
set_property -dict {PACKAGE_PIN AE9} [get_ports qsfp_serial_gtx_p[1]]
set_property -dict {PACKAGE_PIN AE8} [get_ports qsfp_serial_gtx_n[1]]
set_property -dict {PACKAGE_PIN AD7} [get_ports qsfp_serial_gtx_p[2]]
set_property -dict {PACKAGE_PIN AD6} [get_ports qsfp_serial_gtx_n[2]]
set_property -dict {PACKAGE_PIN AC9} [get_ports qsfp_serial_gtx_p[3]]
set_property -dict {PACKAGE_PIN AC8} [get_ports qsfp_serial_gtx_n[3]]

set_clock_groups -asynchronous \
  -group [get_clocks clk_pl_0] \
  -group [get_clocks gt_ref_clk]

set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports qsfp_resetl]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports qsfp_lpmode]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports qsfp_modsell]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports qsfp_modprsl]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports qsfp_intl]

set_false_path -to   [get_ports {qsfp_resetl qsfp_lpmode qsfp_modsell}]
set_false_path -from [get_ports {qsfp_modprsl qsfp_intl}]

create_waiver -quiet -type DRC -id {REQP-2057} -user "ad9084_ebz_vck190" \
  -desc "MBUFG_GT CLR and CLRBLEAF pins are connected appropriately" \
  -objects [get_cells -quiet -hier -filter {REF_NAME==MBUFG_GT}]

create_waiver -quiet -type DRC -id {XDCH-2} -user "ad9084_ebz_vck190" \
  -desc "GT placement is intentional for this design"

###############################################################################
## Copyright (C) 2020-2023, 2026 Analog Devices, Inc. All rights reserved.
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

package require qsys 14.0
source ../../scripts/adi_env.tcl
source ../scripts/adi_ip_intel.tcl

set_module_property NAME axi_sysid
set_module_property DESCRIPTION "AXI System ID"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME axi_sysid

# source files

ad_ip_files axi_sysid [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "axi_sysid.v"]

# IP parameters

add_parameter ROM_WIDTH INTEGER 32
set_parameter_property ROM_WIDTH DEFAULT_VALUE 32
set_parameter_property ROM_WIDTH DISPLAY_NAME "ROM width"
set_parameter_property ROM_WIDTH UNITS None
set_parameter_property ROM_WIDTH HDL_PARAMETER true

add_parameter ROM_ADDR_BITS INTEGER 9
set_parameter_property ROM_ADDR_BITS DEFAULT_VALUE 9
set_parameter_property ROM_ADDR_BITS DISPLAY_NAME "ROM address bits"
set_parameter_property ROM_ADDR_BITS HDL_PARAMETER true

# AXI4 Memory Mapped Interface

ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 15

# external clock and control/status ports

ad_interface signal sys_rom_data       input  ROM_WIDTH rom_data
ad_interface signal pr_rom_data        input  ROM_WIDTH rom_data
ad_interface signal rom_addr           output ROM_ADDR_BITS

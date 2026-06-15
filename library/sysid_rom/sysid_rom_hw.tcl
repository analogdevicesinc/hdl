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

set_module_property NAME sysid_rom
set_module_property DESCRIPTION "System ID ROM"
set_module_property VERSION 1.0
set_module_property GROUP "Analog Devices"
set_module_property DISPLAY_NAME sysid_rom

# source files

ad_ip_files sysid_rom [list \
  "sysid_rom.v"]

# IP parameters

add_parameter ROM_WIDTH INTEGER 32
set_parameter_property ROM_WIDTH DEFAULT_VALUE 32
set_parameter_property ROM_WIDTH DISPLAY_NAME "ROM width"
set_parameter_property ROM_WIDTH UNITS None
set_parameter_property ROM_WIDTH HDL_PARAMETER true

add_parameter ROM_ADDR_BITS INTEGER 6
set_parameter_property ROM_ADDR_BITS DEFAULT_VALUE 6
set_parameter_property ROM_ADDR_BITS DISPLAY_NAME "ROM address bits"
set_parameter_property ROM_ADDR_BITS HDL_PARAMETER true

add_parameter PATH_TO_FILE STRING "path_to_mem_init_file"
set_parameter_property PATH_TO_FILE DISPLAY_NAME "Path to file"
set_parameter_property PATH_TO_FILE HDL_PARAMETER true

# external clock and control/status ports

ad_interface clock  clk               input  1
ad_interface signal rom_data          output ROM_WIDTH  rom_data
ad_interface signal rom_addr          input  ROM_ADDR_BITS

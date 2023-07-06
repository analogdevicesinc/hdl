###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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

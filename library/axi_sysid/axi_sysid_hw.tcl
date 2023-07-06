###############################################################################
## Copyright (C) 2020-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
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

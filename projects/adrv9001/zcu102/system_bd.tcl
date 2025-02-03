###############################################################################
## Copyright (C) 2014-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/adrv9001_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

if { [expr $ad_project_params(CMOS_LVDS_N) == 0] } {
  ad_ip_parameter axi_adrv9001 CONFIG.USE_RX_CLK_FOR_TX1 1
  ad_ip_parameter axi_adrv9001 CONFIG.USE_RX_CLK_FOR_TX2 2
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

if {$ad_project_params(CMOS_LVDS_N) == 0} {
  set sys_cstring "LVDS"
} else {
  set sys_cstring "CMOS"
}

sysid_gen_sys_init_file $sys_cstring

set_property strategy Flow_RunPostRoutePhysOpt [get_runs impl_1]

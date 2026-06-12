###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

if {$ad_project_params(CORUNDUM) == "1"} {
  source $ad_hdl_dir/library/corundum/scripts/corundum_vcu118_cfg.tcl
  # Location to update Corundum configuration parameters after importing defaults
  source $ad_hdl_dir/projects/common/vcu118/vcu118_corundum_bd.tcl
}

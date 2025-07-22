###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/ada4355_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set BUFMRCE_EN $ad_project_params(BUFMRCE_EN)
set sys_cstring "BUFMRCE_EN"

sysid_gen_sys_init_file $sys_cstring

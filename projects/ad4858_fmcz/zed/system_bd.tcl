###############################################################################
## Copyright (C) 2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source ../common/ad4858_fmcz_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "LVDS_CMOS_N=$LVDS_CMOS_N"
sysid_gen_sys_init_file $sys_cstring

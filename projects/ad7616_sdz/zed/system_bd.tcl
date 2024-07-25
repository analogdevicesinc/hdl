###############################################################################
## Copyright (C) 2019-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# add RTL source that will be instantiated in system_bd directly
adi_project_files ad7616_sdz_zed [list \
       "../../../library/common/ad_edge_detect.v" \
       "../../../library/util_cdc/sync_bits.v"]

# block design
source ../common/ad7616_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "SER_PAR_N=$ad_project_params(SER_PAR_N)"

sysid_gen_sys_init_file $sys_cstring

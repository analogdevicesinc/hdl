###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v"]

source ../common/ad7606x_bd.tcl

set DEV_CONFIG $ad_project_params(DEV_CONFIG)
set EXT_CLK $ad_project_params(EXT_CLK)

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "DEV_CONFIG=$DEV_CONFIG\
NUM_OF_SDI=$NUM_OF_SDI\
EXT_CLK=$EXT_CLK"

sysid_gen_sys_init_file $sys_cstring

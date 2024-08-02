###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

# add RTL source that will be instantiated in system_bd directly
adi_project_files ad7606x_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v"]

# block design
source ../common/ad7606x_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "INTF=$ad_project_params(INTF)\
ADC_N_BITS=$ad_project_params(ADC_N_BITS)\
NUM_OF_SDI=$ad_project_params(NUM_OF_SDI)"

sysid_gen_sys_init_file $sys_cstring

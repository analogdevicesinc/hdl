###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 0
set adc_offload_size [expr 1 * 1024 * 1024]

set dac_offload_type 0
set dac_offload_size [expr 1 * 1024 * 1024]

set plddr_offload_axi_data_width 0

## NOTE: With this configuration the #36Kb BRAM utilization is at ~57%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source ../common/daq2_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "ADC_OFFLOAD_TYPE=$adc_offload_type\nDAC_OFFLOAD_TYPE=$dac_offload_type"
sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq2_xcvr CONFIG.QPLL_REFCLK_DIV 1

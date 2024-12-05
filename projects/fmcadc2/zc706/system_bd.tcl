###############################################################################
## Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 1                      ; ## PL_DDR
set adc_offload_size [expr 1024*1024*1024]  ; ## 1 GB
set plddr_offload_axi_data_width 512

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_data_offload_bd.tcl
source ../common/fmcadc2_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

ad_plddr_data_offload_create $adc_offload_name

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
ADC_OFFLOAD:TYPE=$adc_offload_type\
SIZE=$adc_offload_size"

sysid_gen_sys_init_file $sys_cstring

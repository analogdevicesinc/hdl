###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 1                              ; ## PL_DDR
set adc_offload_size [expr 1 * 1024 * 1024 * 1024]  ; ## 1 Gbyte

set dac_offload_type 0                              ; ## BRAM
set dac_offload_size [expr 1 * 1024 * 1024]         ; ## 1 MByte

set plddr_offload_axi_data_width 512

## NOTE: With this configuration the #36Kb BRAM utilization is at ~52%

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_data_offload_bd.tcl
source ../common/daq2_bd.tcl

################################################################################
## DDR3 MIG for Data Offload IP
################################################################################

if {$adc_offload_type} {
  set offload_name axi_ad9680_offload
}

if {$dac_offload_type} {
  set offload_name axi_ad9144_offload
}

if {$adc_offload_type || $dac_offload_type} {
  ad_plddr_data_offload_create $offload_name
}

################################################################################
# System ID
################################################################################

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
TX:M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
ADC_OFFLOAD:TYPE=$adc_offload_type\
SIZE=$adc_offload_size\
DAC_OFFLOAD:TYPE=$dac_offload_type\
SIZE=$dac_offload_size"

sysid_gen_sys_init_file $sys_cstring

###############################################################################
## Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set dac_offload_type 0                   ; ## BRAM
set dac_offload_size [expr 2*1024*1024]  ; ## 2 MB

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
TX:M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
RX_OS:M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)\
DAC_OFFLOAD:TYPE=$dac_offload_type\
SIZE=$dac_offload_size"

sysid_gen_sys_init_file $sys_cstring

source ../common/fmcomms8_bd.tcl
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 300

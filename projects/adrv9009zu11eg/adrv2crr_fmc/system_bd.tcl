###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../common/adrv9009zu11eg_bd.tcl
source ../common/adrv2crr_fmc_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

source $ad_hdl_dir/library/corundum/scripts/corundum_adrv9009zu11eg_cfg.tcl
source $ad_hdl_dir/library/corundum/scripts/corundum.tcl
source system_bd_corundum.tcl

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
CORUNDUM=$ad_project_params(CORUNDUM)"

sysid_gen_sys_init_file $sys_cstring

sysid_gen_sys_init_file

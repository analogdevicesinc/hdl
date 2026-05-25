###############################################################################
## Copyright (C) 2014-2023, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/common/vcu118/vcu118_system_bd.tcl
source ../common/ad9083_evb_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/library/xilinx/scripts/xcvr_automation.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:L=$ad_project_params(RX_JESD_L)\
M=$ad_project_params(RX_JESD_M)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)"

sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter axi_ad9083_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 512

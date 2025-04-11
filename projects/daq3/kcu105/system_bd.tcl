###############################################################################
## Copyright (C) 2015-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 0                   ; ## BRAM
set adc_offload_size [expr 1*1024*1024]  ; ## 1 MB

set dac_offload_type 0                   ; ## BRAM
set dac_offload_size [expr 512*1024]     ; ## 512 kB

set plddr_offload_axi_data_width 0

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source ../common/daq3_bd.tcl
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
ADC_OFFLOAD:TYPE=$adc_offload_type\
SIZE=$adc_offload_size\
DAC_OFFLOAD:TYPE=$dac_offload_type\
SIZE=$dac_offload_size"

sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_daq3_xcvr CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG0 0x67f8
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG1 0xa4ac
ad_ip_parameter util_daq3_xcvr CONFIG.CPLL_CFG2 0x0007

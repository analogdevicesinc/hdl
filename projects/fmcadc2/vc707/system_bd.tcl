###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 16Mb - 1M samples
set adc_fifo_address_width 18

## NOTE: With this configuration the #36Kb BRAM utilization is at ~68%

source $ad_hdl_dir/projects/common/vc707/vc707_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
source ../common/fmcadc2_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "RX:M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
ADC_FIFO_ADDR_WIDTH=$adc_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring

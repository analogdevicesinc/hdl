###############################################################################
## Copyright (C) 2015-2023, 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set adc_offload_type 0                   ; ## BRAM
set adc_offload_size [expr 512*1024]     ; ## 512 kB

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

ad_ip_parameter axi_ad9680_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_ad9680_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_ad9680_dma CONFIG.MAX_BYTES_PER_BURST 4096

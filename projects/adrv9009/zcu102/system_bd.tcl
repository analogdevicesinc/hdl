###############################################################################
## Copyright (C) 2018-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_data_offload_type 0                   ; ## BRAM
set dac_data_offload_size [expr 2*1024*1024]  ; ## 2 MB
set dac_axi_data_width 256

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
DAC_OFFLOAD:TYPE=$dac_data_offload_type\
SIZE=$dac_data_offload_size"

sysid_gen_sys_init_file $sys_cstring

ad_mem_hp0_interconnect sys_cpu_clk sys_ps8/S_AXI_HP0

source ../common/adrv9009_bd.tcl

ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.FIFO_SIZE 32

ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL_REFCLK_DIV 1

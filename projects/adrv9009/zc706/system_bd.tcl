###############################################################################
## Copyright (C) 2016-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set dac_offload_type 1                      ; ## PL_DDR
set dac_offload_size [expr 1024*1024*1024]  ; ## 1 GB
set plddr_offload_axi_data_width 512

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_data_offload_bd.tcl
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

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 250

ad_ip_instance proc_sys_reset sys_250m_rstgen
ad_ip_parameter sys_250m_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect  sys_250m_clk sys_ps7/FCLK_CLK2
ad_connect  sys_250m_reset sys_250m_rstgen/peripheral_reset
ad_connect  sys_250m_resetn sys_250m_rstgen/peripheral_aresetn
ad_connect  sys_250m_clk sys_250m_rstgen/slowest_sync_clk
ad_connect  sys_250m_rstgen/ext_reset_in sys_ps7/FCLK_RESET2_N

set sys_dma_clk           [get_bd_nets sys_250m_clk]
set sys_dma_reset         [get_bd_nets sys_250m_reset]
set sys_dma_resetn        [get_bd_nets sys_250m_resetn]

source ../common/adrv9009_bd.tcl

ad_plddr_data_offload_create $dac_offload_name

ad_ip_parameter axi_adrv9009_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLK1_DIV 6

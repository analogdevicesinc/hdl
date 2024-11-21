###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set dac_offload_type 0                   ; ## BRAM
set dac_offload_size [expr 1024*1024]    ; ## 2 MB
set plddr_offload_axi_data_width 0

source $ad_hdl_dir/projects/common/kcu105/kcu105_system_bd.tcl
source $ad_hdl_dir/projects/common/kcu105/kcu105_system_mig.tcl
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

ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_ip_parameter axi_ddr_cntrl CONFIG.ADDN_UI_CLKOUT3_FREQ_HZ 200

source ../common/adrv9009_bd.tcl

ad_ip_parameter axi_adrv9009_tx_dma    CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9009_rx_dma    CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9009_rx_dma    CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma    CONFIG.FIFO_SIZE 32

ad_ip_parameter util_adrv9009_xcvr  CONFIG.QPLL_FBDIV 20
ad_ip_parameter util_adrv9009_xcvr  CONFIG.QPLL_REFCLK_DIV 1
ad_ip_parameter util_adrv9009_xcvr  CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_adrv9009_xcvr  CONFIG.RX_CLK25_DIV 20
ad_ip_parameter util_adrv9009_xcvr  CONFIG.TX_CLK25_DIV 20
ad_ip_parameter util_adrv9009_xcvr  CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_adrv9009_xcvr  CONFIG.CPLL_CFG0 0x67f8
ad_ip_parameter util_adrv9009_xcvr  CONFIG.CPLL_CFG1 0xa4ac
ad_ip_parameter util_adrv9009_xcvr  CONFIG.CPLL_CFG2 0x0007

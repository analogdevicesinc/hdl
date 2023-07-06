###############################################################################
## Copyright (C) 2018-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 18Mb - 1M samples
set dac_fifo_address_width 17

## NOTE: With this configuration the #36Kb BRAM utilization is at ~57%

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

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


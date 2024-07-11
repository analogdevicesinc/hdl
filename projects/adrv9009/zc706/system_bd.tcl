###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 10
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_dacfifo_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

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

ad_ip_parameter axi_adrv9009_rx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.FIFO_SIZE 32
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.MAX_BYTES_PER_BURST 4096
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.MAX_BYTES_PER_BURST 4096

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLK1_DIV 6

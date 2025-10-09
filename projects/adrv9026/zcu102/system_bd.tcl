###############################################################################
## Copyright (C) 2023-2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Offload attributes
set dac_offload_type 0                   ; ## BRAM
set dac_offload_size [expr 2*1024*1024]  ; ## 2 MB

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set sys_cstring "JESD_MODE=$ad_project_params(JESD_MODE)\
ORX_ENABLE=$ad_project_params(ORX_ENABLE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
NP=$ad_project_params(RX_JESD_NP)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
NP=$ad_project_params(TX_JESD_NP)\
LINKS=$ad_project_params(TX_NUM_LINKS)\
ORX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_OS_JESD_M)\
L=$ad_project_params(RX_OS_JESD_L)\
S=$ad_project_params(RX_OS_JESD_S)\
NP=$ad_project_params(RX_OS_JESD_NP)\
LINKS=$ad_project_params(RX_OS_NUM_LINKS)"

sysid_gen_sys_init_file $sys_cstring;

ad_ip_instance clk_wiz dma_clk_wiz
ad_ip_parameter dma_clk_wiz CONFIG.PRIMITIVE MMCM
ad_ip_parameter dma_clk_wiz CONFIG.RESET_TYPE ACTIVE_LOW
ad_ip_parameter dma_clk_wiz CONFIG.USE_LOCKED false
ad_ip_parameter dma_clk_wiz CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 333
ad_ip_parameter dma_clk_wiz CONFIG.PRIM_SOURCE No_buffer

ad_ip_instance proc_sys_reset sys_dma_rstgen
ad_ip_parameter sys_dma_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect sys_dma_clk dma_clk_wiz/clk_out1
ad_connect sys_dma_reset sys_dma_rstgen/peripheral_reset
ad_connect sys_dma_resetn sys_dma_rstgen/peripheral_aresetn

set sys_dma_clk           [get_bd_nets sys_dma_clk]
set sys_dma_reset         [get_bd_nets sys_dma_reset]
set sys_dma_resetn        [get_bd_nets sys_dma_resetn]

ad_connect $sys_cpu_clk dma_clk_wiz/clk_in1
ad_connect $sys_cpu_resetn dma_clk_wiz/resetn
ad_connect $sys_cpu_reset sys_dma_rstgen/ext_reset_in
ad_connect $sys_dma_clk sys_dma_rstgen/slowest_sync_clk

source ../common/adrv9026_bd.tcl

ad_ip_parameter axi_adrv9026_tx_dma    CONFIG.FIFO_SIZE 16
ad_ip_parameter axi_adrv9026_rx_dma    CONFIG.FIFO_SIZE 16
if {$ORX_ENABLE} {
  ad_ip_parameter axi_adrv9026_rx_os_dma CONFIG.FIFO_SIZE 16
}

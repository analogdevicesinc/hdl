###############################################################################
## Copyright (C) 2016-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

set dac_fifo_address_width 10

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_dacfifo_bd.tcl
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
DAC_FIFO_ADDR_WIDTH=$dac_fifo_address_width"

sysid_gen_sys_init_file $sys_cstring

ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 250

source ../common/adrv9009_bd.tcl

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLK1_DIV 6

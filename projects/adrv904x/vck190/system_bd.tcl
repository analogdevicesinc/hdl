###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## ADC FIFO depth in samples per converter
set adc_fifo_samples_per_converter [expr 32*1024]
## DAC FIFO depth in samples per converter
set dac_fifo_samples_per_converter [expr 32*1024]

set ADI_PHY_SEL 0

adi_project_files adrv904x_vck190 [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" ]

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source ../common/adrv904x_bd.tcl

#lane polarity

ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch0_txpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch1_txpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch2_txpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch3_txpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch0_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch1_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch2_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch3_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch4_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch5_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch6_rxpolarity_ext
ad_connect VCC ${rx_phy}/gt_bridge_ip_0/ch7_rxpolarity_ext

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set sys_cstring "$ad_project_params(JESD_MODE)\
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
LINKS=$ad_project_params(TX_NUM_LINKS)"

sysid_gen_sys_init_file $sys_cstring 10

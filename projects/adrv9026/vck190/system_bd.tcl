###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## FIFO depth is 18Mb - 1M samples
set dac_fifo_address_width 17

## NOTE: With this configuration the #36Kb BRAM utilization is at ~57%

set ADI_PHY_SEL 0
set TRANSCEIVER_TYPE GTY

source $ad_hdl_dir/projects/common/vck190/vck190_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

adi_project_files adrv9026_vck190 [list \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]

source ../common/adrv9026_bd.tcl

#lane polarity

ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch0_txpolarity_ext
ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch2_txpolarity_ext
ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch0_rxpolarity_ext
ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch1_rxpolarity_ext
ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch2_rxpolarity_ext
ad_connect VCC jesd204_phy_rxtx/gt_bridge_ip_0/ch3_rxpolarity_ext

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 10
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "$mem_init_sys_file_path/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 10

set sys_cstring "$ad_project_params(JESD_MODE)\
RX:RATE=$ad_project_params(RX_LANE_RATE)\
M=$ad_project_params(RX_JESD_M)\
L=$ad_project_params(RX_JESD_L)\
S=$ad_project_params(RX_JESD_S)\
LINKS=$ad_project_params(RX_NUM_LINKS)\
TX:RATE=$ad_project_params(TX_LANE_RATE)\
M=$ad_project_params(TX_JESD_M)\
L=$ad_project_params(TX_JESD_L)\
S=$ad_project_params(TX_JESD_S)\
LINKS=$ad_project_params(TX_NUM_LINKS)"

sysid_gen_sys_init_file $sys_cstring 10

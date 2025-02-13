###############################################################################
## Copyright (C) 2019-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make TX_JESD_L=4 RX_OS_JESD_M=8
#      make TX_JESD_M=8 TX_JESD_L=4 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2
#      make TX_JESD_M=4 TX_JESD_L=2 RX_JESD_M=8 RX_JESD_L=2 RX_OS_JESD_M=4 RX_OS_JESD_L=2

# Parameter description:
#   [TX/RX/RX_OS]_JESD_M : Number of converters per link
#   [TX/RX/RX_OS]_JESD_L : Number of lanes per link
#   [TX/RX/RX_OS]_JESD_S : Number of samples per frame
#   [TX/RX/RX_OS]_JESD_NP : Number of bits per sample
#

adi_project_create adrv9009zu11eg_qsfp 0 [list \
  RX_JESD_M       [get_env_param RX_JESD_M     8] \
  RX_JESD_L       [get_env_param RX_JESD_L     4] \
  RX_JESD_S       [get_env_param RX_JESD_S     1] \
  TX_JESD_M       [get_env_param TX_JESD_M     8] \
  TX_JESD_L       [get_env_param TX_JESD_L     8] \
  TX_JESD_S       [get_env_param TX_JESD_S     1] \
  RX_OS_JESD_M    [get_env_param RX_OS_JESD_M  4] \
  RX_OS_JESD_L    [get_env_param RX_OS_JESD_L  4] \
  RX_OS_JESD_S    [get_env_param RX_OS_JESD_S  1] \
] "xczu11eg-ffvf1517-2-i"

adi_project_files adrv9009zu11eg_qsfp [list \
  "../common/adrv9009zu11eg_spi.v" \
  "../common/adrv9009zu11eg_constr.xdc" \
  "../common/adrv2crr_fmc_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/eth_xcvr_phy_10g_gty_wrapper.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/rb_drp.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_rb_clk_info.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_ptp_clock.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/mqnic_port.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/ZCU102/fpga/lib/eth/syn/vivado/ptp_clock_cdc.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/ZCU102/fpga/lib/axis/syn/vivado/sync_reset.tcl" \
  "$ad_hdl_dir/../corundum/fpga/mqnic/ZCU102/fpga/lib/axis/syn/vivado/axis_async_fifo.tcl" \
  "$ad_hdl_dir/../corundum/fpga/common/syn/vivado/tdma_ber_ch.tcl" \
  "qsfp_constr.xdc" \
  "system_top.v" ]

adi_project_run adrv9009zu11eg_qsfp

###############################################################################
## Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204c_phy_adaptor_tx "ADI JESD204C PHY Adapter TX"
#set_module_property INTERNAL true

# parameters

ad_ip_parameter DEVICE STRING "Stratix 10" false


# files

ad_ip_files jesd204c_phy_adaptor_tx [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  jesd204c_phy_adaptor_tx.v \
]

# clock

add_interface phy_tx_clock clock end
add_interface_port phy_tx_clock o_clk clk Input 1

add_interface link_clock clock end
add_interface_port link_clock i_clk clk Input 1

# interfaces

add_interface link_tx conduit end
add_interface_port link_tx i_phy_data char Input 64
add_interface_port link_tx i_phy_header header Input 2
add_interface_port link_tx i_phy_charisk charisk Input 8

add_interface phy_tx_parallel_data conduit end
add_interface_port phy_tx_parallel_data o_phy_data tx_parallel_data Output 80

add_interface phy_tx_ready conduit end
add_interface_port phy_tx_ready o_phy_tx_ready tx_ready Input 1

###############################################################################
## Copyright (C) 2024-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204c_phy_adaptor_rx "ADI JESD204C PHY Adapter RX"
#set_module_property INTERNAL true

# parameters

ad_ip_parameter DEVICE STRING "Stratix 10" false


# files

ad_ip_files jesd204c_phy_adaptor_rx [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  $ad_hdl_dir/library/jesd204/jesd204_common/sync_header_align.v \
  jesd204c_phy_adaptor_rx.v \
]

# clock

add_interface phy_rx_clock clock end
add_interface_port phy_rx_clock i_clk clk Input 1

add_interface link_clock clock end
add_interface_port link_clock o_clk clk Input 1

# interfaces

add_interface link_rx conduit end
add_interface_port link_rx o_phy_data char Output 64
add_interface_port link_rx o_phy_header header Output 2
add_interface_port link_rx o_phy_block_sync block_sync Output 1
add_interface_port link_rx o_phy_charisk charisk Output 8
add_interface_port link_rx o_phy_disperr disperr Output 8
add_interface_port link_rx o_phy_notintable notintable Output 8
add_interface_port link_rx o_phy_patternalign_en patternalign_en Input 1

add_interface phy_rx_parallel_data conduit end
add_interface_port phy_rx_parallel_data i_phy_data rx_parallel_data Input 80

add_interface phy_rx_ready conduit end
add_interface_port phy_rx_ready i_phy_rx_ready rx_ready Input 1

add_interface phy_rx_bitsip conduit end
add_interface_port phy_rx_bitsip i_phy_bitslip rx_pmaif_bitslip Output 1

###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
################################################################################

package require qsys

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_f_tile_adapter_rx "ADI JESD204C F-Tile PHY Adapter RX"

# parameters

ad_ip_parameter DEVICE STRING "Agilex 7" false

# files

ad_ip_files jesd204_f_tile_adapter_rx [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/jesd204/jesd204_common/sync_header_align.v \
  bitslip.v \
  gearbox_64b66b.v \
  jesd204_f_tile_adapter_rx.v \
  jesd204_f_tile_adapter_rx_constr.sdc \
]

# clock

add_interface phy_rx_clock clock end
add_interface_port phy_rx_clock i_clk clk Input 1

add_interface link_clock clock end
add_interface_port link_clock o_clk clk Input 1

# interfaces

# adapter -> link layer

add_interface link_rx conduit end
add_interface_port link_rx o_phy_data char Output 64
add_interface_port link_rx o_phy_header header Output 2
add_interface_port link_rx o_phy_block_sync block_sync Output 1
add_interface_port link_rx o_phy_charisk charisk Output 8
add_interface_port link_rx o_phy_disperr disperr Output 8
add_interface_port link_rx o_phy_notintable notintable Output 8
add_interface_port link_rx o_phy_patternalign_en patternalign_en Input 1

# transceiver -> adapter
add_interface phy_rx_parallel_data conduit end
add_interface_port phy_rx_parallel_data i_phy_data raw_data Input 80

add_interface reset reset end
set_interface_property reset associatedClock link_clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset o_reset reset Input 1

# adapter -> cdc fifo

add_interface fifo_input conduit end
add_interface_port fifo_input wr_clk  wrclk  Output 1
add_interface_port fifo_input wr_en   wrreq  Output 1
add_interface_port fifo_input wr_data datain Output 66
add_interface_port fifo_input rd_clk  rdclk  Output 1
add_interface_port fifo_input rd_en   rdreq  Output 1
add_interface_port fifo_input aclr    aclr   Output 1

# cdc fifo -> adapter

add_interface fifo_output conduit end
add_interface_port fifo_output rd_data  dataout Input 66
add_interface_port fifo_output rd_empty rdempty Input 1
add_interface_port fifo_output wr_full  wrfull  Input 1

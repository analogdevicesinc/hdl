###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

package require qsys

source ../../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204_h_tile_adapter_tx "ADI JESD204C H-Tile PHY Adapter TX"

# parameters

ad_ip_parameter DEVICE STRING "Stratix 10" false

# files

ad_ip_files jesd204_h_tile_adapter_tx [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  jesd204_h_tile_adapter_tx.v \
  jesd204_h_tile_adapter_tx_constr.sdc \
]

# clock

add_interface phy_tx_clock clock end
add_interface_port phy_tx_clock o_clk clk Input 1

add_interface link_clock clock end
add_interface_port link_clock i_clk clk Input 1

# interfaces

# link layer -> adapter
add_interface link_tx conduit end
add_interface_port link_tx i_phy_data char Input 64
add_interface_port link_tx i_phy_header header Input 2
add_interface_port link_tx i_phy_charisk charisk Input 8

add_interface reset reset end
set_interface_property reset associatedClock link_clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset i_reset reset Input 1

# adapter -> transceiver
add_interface phy_tx_parallel_data conduit end
add_interface_port phy_tx_parallel_data o_phy_data raw_data Output 64

add_interface phy_tx_control conduit end
add_interface_port phy_tx_control o_phy_control tx_control Output 2

add_interface phy_tx_enh_data_valid conduit end
add_interface_port phy_tx_enh_data_valid o_phy_data_valid tx_enh_data_valid Output 1

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
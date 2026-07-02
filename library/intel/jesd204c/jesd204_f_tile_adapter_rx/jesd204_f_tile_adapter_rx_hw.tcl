###############################################################################
## Copyright (C) 2024, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIJESD204
##
## The ADI JESD204 Core is released under the following license, which is
## different than all other HDL cores in this repository.
##
## Please read this, and understand the freedoms and responsibilities you have by
## using this source code/core.
##
## The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
##
## This core is free software, you can use run, copy, study, change, ask questions
## about and improve this core. Distribution of source, or resulting binaries
## (including those inside an FPGA or ASIC) require you to release the source of
## the entire project (excluding the system libraries provide by the
## tools/compiler/FPGA vendor). These are the terms of the GNU General Public
## License version 2 as published by the Free Software Foundation.
##
## This core  is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
## PARTICULAR PURPOSE. See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License version 2
## along with this source code, and binary. If not, see
## <http://www.gnu.org/licenses/>.
##
## Commercial licenses (with commercial support) of this JESD204 core are also
## available under terms different than the General Public License (e.g. they do
## not require you to accompany any image (FPGA or ASIC) using the JESD204 core
## with any corresponding source code). For these alternate terms you must
## purchase a license from Analog Devices Technology Licensing Office. Users
## interested in such a license should contact jesd204-licensing@analog.com for
## more information. This commercial license is sub-licensable (if you purchase
## chips from Analog Devices, incorporate them into your PCB level product, and
## purchase a JESD204 license, end users of your product will also have a license
## to use this core in a commercial setting without releasing their source code).
##
## In addition, we kindly ask you to acknowledge ADI in any program, application
## or publication in which you use this JESD204 HDL core. (You are not required to
## do so; it is up to your common sense to decide whether you want to comply with
## this request or not.) For general publications, we suggest referencing: "The
## design and implementation of the JESD204 HDL Core used in this project is
## copyright (C) 2016-2026, Analog Devices, Inc."
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
  $ad_hdl_dir/library/jesd204/jesd204_common/bitslip.v \
  $ad_hdl_dir/library/jesd204/jesd204_common/gearbox_64b66b.v \
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

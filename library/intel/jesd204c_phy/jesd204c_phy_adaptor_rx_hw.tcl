#
# The ADI JESD204 Core is released under the following license, which is
# different than all other HDL cores in this repository.
#
# Please read this, and understand the freedoms and responsibilities you have
# by using this source code/core.
#
# The JESD204 HDL, is copyright © 2016-2017 Analog Devices Inc.
#
# This core is free software, you can use run, copy, study, change, ask
# questions about and improve this core. Distribution of source, or resulting
# binaries (including those inside an FPGA or ASIC) require you to release the
# source of the entire project (excluding the system libraries provide by the
# tools/compiler/FPGA vendor). These are the terms of the GNU General Public
# License version 2 as published by the Free Software Foundation.
#
# This core  is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License version 2
# along with this source code, and binary.  If not, see
# <http://www.gnu.org/licenses/>.
#
# Commercial licenses (with commercial support) of this JESD204 core are also
# available under terms different than the General Public License. (e.g. they
# do not require you to accompany any image (FPGA or ASIC) using the JESD204
# core with any corresponding source code.) For these alternate terms you must
# purchase a license from Analog Devices Technology Licensing Office. Users
# interested in such a license should contact jesd204-licensing@analog.com for
# more information. This commercial license is sub-licensable (if you purchase
# chips from Analog Devices, incorporate them into your PCB level product, and
# purchase a JESD204 license, end users of your product will also have a
# license to use this core in a commercial setting without releasing their
# source code).
#
# In addition, we kindly ask you to acknowledge ADI in any program, application
# or publication in which you use this JESD204 HDL core. (You are not required
# to do so; it is up to your common sense to decide whether you want to comply
# with this request or not.) For general publications, we suggest referencing :
# “The design and implementation of the JESD204 HDL Core used in this project
# is copyright © 2016-2017, Analog Devices, Inc.”
#

package require qsys

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_intel.tcl

ad_ip_create jesd204c_phy_adaptor_rx "ADI JESD204C PHY Adapter RX"
#set_module_property INTERNAL true

# parameters

ad_ip_parameter DEVICE STRING "Stratix 10" false


# files

ad_ip_files jesd204c_phy_adaptor_rx [list \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/common/ad_mem.v \
  jesd204c_phy_adaptor_rx.v \
  sync_header_align.v \
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
add_interface_port link_rx o_phy_charisk charisk Output 4
add_interface_port link_rx o_phy_disperr disperr Output 4
add_interface_port link_rx o_phy_notintable notintable Output 4
add_interface_port link_rx o_phy_patternalign_en patternalign_en Input 1

add_interface phy_rx_parallel_data conduit end
add_interface_port phy_rx_parallel_data i_phy_data rx_parallel_data Input 80

add_interface phy_rx_ready conduit end
add_interface_port phy_rx_ready i_phy_rx_ready rx_ready Input 1

add_interface phy_rx_bitsip conduit end
add_interface_port phy_rx_bitsip i_phy_bitslip rx_pmaif_bitslip Output 1



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
source ../../scripts/adi_ip_intel.tcl

ad_ip_create adi_jesd204_link_merge {JESD204 Link Merge} jesd204_link_merge_elaboration_callback
set_module_property INTERNAL false

# source files

ad_ip_files adi_jesd204_link_merge [list \
  adi_jesd204_link_merge.v \
]

# parameters

ad_ip_parameter NUM_OF_LANES_PER_LINK INTEGER 1 false

##################### Interface definitions ###################################
#
# clock

add_interface clk clock end
add_interface_port clk clk clk Input 1

add_interface rst reset end
add_interface_port rst reset reset Input 1
set_interface_property rst associatedClock clk

# ch0_sof interface

add_interface rx0_sof conduit end
add_interface_port rx0_sof rx0_sof_in export Input 4

# ch1_sof interface

add_interface rx1_sof conduit end
add_interface_port rx1_sof rx1_sof_in export Input 4

# merged sof interface

add_interface rx_sof conduit end
add_interface_port rx_sof rx_sof_out export Output 4

proc jesd204_link_merge_elaboration_callback {} {

  set num_lanes [get_parameter_value "NUM_OF_LANES_PER_LINK"]

  # channel0 data interface

  add_interface rx0_data avalon_streaming sink
  set_interface_property rx0_data associatedClock clk
  set_interface_property rx0_data associatedReset rst

  add_interface_port rx0_data rx0_data_in data input [expr 32*$num_lanes]
  add_interface_port rx0_data rx0_valid_in valid input 1
  set_interface_property rx0_data dataBitsPerSymbol [expr 32*$num_lanes]

  # channel1 data interface

  add_interface rx1_data avalon_streaming sink
  set_interface_property rx1_data associatedClock clk
  set_interface_property rx1_data associatedReset rst

  add_interface_port rx1_data rx1_data_in data input [expr 32*$num_lanes]
  add_interface_port rx1_data rx1_valid_in valid input 1
  set_interface_property rx1_data dataBitsPerSymbol [expr 32*$num_lanes]

  # merged data interface

  add_interface rx_data avalon_streaming source
  set_interface_property rx_data associatedClock clk
  set_interface_property rx_data associatedReset rst

  add_interface_port rx_data rx_data_out data output [expr 32*2*$num_lanes]
  add_interface_port rx_data rx_valid_out valid output 1
  set_interface_property rx_data dataBitsPerSymbol [expr 32*2*$num_lanes]

}

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

ad_ip_create jesd204_tx "ADI JESD204 Transmit" jesd204_tx_elaboration_callback

set_module_property INTERNAL true

# files

ad_ip_files jesd204_tx [list \
  jesd204_tx.v \
  jesd204_tx_ctrl.v \
  jesd204_tx_lane.v \
  jesd204_tx_constr.sdc \
  ../jesd204_common/jesd204_eof_generator.v \
  ../jesd204_common/jesd204_lmfc.v \
  ../jesd204_common/jesd204_scrambler.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  $ad_hdl_dir/library/util_cdc/util_cdc_constr.tcl \
]

# parameters

add_parameter NUM_LANES INTEGER 1
set_parameter_property NUM_LANES DISPLAY_NAME "Number of Lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES 1:8
set_parameter_property NUM_LANES HDL_PARAMETER true

add_parameter NUM_LINKS INTEGER 1
set_parameter_property NUM_LINKS DISPLAY_NAME "Number of Links"
set_parameter_property NUM_LINKS ALLOWED_RANGES 1:8
set_parameter_property NUM_LINKS HDL_PARAMETER true

# clock

add_interface clock clock end
add_interface_port clock clk clk Input 1

# reset

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset reset reset Input 1

# SYSREF~ interface

add_interface sysref conduit end
set_interface_property sysref associatedClock clock
set_interface_property sysref associatedReset reset
add_interface_port sysref sysref export Input 1

# SYNC interface

add_interface sync conduit end
set_interface_property sync associatedClock clock
set_interface_property sync associatedReset reset
add_interface_port sync sync export Input 1

# ilas_config interface

add_interface ilas_config conduit end
set_interface_property ilas_config associatedClock clock
set_interface_property ilas_config associatedReset reset

add_interface_port ilas_config ilas_config_addr addr Output 2
add_interface_port ilas_config ilas_config_data data Input 32*NUM_LANES
add_interface_port ilas_config ilas_config_rd rd Output 1

# event interface

add_interface event conduit end
set_interface_property event associatedClock clock
set_interface_property event associatedReset reset

add_interface_port event event_sysref_alignment_error sysref_alignment_error Output 1
add_interface_port event event_sysref_edge sysref_edge Output 1

# control interface

add_interface control conduit end
set_interface_property control associatedClock clock
set_interface_property control associatedReset reset

add_interface_port control ctrl_manual_sync_request manual_sync_request Input 1

# config interface

add_interface config conduit end
set_interface_property config associatedClock clock
set_interface_property config associatedReset reset

add_interface_port config cfg_beats_per_multiframe beats_per_multiframe Input 8
add_interface_port config cfg_continuous_cgs continuous_cgs Input 1
add_interface_port config cfg_continuous_ilas continuous_ilas Input 1
add_interface_port config cfg_disable_char_replacement disable_char_replacement Input 1
add_interface_port config cfg_disable_scrambler disable_scrambler Input 1
add_interface_port config cfg_lanes_disable lanes_disable Input NUM_LANES
add_interface_port config cfg_links_disable links_disable Input NUM_LINKS
add_interface_port config cfg_lmfc_offset lmfc_offset Input 8
add_interface_port config cfg_mframes_per_ilas mframes_per_ilas Input 8
add_interface_port config cfg_octets_per_frame octets_per_frame Input 8
add_interface_port config cfg_skip_ilas skip_ilas Input 1
add_interface_port config cfg_sysref_disable sysref_disable Input 1
add_interface_port config cfg_sysref_oneshot sysref_oneshot Input 1

# status interface

add_interface status conduit end
set_interface_property status associatedClock clock
set_interface_property status associatedReset reset

add_interface_port status status_state state Output 2
add_interface_port status status_sync sync Output 1

# lmfc_clk interface

add_interface lmfc_clk conduit end
#set_interface_property lmfc_clk associatedClock clock
#set_interface_property lmfc_clk associatedReset reset
add_interface_port lmfc_clk lmfc_clk export Output 1
set_port_property lmfc_clk TERMINATION TRUE

# lmfc_edge interface

add_interface lmfc_edge conduit end
#set_interface_property lmfc_edge associatedClock clock
#set_interface_property lmfc_edge associatedReset reset
add_interface_port lmfc_edge lmfc_edge export Output 1
set_port_property lmfc_edge TERMINATION TRUE

proc jesd204_tx_elaboration_callback {} {
  set num_lanes [get_parameter_value "NUM_LANES"]

  # tx_data interface

  add_interface tx_data avalon_streaming sink
  set_interface_property tx_data associatedClock clock

  add_interface_port tx_data tx_data data input [expr 32*$num_lanes]
  add_interface_port tx_data tx_ready ready output 1
  add_interface_port tx_data tx_valid valid input 1
  set_interface_property tx_data dataBitsPerSymbol [expr 32*$num_lanes]

  # phy interfaces

  for {set i 0 } {$i < $num_lanes} {incr i} {
    add_interface tx_phy${i} conduit start
#    set_interface_property tx_phy${i} associatedClock clock
#    set_interface_property tx_phy${i} associatedReset reset
    add_interface_port tx_phy${i} tx_phy${i}_data char Output 32
    set_port_property tx_phy${i}_data fragment_list \
      [format "phy_data(%d:%d)" [expr 32*$i+31] [expr 32*$i]]
    add_interface_port tx_phy${i} tx_phy${i}_charisk charisk Output 4
    set_port_property tx_phy${i}_charisk fragment_list \
      [format "phy_charisk(%d:%d)" [expr 4*$i+3] [expr 4*$i]]
  }
}

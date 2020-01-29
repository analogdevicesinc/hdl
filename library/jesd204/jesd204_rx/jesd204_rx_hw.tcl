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

ad_ip_create jesd204_rx "ADI JESD204 Receive" jesd204_rx_elaboration_callback

set_module_property INTERNAL true

# files

ad_ip_files jesd204_rx [list \
  jesd204_rx.v \
  align_mux.v \
  elastic_buffer.v \
  jesd204_ilas_monitor.v \
  jesd204_lane_latency_monitor.v \
  jesd204_rx_cgs.v \
  jesd204_rx_ctrl.v \
  jesd204_rx_lane.v \
  jesd204_rx_frame_mark.v \
  jesd204_rx_frame_align_monitor.v \
  jesd204_rx_constr.sdc \
  ../jesd204_common/jesd204_eof_generator.v \
  ../jesd204_common/jesd204_lmfc.v \
  ../jesd204_common/jesd204_scrambler.v \
  ../jesd204_common/pipeline_stage.v \
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

add_parameter NUM_INPUT_PIPELINE INTEGER 1
set_parameter_property NUM_INPUT_PIPELINE DISPLAY_NAME "Number of input pipeline stages"
set_parameter_property NUM_INPUT_PIPELINE ALLOWED_RANGES 1:3
set_parameter_property NUM_INPUT_PIPELINE HDL_PARAMETER true

#ad_ip_parameter PORT_ENABLE_RX_EOF BOOLEAN false false
#ad_ip_parameter PORT_ENABLE_LMFC_CLK BOOLEAN false false
#ad_ip_parameter PORT_ENABLE_LMFC_EDGE BOOLEAN false false

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
add_interface_port sync sync export Output NUM_LINKS

# config interface

add_interface config conduit end
set_interface_property config associatedClock clock
set_interface_property config associatedReset reset

add_interface_port config cfg_beats_per_multiframe beats_per_multiframe Input 8
add_interface_port config cfg_buffer_delay buffer_delay Input 8
add_interface_port config cfg_buffer_early_release buffer_early_release Input 1
add_interface_port config cfg_disable_char_replacement disable_char_replacement Input 1
add_interface_port config cfg_disable_scrambler disable_scrambler Input 1
add_interface_port config cfg_lanes_disable lanes_disable Input NUM_LANES
add_interface_port config cfg_links_disable links_disable Input NUM_LINKS
add_interface_port config cfg_lmfc_offset lmfc_offset Input 8
add_interface_port config cfg_octets_per_frame octets_per_frame Input 8
add_interface_port config cfg_sysref_disable sysref_disable Input 1
add_interface_port config cfg_sysref_oneshot sysref_oneshot Input 1
add_interface_port config cfg_frame_align_err_threshold frame_align_err_threshold Input 8
add_interface_port config ctrl_err_statistics_reset err_statistics_reset Input 1
add_interface_port config ctrl_err_statistics_mask err_statistics_mask Input 3

# status interface

add_interface status conduit end
set_interface_property status associatedClock clock
set_interface_property status associatedReset reset

add_interface_port status status_ctrl_state ctrl_state Output 2
add_interface_port status status_lane_cgs_state lane_cgs_state Output 2*NUM_LANES
add_interface_port status status_lane_ifs_ready lane_ifs_ready Output NUM_LANES
add_interface_port status status_lane_latency lane_latency Output 14*NUM_LANES
add_interface_port status status_err_statistics_cnt err_statistics_cnt Output 32*NUM_LANES
add_interface_port status status_lane_frame_align_err_cnt lane_frame_align_err_cnt Output 8*NUM_LANES

# event interface

add_interface event conduit end
set_interface_property event associatedClock clock
set_interface_property event associatedReset reset

add_interface_port event event_sysref_alignment_error sysref_alignment_error Output 1
add_interface_port event event_sysref_edge sysref_edge Output 1

# ilas_config interface

add_interface ilas_config conduit end
set_interface_property ilas_config associatedClock clock
set_interface_property ilas_config associatedReset reset

add_interface_port ilas_config ilas_config_addr addr Output NUM_LANES*2
add_interface_port ilas_config ilas_config_data data Output NUM_LANES*32
add_interface_port ilas_config ilas_config_valid valid Output NUM_LANES

# rx_eof interface

add_interface rx_eof conduit end
#set_interface_property rx_eof associatedClock clock
#set_interface_property rx_eof associatedReset reset
add_interface_port rx_eof rx_eof export Output 4
set_port_property rx_eof TERMINATION TRUE

# rx_sof interface

add_interface rx_sof conduit end
#set_interface_property rx_sof associatedClock clock
#set_interface_property rx_sof associatedReset reset
add_interface_port rx_sof rx_sof export Output 4

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

proc jesd204_rx_elaboration_callback {} {
  set num_lanes [get_parameter_value "NUM_LANES"]

  # rx_data interface

  add_interface rx_data avalon_streaming source
  set_interface_property rx_data associatedClock clock

  add_interface_port rx_data rx_data data output [expr 32*$num_lanes]
  add_interface_port rx_data rx_valid valid output 1
  set_interface_property rx_data dataBitsPerSymbol [expr 32*$num_lanes]

  # phy interfaces

  for {set i 0 } {$i < $num_lanes} {incr i} {
    add_interface rx_phy${i} conduit end
#    set_interface_property rx_phy${i} associatedClock clock
#    set_interface_property rx_phy${i} associatedReset reset
    add_interface_port rx_phy${i} rx_phy${i}_data char Input 32
    set_port_property rx_phy${i}_data fragment_list \
      [format "phy_data(%d:%d)" [expr 32*$i+31] [expr 32*$i]]
    add_interface_port rx_phy${i} rx_phy${i}_charisk charisk Input 4
    set_port_property rx_phy${i}_charisk fragment_list \
      [format "phy_charisk(%d:%d)" [expr 4*$i+3] [expr 4*$i]]
    add_interface_port rx_phy${i} rx_phy${i}_disperr disperr Input 4
    set_port_property rx_phy${i}_disperr fragment_list \
      [format "phy_disperr(%d:%d)" [expr 4*$i+3] [expr 4*$i]]
    add_interface_port rx_phy${i} rx_phy${i}_notintable notintable Input 4
    set_port_property rx_phy${i}_notintable fragment_list \
      [format "phy_notintable(%d:%d)" [expr 4*$i+3] [expr 4*$i]]
    add_interface_port rx_phy${i} rx_phy${i}_patternalign_en patternalign_en Output 1
    set_port_property rx_phy${i}_patternalign_en fragment_list "phy_en_char_align"
  }
}

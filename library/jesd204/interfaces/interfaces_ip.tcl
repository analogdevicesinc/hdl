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

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

# TX interfaces

adi_if_define "jesd204_tx_cfg"
adi_if_ports output -1 lanes_disable
adi_if_ports output -1 links_disable
adi_if_ports output 8 beats_per_multiframe
adi_if_ports output 8 octets_per_frame
adi_if_ports output 8 lmfc_offset
adi_if_ports output 1 continuous_cgs
adi_if_ports output 1 continuous_ilas
adi_if_ports output 1 skip_ilas
adi_if_ports output 8 mframes_per_ilas
adi_if_ports output 1 disable_char_replacement
adi_if_ports output 1 disable_scrambler

adi_if_define "jesd204_tx_ilas_config"
adi_if_ports output 1 rd
adi_if_ports output 2 addr
adi_if_ports input 32 data

adi_if_define "jesd204_tx_status"
adi_if_ports output 1 state
adi_if_ports output 1 sync

adi_if_define "jesd204_tx_event"
adi_if_ports output 1 sysref_alignment_error
adi_if_ports output 1 sysref_edge

adi_if_define "jesd204_tx_ctrl"
adi_if_ports output 1 manual_sync_request

# RX interfaces

adi_if_define "jesd204_rx_cfg"
adi_if_ports output -1 lanes_disable
adi_if_ports output -1 links_disable
adi_if_ports output 8 beats_per_multiframe
adi_if_ports output 8 octets_per_frame
adi_if_ports output 8 lmfc_offset
adi_if_ports output 1 buffer_early_release
adi_if_ports output 1 buffer_delay
adi_if_ports output 1 disable_char_replacement
adi_if_ports output 1 disable_scrambler
adi_if_ports output 1 err_statistics_reset
adi_if_ports output 7 err_statistics_mask

adi_if_define "jesd204_rx_status"
adi_if_ports output 3 ctrl_state
adi_if_ports output -1 lane_cgs_state
adi_if_ports output -1 lane_emb_state
adi_if_ports output -1 lane_frame_align
adi_if_ports output -1 lane_ifs_ready
adi_if_ports output -1 lane_latency_ready
adi_if_ports output -1 lane_latency
adi_if_ports output -1 err_statistics_cnt

adi_if_define "jesd204_rx_ilas_config"
adi_if_ports output -1 valid
adi_if_ports output -1 addr
adi_if_ports input -1 data

adi_if_define "jesd204_rx_event"
adi_if_ports output 1 sysref_alignment_error
adi_if_ports output 1 sysref_edge

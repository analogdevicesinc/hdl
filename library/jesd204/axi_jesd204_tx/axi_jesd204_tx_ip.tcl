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

adi_ip_create axi_jesd204_tx
adi_ip_files axi_jesd204_tx [list \
  "../../common/up_axi.v" \
  "axi_jesd204_tx_constr.xdc" \
  "axi_jesd204_tx_ooc.ttcl" \
  "jesd204_up_tx.v" \
  "axi_jesd204_tx.v" \
]

adi_ip_properties axi_jesd204_tx

adi_ip_ttcl axi_jesd204_tx "axi_jesd204_tx_ooc.ttcl"

set_property PROCESSING_ORDER LATE [ipx::get_files axi_jesd204_tx_constr.xdc \
  -of_objects [ipx::get_file_groups -of_objects [ipx::current_core] \
  -filter {NAME =~ *synthesis*}]]

adi_ip_add_core_dependencies { \
  analog.com:user:axi_jesd204_common:1.0 \
}

set_property display_name "ADI JESD204B Transmit AXI Interface" [ipx::current_core]
set_property description "ADI JESD204B Transmit AXI Interface" [ipx::current_core]

adi_add_bus "tx_cfg" "master" \
  "analog.com:interface:jesd204_tx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_tx_cfg:1.0" \
  { \
    { "core_cfg_lanes_disable" "lanes_disable" } \
    { "core_cfg_links_disable" "links_disable" } \
    { "core_cfg_beats_per_multiframe" "beats_per_multiframe" } \
    { "core_cfg_octets_per_frame" "octets_per_frame" } \
    { "core_cfg_lmfc_offset" "lmfc_offset" } \
    { "core_cfg_sysref_oneshot" "sysref_oneshot" } \
    { "core_cfg_sysref_disable" "sysref_disable" } \
    { "core_cfg_continuous_cgs" "continuous_cgs" } \
    { "core_cfg_continuous_ilas" "continuous_ilas" } \
    { "core_cfg_skip_ilas" "skip_ilas" } \
    { "core_cfg_mframes_per_ilas" "mframes_per_ilas" } \
    { "core_cfg_disable_char_replacement" "disable_char_replacement" } \
    { "core_cfg_disable_scrambler" "disable_scrambler" } \
  }

adi_add_bus "tx_ilas_config" "slave" \
  "analog.com:interface:jesd204_tx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ilas_config:1.0" \
  { \
    { "core_ilas_config_rd" "rd" } \
    { "core_ilas_config_addr" "addr" } \
    { "core_ilas_config_data" "data" } \
  }

adi_add_bus "tx_event" "slave" \
  "analog.com:interface:jesd204_tx_event_rtl:1.0" \
  "analog.com:interface:jesd204_tx_event:1.0" \
  { \
    { "core_event_sysref_alignment_error" "sysref_alignment_error" } \
    { "core_event_sysref_edge" "sysref_edge" } \
  }

adi_add_bus "tx_status" "slave" \
  "analog.com:interface:jesd204_tx_status_rtl:1.0" \
  "analog.com:interface:jesd204_tx_status:1.0" \
  { \
    { "core_status_state" "state" } \
    { "core_status_sync" "sync" } \
  }

adi_add_bus "tx_ctrl" "master" \
  "analog.com:interface:jesd204_tx_ctrl_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ctrl:1.0" \
  { \
    { "core_ctrl_manual_sync_request" "manual_sync_request" } \
  }

ipx::infer_bus_interface irq xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]

adi_add_bus_clock "core_clk" "tx_status:tx_event:tx_ilas_config:tx_cfg:tx_ctrl" \
  "core_reset" "master"

set_property DRIVER_VALUE "0" [ipx::get_ports "core_reset_ext"]

ipx::save_core [ipx::current_core]

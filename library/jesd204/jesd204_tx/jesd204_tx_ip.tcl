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

adi_ip_create jesd204_tx
adi_ip_files jesd204_tx [list \
  "jesd204_tx_lane.v" \
  "jesd204_tx_ctrl.v" \
  "jesd204_tx_constr.ttcl" \
  "jesd204_tx.v"
]

adi_ip_properties_lite jesd204_tx
adi_ip_ttcl jesd204_tx "jesd204_tx_constr.ttcl"

adi_ip_add_core_dependencies { \
  analog.com:user:jesd204_common:1.0 \
  analog.com:user:util_cdc:1.0 \
}

set_property display_name "ADI JESD204 Transmit" [ipx::current_core]
set_property description "ADI JESD204 Transmit" [ipx::current_core]

adi_add_bus "tx_data" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  { \
    { "tx_valid" "TVALID" } \
    { "tx_ready" "TREADY" } \
    { "tx_data" "TDATA" } \
  }

adi_add_multi_bus 16 "tx_phy" "master" \
  "xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_tx_bus:1.0" \
  [list \
    {"phy_data" "txdata" 32} \
    { "phy_charisk" "txcharisk" 4} \
  ] \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_LANES')) > {i})"

adi_add_bus "tx_cfg" "slave" \
  "analog.com:interface:jesd204_tx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_tx_cfg:1.0" \
  { \
    { "cfg_lanes_disable" "lanes_disable" } \
    { "cfg_links_disable" "links_disable" } \
    { "cfg_beats_per_multiframe" "beats_per_multiframe" } \
    { "cfg_octets_per_frame" "octets_per_frame" } \
    { "cfg_lmfc_offset" "lmfc_offset" } \
    { "cfg_sysref_oneshot" "sysref_oneshot" } \
    { "cfg_sysref_disable" "sysref_disable" } \
    { "cfg_continuous_cgs" "continuous_cgs" } \
    { "cfg_continuous_ilas" "continuous_ilas" } \
    { "cfg_skip_ilas" "skip_ilas" } \
    { "cfg_mframes_per_ilas" "mframes_per_ilas" } \
    { "cfg_disable_char_replacement" "disable_char_replacement" } \
    { "cfg_disable_scrambler" "disable_scrambler" } \
  }

adi_add_bus "tx_ilas_config" "master" \
  "analog.com:interface:jesd204_tx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ilas_config:1.0" \
  { \
    { "ilas_config_rd" "rd" } \
    { "ilas_config_addr" "addr" } \
    { "ilas_config_data" "data" } \
  }

adi_add_bus "tx_event" "master" \
  "analog.com:interface:jesd204_tx_event_rtl:1.0" \
  "analog.com:interface:jesd204_tx_event:1.0" \
  { \
    { "event_sysref_alignment_error" "sysref_alignment_error" } \
    { "event_sysref_edge" "sysref_edge" } \
  }

adi_add_bus "tx_status" "master" \
  "analog.com:interface:jesd204_tx_status_rtl:1.0" \
  "analog.com:interface:jesd204_tx_status:1.0" \
  { \
    { "status_state" "state" } \
    { "status_sync" "sync" } \
  }

adi_add_bus "tx_ctrl" "slave" \
  "analog.com:interface:jesd204_tx_ctrl_rtl:1.0" \
  "analog.com:interface:jesd204_tx_ctrl:1.0" \
  { \
    { "ctrl_manual_sync_request" "manual_sync_request" } \
  }

adi_add_bus_clock "clk" "tx_data:tx_cfg:tx_ilas_config:tx_event:tx_status:tx_ctrl" \
  "reset"

set cc [ipx::current_core]
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

set param [ipx::add_user_parameter SYSREF_IOB $cc]
set_property -dict {value_resolve_type user value_format bool value true} $param

set param [ipgui::add_param -name {SYSREF_IOB} -component $cc -parent $page0]
set_property -dict [list \
  display_name {Place SYSREF in IOB} \
  widget {checkBox} \
  show_label true \
] $param

ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]

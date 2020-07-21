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

adi_ip_create jesd204_rx
adi_ip_files jesd204_rx [list \
  "jesd204_rx_lane.v" \
  "jesd204_rx_lane_64b.v" \
  "jesd204_rx_header.v" \
  "jesd204_rx_cgs.v" \
  "jesd204_rx_ctrl.v" \
  "jesd204_rx_ctrl_64b.v" \
  "elastic_buffer.v" \
  "error_monitor.v" \
  "jesd204_ilas_monitor.v" \
  "align_mux.v" \
  "jesd204_lane_latency_monitor.v" \
  "jesd204_rx_frame_mark.v" \
  "jesd204_rx_frame_align_monitor.v" \
  "jesd204_rx_constr.ttcl" \
  "jesd204_rx.v" \
]

adi_ip_properties_lite jesd204_rx
adi_ip_ttcl jesd204_rx "jesd204_rx_constr.ttcl"

adi_ip_add_core_dependencies { \
  analog.com:user:jesd204_common:1.0 \
}

set_property display_name "ADI JESD204 Receive" [ipx::current_core]
set_property description "ADI JESD204 Receive" [ipx::current_core]

#adi_add_bus "rx_data" "master" \
#  "xilinx.com:interface:axis_rtl:1.0" \
#  "xilinx.com:interface:axis:1.0" \
#  { \
#    { "rx_valid" "TVALID" } \
#    { "rx_data" "TDATA" } \
#  }

adi_add_multi_bus 16 "rx_phy" "slave" \
  "xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_rx_bus:1.0" \
  [list \
    { "phy_data" "rxdata" 32 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')) * 8)"} \
    { "phy_charisk" "rxcharisk" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_disperr" "rxdisperr" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_notintable" "rxnotintable" 4 "(spirit:decode(id('MODELPARAM_VALUE.DATA_PATH_WIDTH')))"} \
    { "phy_header" "rxheader" 2} \
    { "phy_block_sync" "rxblock_sync" 1} \
  ] \
  "(spirit:decode(id('MODELPARAM_VALUE.NUM_LANES')) > {i})"

adi_add_bus "rx_cfg" "slave" \
  "analog.com:interface:jesd204_rx_cfg_rtl:1.0" \
  "analog.com:interface:jesd204_rx_cfg:1.0" \
  { \
    { "cfg_lanes_disable" "lanes_disable" } \
    { "cfg_links_disable" "links_disable" } \
    { "cfg_beats_per_multiframe" "beats_per_multiframe" } \
    { "cfg_octets_per_frame" "octets_per_frame" } \
    { "cfg_lmfc_offset" "lmfc_offset" } \
    { "cfg_sysref_oneshot" "sysref_oneshot" } \
    { "cfg_sysref_disable" "sysref_disable" } \
    { "cfg_buffer_delay" "buffer_delay" } \
    { "cfg_buffer_early_release" "buffer_early_release" } \
    { "cfg_disable_char_replacement" "disable_char_replacement" } \
    { "ctrl_err_statistics_reset" "err_statistics_reset" } \
    { "ctrl_err_statistics_mask" "err_statistics_mask" } \
    { "cfg_disable_scrambler" "disable_scrambler" } \
    { "cfg_frame_align_err_threshold" "frame_align_err_threshold" } \
  }

adi_add_bus "rx_status" "master" \
  "analog.com:interface:jesd204_rx_status_rtl:1.0" \
  "analog.com:interface:jesd204_rx_status:1.0" \
  { \
    { "status_ctrl_state" "ctrl_state" } \
    { "status_lane_cgs_state" "lane_cgs_state" } \
    { "status_lane_emb_state" "lane_emb_state" } \
    { "status_err_statistics_cnt" "err_statistics_cnt" } \
    { "status_lane_ifs_ready" "lane_ifs_ready" } \
    { "status_lane_latency" "lane_latency" } \
    { "status_lane_frame_align_err_cnt" "lane_frame_align_err_cnt" } \
  }

adi_add_bus "rx_ilas_config" "master" \
  "analog.com:interface:jesd204_rx_ilas_config_rtl:1.0" \
  "analog.com:interface:jesd204_rx_ilas_config:1.0" \
  { \
    { "ilas_config_valid" "valid" } \
    { "ilas_config_addr" "addr" } \
    { "ilas_config_data" "data" } \
  }

adi_add_bus "rx_event" "master" \
  "analog.com:interface:jesd204_rx_event_rtl:1.0" \
  "analog.com:interface:jesd204_rx_event:1.0" \
  { \
    { "event_sysref_alignment_error" "sysref_alignment_error" } \
    { "event_sysref_edge" "sysref_edge" } \
    { "event_frame_alignment_error" "frame_alignment_error" } \
    { "event_unexpected_lane_state_error" "unexpected_lane_state_error" } \
  }

adi_add_bus_clock "clk" "rx_cfg:rx_ilas_config:rx_event:rx_status:rx_data" "reset"

adi_set_bus_dependency "rx_ilas_config" "rx_ilas_config" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

adi_set_ports_dependency "sync" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

adi_set_ports_dependency "phy_en_char_align" \
	"(spirit:decode(id('MODELPARAM_VALUE.LINK_MODE')) = 1)"

set cc [ipx::current_core]

set_property -dict [list \
  driver_value 0 \
] [ipx::get_ports phy_header -of_objects $cc]

# Arrange GUI page layout
set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

# Link layer mode
set p [ipgui::get_guiparamspec -name "LINK_MODE" -component $cc]
ipgui::move_param -component $cc -order 0 $p -parent $page0
set_property -dict [list \
 "display_name" "Link Layer mode" \
 "tooltip" "Link Layer mode" \
 "widget" "comboBox" \
] $p

set_property -dict [list \
  value_validation_type pairs \
  value_validation_pairs {64B66B 2 8B10B 1} \
] [ipx::get_user_parameters $p -of_objects $cc]

# Data width selection
set param [ipx::get_user_parameters DATA_PATH_WIDTH -of_objects $cc]
set_property -dict [list \
  enablement_value false \
  value_tcl_expr {expr $LINK_MODE*4} \
] $param


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

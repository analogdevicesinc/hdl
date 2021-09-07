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

adi_ip_create jesd204_versal_gt_adapter_rx
adi_ip_files jesd204_versal_gt_adapter_rx [list \
  jesd204_versal_gt_adapter_rx.v \
  ../jesd204_common/sync_header_align.v \
  ]

adi_ip_properties_lite jesd204_versal_gt_adapter_rx

set_property display_name "ADI JESD204 Versal Transceiver Rx Lane Adapter" [ipx::current_core]
set_property description "ADI JESD204 Versal Transceiver Rx Lane Adapter" [ipx::current_core]

adi_add_bus "RX_GT_IP_Interface" "master" \
  "xilinx.com:interface:gt_rx_interface_rtl:1.0" \
  "xilinx.com:interface:gt_rx_interface:1.0" \
  { \
   { "rxdata" "ch_rxdata" } \
   { "rxheader" "ch_rxheader" } \
   { "rxgearboxslip" "ch_rxgearboxslip" } \
   { "gtrxreset" "ch_gtrxreset" } \
   { "rxprogdivreset" "ch_rxprogdivreset" } \
   { "rxuserrdy" "ch_rxuserrdy" } \
   { "rxmstreset" "ch_rxmstreset" } \
   { "rxresetdone" "ch_rxresetdone" } \
   { "rxpolarity" "ch_rxpolarity" } \
   { "rxpd" "ch_rxpd" } \

  }

adi_add_bus "RX" "master" \
  "xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_rx_bus:1.0" \
  { \
   { "rx_data" "rxdata" } \
   { "rx_header" "rxheader" } \
   { "rx_block_sync" "rxblock_sync" } \
  }

# Control interface
adi_if_infer_bus analog.com:interface:if_xcvr_ch slave up_rx [list \
  "pll_locked          up_pll_locked  "\
  "rst                 up_rst         "\
  "user_ready          up_user_ready  "\
  "rst_done            up_rst_done    "\
  "prbsforceerr        up_prbsforceerr"\
  "prbssel             up_prbssel     "\
  "lpm_dfe_n           up_lpm_dfe_n   "\
  "rate                up_rate        "\
  "sys_clk_sel         up_sys_clk_sel "\
  "out_clk_sel         up_out_clk_sel "\
  "tx_diffctrl         up_diffctrl     "\
  "tx_postcursor       up_postcursor   "\
  "tx_precursor        up_precursor    "\
  "enb                 up_enb         "\
  "addr                up_addr        "\
  "wr                  up_wr          "\
  "wdata               up_wdata       "\
  "rdata               up_rdata       "\
  "ready               up_ready       "]

ipx::save_core [ipx::current_core]

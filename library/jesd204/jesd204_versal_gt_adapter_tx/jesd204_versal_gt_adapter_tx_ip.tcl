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

adi_ip_create jesd204_versal_gt_adapter_tx
adi_ip_files jesd204_versal_gt_adapter_tx [list \
  jesd204_versal_gt_adapter_tx.v
  ]

adi_ip_properties_lite jesd204_versal_gt_adapter_tx

set_property display_name "ADI JESD204 Versal Transceiver Tx Lane Adapter" [ipx::current_core]
set_property description "ADI JESD204 Versal Transceiver Tx Lane Adapter" [ipx::current_core]

#adi_add_bus "TX_GT_IP_Interface" "master" \
#  "xilinx.com:interface:gt_tx_interface_rtl:1.0" \
#  "xilinx.com:interface:gt_tx_interface:1.0" \
#  { \
#   { "txdata" "ch_txdata" } \
#   { "txheader" "ch_txheader" } \
#   { "gttxreset" "ch_gttxreset" } \
#   { "txprogdivreset" "ch_txprogdivreset" } \
#   { "txuserrdy" "ch_txuserrdy" } \
#   { "txmstreset" "ch_txmstreset" } \
#   { "txresetdone" "ch_txresetdone" } \
#   { "txdiffctrl" "ch_txdiffctrl" } \
#   { "txelecidle" "ch_txelecidle" } \
#   { "txinhibit" "ch_txinhibit" } \
#   { "txpd" "ch_txpd" } \
#   { "txpostcursor" "ch_txpostcursor" } \
#   { "txprecursor" "ch_txprecursor" } \
#  }

adi_add_bus "TX" "slave" \
  "xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_tx_bus:1.0" \
  { \
   { "tx_data" "txdata" } \
   { "tx_header" "txheader" } \
  }

## Control interface
#adi_if_infer_bus analog.com:interface:if_xcvr_ch slave up_tx [list \
#  "pll_locked          up_pll_locked  "\
#  "rst                 up_rst         "\
#  "user_ready          up_user_ready  "\
#  "rst_done            up_rst_done    "\
#  "prbsforceerr        up_prbsforceerr"\
#  "prbssel             up_prbssel     "\
#  "lpm_dfe_n           up_lpm_dfe_n   "\
#  "rate                up_rate        "\
#  "sys_clk_sel         up_sys_clk_sel "\
#  "out_clk_sel         up_out_clk_sel "\
#  "tx_diffctrl         up_diffctrl     "\
#  "tx_postcursor       up_postcursor   "\
#  "tx_precursor        up_precursor    "\
#  "enb                 up_enb         "\
#  "addr                up_addr        "\
#  "wr                  up_wr          "\
#  "wdata               up_wdata       "\
#  "rdata               up_rdata       "\
#  "ready               up_ready       "]

ipx::save_core [ipx::current_core]

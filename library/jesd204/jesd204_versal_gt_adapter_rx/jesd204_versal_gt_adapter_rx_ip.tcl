###############################################################################
## Copyright (C) 2017-2024, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIJESD204
##
## The ADI JESD204 Core is released under the following license, which is
## different than all other HDL cores in this repository.
##
## Please read this, and understand the freedoms and responsibilities you have by
## using this source code/core.
##
## The JESD204 HDL, is copyright (C) 2016-2026 Analog Devices Inc.
##
## This core is free software, you can use run, copy, study, change, ask questions
## about and improve this core. Distribution of source, or resulting binaries
## (including those inside an FPGA or ASIC) require you to release the source of
## the entire project (excluding the system libraries provide by the
## tools/compiler/FPGA vendor). These are the terms of the GNU General Public
## License version 2 as published by the Free Software Foundation.
##
## This core  is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
## PARTICULAR PURPOSE. See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License version 2
## along with this source code, and binary. If not, see
## <http://www.gnu.org/licenses/>.
##
## Commercial licenses (with commercial support) of this JESD204 core are also
## available under terms different than the General Public License (e.g. they do
## not require you to accompany any image (FPGA or ASIC) using the JESD204 core
## with any corresponding source code). For these alternate terms you must
## purchase a license from Analog Devices Technology Licensing Office. Users
## interested in such a license should contact jesd204-licensing@analog.com for
## more information. This commercial license is sub-licensable (if you purchase
## chips from Analog Devices, incorporate them into your PCB level product, and
## purchase a JESD204 license, end users of your product will also have a license
## to use this core in a commercial setting without releasing their source code).
##
## In addition, we kindly ask you to acknowledge ADI in any program, application
## or publication in which you use this JESD204 HDL core. (You are not required to
## do so; it is up to your common sense to decide whether you want to comply with
## this request or not.) For general publications, we suggest referencing: "The
## design and implementation of the JESD204 HDL Core used in this project is
## copyright (C) 2016-2026, Analog Devices, Inc."
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_versal_gt_adapter_rx
adi_ip_files jesd204_versal_gt_adapter_rx [list \
  jesd204_versal_gt_adapter_rx.v \
  lane_align.v \
  ../jesd204_common/sync_header_align.v \
  ../jesd204_common/gearbox_64b66b.v \
  ../jesd204_common/bitslip.v \
  ../jesd204_soft_pcs_rx/jesd204_soft_pcs_rx.v \
  ../jesd204_soft_pcs_rx/jesd204_8b10b_decoder.v \
  ../jesd204_soft_pcs_rx/jesd204_pattern_align.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  jesd204_versal_gt_adapter_rx_constr.ttcl \
  jesd204_versal_gt_adapter_rx_ooc.ttcl \
]

adi_ip_properties_lite jesd204_versal_gt_adapter_rx
adi_ip_ttcl jesd204_versal_gt_adapter_rx "jesd204_versal_gt_adapter_rx_constr.ttcl"
adi_ip_ttcl jesd204_versal_gt_adapter_rx "jesd204_versal_gt_adapter_rx_ooc.ttcl"

set_property display_name "ADI JESD204 Versal Transceiver Rx Lane Adapter" [ipx::current_core]
set_property description "ADI JESD204 Versal Transceiver Rx Lane Adapter" [ipx::current_core]

adi_add_bus "RX" "master" \
  "xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_rx_bus:1.0" \
  { \
   { "rx_data" "rxdata" } \
   { "rx_header" "rxheader" } \
   { "rx_charisk" "rxcharisk"} \
   { "rx_disperr" "rxdisperr"} \
   { "rx_notintable" "rxnotintable"} \
   { "rx_block_sync" "rxblock_sync" } \
  }

adi_add_bus "RX_GT_IP_Interface" "master" \
  "xilinx.com:interface:gt_rx_interface_rtl:1.0" \
  "xilinx.com:interface:gt_rx_interface:1.0" \
  { \
   { "rxdata" "ch_rxdata" } \
   { "rxheader" "ch_rxheader" } \
   { "rxctrl0"  "ch_rxctrl0"  } \
   { "rxctrl1"  "ch_rxctrl1"  } \
   { "rxctrl2"  "ch_rxctrl2"  } \
   { "rxctrl3"  "ch_rxctrl3"  } \
   { "rxslide"  "ch_rxslide" } \
   { "rxheadervalid" "ch_rxheadervalid" } \
   { "rxgearboxslip" "ch_rxgearboxslip" } \
  }

set_property -dict [list \
  value_validation_type list \
  value_validation_list {GTY GTYP GTM} \
] [ipx::get_user_parameters TRANSCEIVER -of_objects [ipx::current_core]]

set_property -dict [list \
  value_validation_type pairs \
  value_validation_pairs {64B66B 2 8B10B 1} \
] [ipx::get_user_parameters LINK_MODE -of_objects [ipx::current_core]]

set_property enablement_dependency {$LINK_MODE == 1} \
  [ipx::get_ports en_char_align -of_objects [ipx::current_core]]

set_property enablement_dependency {$TRANSCEIVER == "GTM" && $LINK_MODE == 2} \
  [ipx::get_ports phy_clk -of_objects [ipx::current_core]]

set_property enablement_dependency {$TRANSCEIVER == "GTM"} \
  [ipx::get_ports phy_rstn -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
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
  value_validation_list {GT GTY GTM} \
] [ipx::get_user_parameters TRANSCEIVER -of_objects [ipx::current_core]]

set_property -dict [list \
  value_validation_type pairs \
  value_validation_pairs {64B66B 2 8B10B 1} \
] [ipx::get_user_parameters LINK_MODE -of_objects [ipx::current_core]]

ipx::save_core [ipx::current_core]

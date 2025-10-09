###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_versal_gt_adapter_tx
adi_ip_files jesd204_versal_gt_adapter_tx [list \
  jesd204_versal_gt_adapter_tx.v \
  ../jesd204_common/gearbox_66b64b.v \
  ../jesd204_soft_pcs_tx/jesd204_soft_pcs_tx.v \
  ../jesd204_soft_pcs_tx/jesd204_8b10b_encoder.v \
  $ad_hdl_dir/library/util_cdc/sync_bits.v \
  jesd204_versal_gt_adapter_tx_constr.ttcl \
  jesd204_versal_gt_adapter_tx_ooc.ttcl \
]

adi_ip_properties_lite jesd204_versal_gt_adapter_tx
adi_ip_ttcl jesd204_versal_gt_adapter_tx "jesd204_versal_gt_adapter_tx_constr.ttcl"
adi_ip_ttcl jesd204_versal_gt_adapter_tx "jesd204_versal_gt_adapter_tx_ooc.ttcl"

set_property display_name "ADI JESD204 Versal Transceiver Tx Lane Adapter" [ipx::current_core]
set_property description "ADI JESD204 Versal Transceiver Tx Lane Adapter" [ipx::current_core]

adi_add_bus "TX_GT_IP_Interface" "master" \
  "xilinx.com:interface:gt_tx_interface_rtl:1.0" \
  "xilinx.com:interface:gt_tx_interface:1.0" \
  { \
   { "txdata" "ch_txdata" } \
   { "txheader" "ch_txheader" } \
   { "txctrl0"  "ch_txctrl0"  } \
   { "txctrl1"  "ch_txctrl1"  } \
   { "txctrl2"  "ch_txctrl2"  } \
  }

adi_add_bus "TX" "slave" \
  "xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0" \
  "xilinx.com:display_jesd204:jesd204_tx_bus:1.0" \
  { \
   { "tx_data" "txdata" } \
   { "tx_header" "txheader" } \
   { "tx_charisk" "txcharisk" } \
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

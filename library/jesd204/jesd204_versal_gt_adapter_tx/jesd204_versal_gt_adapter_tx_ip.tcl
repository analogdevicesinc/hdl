###############################################################################
## Copyright (C) 2017-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIJESD204
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create jesd204_versal_gt_adapter_tx
adi_ip_files jesd204_versal_gt_adapter_tx [list \
  jesd204_versal_gt_adapter_tx.v
  ]

adi_ip_properties_lite jesd204_versal_gt_adapter_tx

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

ipx::save_core [ipx::current_core]

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
  ]

adi_ip_properties_lite jesd204_versal_gt_adapter_rx

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

ipx::save_core [ipx::current_core]

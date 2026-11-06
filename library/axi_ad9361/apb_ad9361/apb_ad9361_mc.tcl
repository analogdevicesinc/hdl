###############################################################################
## Copyright (C) 2026 Analog Devices, Inc. All rights reserved.
## SPDX short identifier: ADIBSD
###############################################################################

# Imports the apb_ad9361 HDL sources for later HDL+ core packaging.
# Sourced within an open Libero project before the helper creates the wrapper.

global ad_hdl_dir

set script_dir [file dirname [file normalize [info script]]]
set ad9361_dir [file join $ad_hdl_dir library axi_ad9361]
set src_file [file join $script_dir apb_ad9361.v]

import_files \
  -library work \
  -hdl_source $src_file \
  -hdl_source [file join $ad9361_dir microchip axi_ad9361_cmos_if.v] \
  -hdl_source [file join $ad9361_dir microchip axi_ad9361_lvds_if.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_rx_pnmon.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_rx_channel.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_rx.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_tx_channel.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_tx.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_tdd.v] \
  -hdl_source [file join $ad9361_dir axi_ad9361_tdd_if.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_addsub.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_datafmt.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds_1.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds_2.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds_cordic_pipe.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds_sine.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_dds_sine_cordic.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_iqcor.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_pnmon.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_pps_receiver.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_rst.v] \
  -hdl_source [file join $ad_hdl_dir library common ad_tdd_control.v] \
  -hdl_source [file join $ad_hdl_dir library common up_adc_channel.v] \
  -hdl_source [file join $ad_hdl_dir library common up_adc_common.v] \
  -hdl_source [file join $ad_hdl_dir library common up_apb.v] \
  -hdl_source [file join $ad_hdl_dir library common up_clock_mon.v] \
  -hdl_source [file join $ad_hdl_dir library common up_dac_channel.v] \
  -hdl_source [file join $ad_hdl_dir library common up_dac_common.v] \
  -hdl_source [file join $ad_hdl_dir library common up_delay_cntrl.v] \
  -hdl_source [file join $ad_hdl_dir library common up_tdd_cntrl.v] \
  -hdl_source [file join $ad_hdl_dir library common up_xfer_cntrl.v] \
  -hdl_source [file join $ad_hdl_dir library common up_xfer_status.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_data_clk.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_iod_delay_ctrl.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_data_in.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_data_out.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_dcfilter.v] \
  -hdl_source [file join $ad_hdl_dir library microchip common ad_mul.v] \
  -hdl_source [file join $ad_hdl_dir library util_cdc sync_bits.v] \
  -hdl_source [file join $ad_hdl_dir library util_cdc sync_data.v]
build_design_hierarchy
